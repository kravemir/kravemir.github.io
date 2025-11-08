---
title: Run Wayland apps in Podman in QEMU VM
subtitle: Seamlessly with waypipe through vsock

date: '2025-11-08T21:21:00+01:00'

keywords:
  - QEMU
  - Podman
  - Wayland
  - GUI
  - Containers

description: Using QEMU VM to isolate Wayland apps in container(s) further, but still maintaining comfortable host's windowing system by proxying GUI with waypipe to host.  

intro: |
  Pushing previous containerization of Wayland GUI apps further, to containers in Qemu VM.

  This guide is a proof of concept, and not (yet?) used for daily driving. 
---

## Warning

I managed to freeze GNOME's Mutter a few times while experimenting with things.

When things froze, it was not possible to switch to TTY. 

Make sure you have your work saved! 

## Goals

Seamless windowing requirement:

- host's multiscreen setup,
- different HiDPI-scaling on monitors,
- different refresh rates on monitors,
- no VM virtual display(s) as windows on host.

Isolated execution requirement:

- applications run in their own container,
- workspaces with containers run in their own VM,
- minimum integration (attack surface) between workspace VM and host.

## Solution composition diagram

![./qemu-podman-waypipe.svg](./qemu-podman-waypipe.svg)

## Setup Fedora Cloud VM with QEMU 

First, we prepare ourselves a QEMU VM based on Fedora Cloud distribution.

With downloaded QEMU qcow2 disk image downloaded from [here](https://fedoraproject.org/cloud/download), create image to use for the VM:

```shell
# acquire Fedora Cloud Base Image
cp \
  ~/Downloads/Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2 \
  fedora-cloud-base.qcow2

# create 
qemu-img \
  create \
  -f qcow2 -F qcow2 \
  -b fedora-cloud-base.qcow2 \
  fedora-cloud-vm.qcow2 \
  30G
```

Create ISO with cloud-init data:

- name: `fedora-cloud-for-wayland`,
- username: `fedora`, 
- password: `fedora`.

```shell
# create meta-data file
cat > meta-data << EOF
instance-id: fedora-cloud-for-wayland
local-hostname: fedora-cloud-for-wayland
EOF

# create user-data file
cat > user-data << EOF
#cloud-config
system_info:
    default_user:
        name: fedora
chpasswd:
    list: |
        fedora:fedora
    expire: False
resize_rootfs: True
ssh_pwauth: True
EOF

genisoimage -output seed.iso -volid cidata -joliet -rock user-data meta-data
mkisofs -J -l -R -V "cidata" -iso-level 4 -o seed.iso user-data meta-data
```

Now, launch VM using QEMU:

```shell
# launch
qemu-system-x86_64 \
  -accel kvm \
  -smp 4 \
  -m size=4G \
  -cdrom seed.iso \
  -hda fedora-cloud-vm.qcow2 \
  -device vhost-vsock-pci,guest-cid=3  \
  -nographic
  
# can be stopped with
Ctrl-A x
```

Explanation:

- `qemu-system-x86_64` - qemu for x86_64 machine,
- `-accel kvm` - use KVM based virtualization,
- `-m size=4G` - give it 4GB of RAM,
- `-cdrom seed.iso` - mount cloud-init config,
- `-hda fedora-cloud-vm.qcow2` - mount HDD image,
- `-device vhost-vsock-pci,guest-cid=3` - attach VSOCK device,
- `-nographic` - we don't want graphics on VM level.

## Create Chromium + waypipe container in VM (guest)

In qemu VM, create file `chromium.Dockerfile`:

```Dockerfile
FROM debian:13

# install Chromium, waypipe, and utils for testing
RUN apt-get update && \
    apt-get install -y chromium waypipe && \
    apt-get install -y dnsutils iputils-ping wayland-utils && \
    rm -rf /var/lib/apt/lists/*

# Set non-root user and group
ARG user=appuser
ARG group=appuser
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group} -f
RUN useradd -u ${uid} -g ${group} -m ${user}

USER ${uid}:${gid}

CMD waypipe --vsock --socket 2:1234 server chromium --no-sandbox --ozone-platform=wayland
```

Create another file `firefox.Dockerfile`:

```Dockerfile
FROM debian:13

# install Firefox, waypipe, and utils for testing
RUN apt-get update && \
    apt-get install -y firefox-esr waypipe && \
    apt-get install -y dnsutils iputils-ping wayland-utils && \
    rm -rf /var/lib/apt/lists/*

# Set non-root user and group
ARG user=appuser
ARG group=appuser
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group} -f
RUN useradd -u ${uid} -g ${group} -m ${user}

USER ${uid}:${gid}

ENV MOZ_ENABLE_WAYLAND 1

CMD waypipe --vsock --socket 2:1234 server firefox
```

Build images in the guest:

```
podman build . \
  --file chromium.Dockerfile \
  --build-arg uid=$(id -u) \
  --build-arg gid=$(id -g) \
  -t app-chromium

podman build . \
  --file firefox.Dockerfile \
  --build-arg uid=$(id -u) \
  --build-arg gid=$(id -g) \
  -t app-firefox
```

## Create waypipe container on the host

Create file `waypipe.Dockerfile`:

```Dockerfile
FROM debian:13

# install waypipe
RUN apt-get update && \
    apt-get install -y waypipe && \
    rm -rf /var/lib/apt/lists/*

# Set non-root user and group
ARG user=appuser
ARG group=appuser
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group} -f
RUN useradd -u ${uid} -g ${group} -m ${user}

USER ${uid}:${gid}

CMD waypipe --no-gpu --vsock --socket 2:1234 client
```

Build image on the host:

```
podman build . \
  --file waypipe.Dockerfile \
  --build-arg uid=$(id -u) \
  --build-arg gid=$(id -g) \
  -t waypipe
```

## Run it!

On the host, start waypipe client:

```shell
# might need to modprove vsock
sudo modprobe vsock

# run waypipe in podman container
podman run \
  --device /dev/vhost-vsock \
  -e XDG_RUNTIME_DIR=/tmp \
  -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
  -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY \
  --userns=keep-id:uid=$(id -u),gid=$(id -g) \
  waypipe
```

In the VM (guest), run Chromium (using waypipe) and Firefox:

```shell
podman run \
  --device /dev/vhost-vsock \
  -e XDG_RUNTIME_DIR=/home/appuser \
  --rm \
  -d \
  app-chromium

podman run \
  --device /dev/vhost-vsock \
  -e XDG_RUNTIME_DIR=/home/appuser \
  --rm \
  -d \
  app-firefox
```

## Further improvements

This guide focuses on the proof of concept. Real setup for work would:

 - extract things to variables, such as VM CID(s), waypipe port, VM username and password,
 - add persistent storages to containers,
 - probably do more fine-tuning.

Securing exposure of host's Wayland:

- some Wayland protocols might be insecure or leaking things,
- proxying connection through some Wayland compositor to filter Wayland protocols would fix this,
- waypipe officially doesn't have security as a goal.

## Security

This provides some amount of extra security by isolation.

As mentioned above, Wayland is exposed without any security enhancements. And, attacks targeted at Wayland could potentially escape to host.

For the best confidence against malware, which comes at expense of comfort and convenience, QubesOS is praised as malware resistant OS.

## Demonstration

Video showing how it works:

{{< youtube "8eDKgZFgyEs" >}}

## References

Used sources for knowledge:

- [Quick Fedora Cloud VM w/QEMU](https://gist.github.com/nmilosev/7dfc0d43b4c69c3be84e1ef0f358fe8b),
- [Qemu For Fancy Software Build Environments](https://hiddenalpha.ch/?articleName=qemu-build-vms),
- [Forward multiple Wayland applications via a single `waypipe` connection](https://gist.github.com/pojntfx/32e13d3eda90f34a56913e9fb53e7ac3),
- [waypipe - A transparent proxy for Wayland applications](https://man.archlinux.org/man/extra/waypipe/waypipe.1.en).

Sources for used software:

- [Fedora Cloud Download](https://fedoraproject.org/cloud/download/),
- [Visual Studio Code Download](https://code.visualstudio.com/download#).

Related posts:

- [Qubes-lite with KVM and Wayland](https://roscidus.com/blog/blog/2021/03/07/qubes-lite-with-kvm-and-wayland/),
- [Virtio, vhost, vhost-user, vsock, etc.](https://lencerf.github.io/post/2023-05-28-virtio-vhost-vsock/),
- [Understanding Vsock](https://medium.com/@F.DL/understanding-vsock-684016cf0eb0).
