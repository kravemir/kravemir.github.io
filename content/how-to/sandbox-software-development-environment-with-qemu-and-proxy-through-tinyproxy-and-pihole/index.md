---
title: Sandbox software development in QEMU VM
subtitle: With traffic going through Tinyproxy resolving against Pi-hole, and seamless Wayland windowing

date: '2025-11-23T09:40:00+01:00'

keywords:
  - QEMU
  - Software Development
  - Sandbox
  - Wayland
  - GUI

description: Supply chain attacks impact mitigation by isolation of software development in VM. Combined with Tinyproxy and Pi-hole. Retaining comfortable host's windowing system by proxying GUI with Waypipe to host.  

intro: |
  Supply chain **attacks via dependencies** downloaded **from package registries** happen.
  
  The **weakest link in security** of my own computer **is actually me**, and **working with various libraries**, that could pose a threat.

  Auditing all libraries used in my experiments is not practically possible with the low amount free time available, that I want to spend more productively.

  However, **isolation** of my software development experimenting hobby **should give me some bit of a safety net**.
---

## Warning

I managed to freeze GNOME's Mutter a few times while experimenting with things, before. When things froze, it was not possible to switch to TTY.

Although it happened while experimenting with sommelier and XWayland before, and didn't happen since...

Make sure you have your work saved!

_(if you were to try this)_

## Goals

Isolation of software development _(ideally)_:

- **internet and git** access required,
- isolated execution (of whatever any library does) from host,
- observable traffic.

Seamless windowing requirement:

- host's multiscreen setup,
- different HiDPI-scaling and refresh rates,
- no VM virtual display(s) as windows on host.

Freedom of choice - not coupled to a vendor:

- distribution agnostic.

## Solution composition diagram

![./qemu-isolated-dev-env.svg](./qemu-isolated-dev-env.svg)

## Host podman

For graphical applications, Wayland needs to be exposed somehow.

This guide uses Waypipe with vsock.

And, this will run a Podman container.

### Waypipe docker image

Create `waypipe.Dockerfile`:

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

### Podman

Create `podman-compose.yaml`:

```yaml
x-podman:
  in_pod: false

services:
  waypipe:
    image: waypipe
    build:
      context: ..
      dockerfile: waypipe.Dockerfile
    userns_mode: keep-id:uid=1000,gid=100
    devices:
      - /dev/vhost-vsock
    environment:
      WAYLAND_DISPLAY: $WAYLAND_DISPLAY
      XDG_RUNTIME_DIR: /tmp
    volumes:
      - '$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY:ro,Z'
    restart: "no"
```

### Start up

```shell
podman compose up -d
```

## Proxy VM

### Configuration

Create `meta-data`:

```yaml
instance-id: fedora-proxy
local-hostname: fedora-proxy
```

Create `network-config`:

```yaml
network:
  version: 1
  config:
  - type: physical
    name: ens4
    subnets:
    - type: dhcp
  - type: physical
    name: ens5
    subnets:
    - type: static
      address: 192.168.76.11/24
```

Explanation:

- this will run with two network connections, one to internet and other one internal to expose proxy to DEV VM,
- QEMU's user type of network with internet connection ends up being `ens4`,
- QEMU's socket type of network for internal communication ends up being `ens5`,
  - it's without DHCP and static configuration needs to be set up.

Create `user-data`:

```yaml
#cloud-config

# user and password
system_info:
    default_user:
        name: fedora
chpasswd:
    list: |
        fedora:fedora
    expire: False
ssh_pwauth: False

# filesystem
resize_rootfs: True

# packages
packages:
- podman-compose

# write setup with cloud-init
write_files:
- path: /opt/podman-services/alpine-tinyproxy.Dockerfile
  content: |
    FROM alpine:3.22
    RUN apk add --no-cache tinyproxy
    USER nobody
    CMD ["tinyproxy", "-d", "-c", "/etc/tinyproxy/tinyproxy.conf"]
- path: /opt/podman-services/tinyproxy-http.conf
  owner: fedora:fedora
  defer: true
  content: |
    User nobody
    Group nogroup
    Port 8888
    Listen 0.0.0.0
    Timeout 600
    LogLevel Info
    PidFile "/tmp/tinyproxy.pid"
    MaxClients 100
    Allow 0.0.0.0/0
    ConnectPort 443
    DisableViaHeader Yes
- path: /opt/podman-services/tinyproxy-ssh.conf
  owner: fedora:fedora
  defer: true
  content: |
    User nobody
    Group nogroup
    Port 8822
    Listen 0.0.0.0
    Timeout 600
    LogLevel Info
    PidFile "/tmp/tinyproxy.pid"
    MaxClients 100
    Allow 0.0.0.0/0
    ConnectPort 22
    DisableViaHeader Yes
    
    # set filter and by default deny - filter is allow-list
    Filter "/etc/tinyproxy/filter"
    FilterDefaultDeny Yes
- path: /opt/podman-services/tinyproxy-ssh.filter
  owner: fedora:fedora
  defer: true
  content: |
    # allow only github
    github.com
- path: /opt/podman-services/podman-compose.yaml
  content: |
    services:
      tinyproxy-http:
        image: alpine-tinyproxy
        build:
          context: .
          dockerfile: alpine-tinyproxy.Dockerfile
        depends_on:
          - pihole
        dns:
          - 10.0.21.2
        ports:
          - '8443:8888'
        volumes:
          - './tinyproxy-http.conf:/etc/tinyproxy/tinyproxy.conf:ro,Z'
        networks:
          shared_bridge: {}
        restart: "always"
      tinyproxy-ssh:
        image: alpine-tinyproxy
        build:
          context: .
          dockerfile: alpine-tinyproxy.Dockerfile
        depends_on:
          - pihole
        dns:
          - 10.0.21.2
        ports:
          - '8222:8822'
        volumes:
          - './tinyproxy-ssh.conf:/etc/tinyproxy/tinyproxy.conf:ro,Z'
          - './tinyproxy-ssh.filter:/etc/tinyproxy/filter:ro,Z'
        networks:
          shared_bridge: {}
        restart: "always"
      pihole:
        image: pihole/pihole:2025.10.3
        environment:
          TZ: "Europe/Bratislava"
          FTLCONF_webserver_api_password: 'admin'
          DNSMASQ_LISTENING: all
        ports:
          # allow external access to Pi-hole admin
          - "192.168.75.11:8080:80/tcp"
        networks:
          shared_bridge:
            ipv4_address: 10.0.21.2
        restart: "always"
    networks:
      shared_bridge:
        driver: bridge
        ipam:
          config:
            - subnet: 10.0.21.0/24
              ip_range: 10.0.21.128/25
```

Explanation:

1. set up user and basic configuration,
2. install `podman-compose`,
3. use `write_files` to initialize configuration in declarative approach:
   - `alpine-tinyproxy.Dockerfile` for Tinyproxy image,
   - `tinyproxy-http.conf` for HTTP(S) Tinyproxy configuration,
   - `tinyproxy-ssh.conf` and `tinyproxy-ssh.filter` for SSH Tinyproxy configuration,
   - `podman-compose.yaml` for starting things declaratively.

### Setup

To set this up, first create disk image(s):

```shell
# create working disk for VM
# assuming Fedora cloud is downloaded at ../fedora-cloud-base.qcow2 
qemu-img \
  create \
  -f qcow2 -F qcow2 \
  -b ../fedora-cloud-base.qcow2 \
  fedora-cloud-proxy.qcow2 \
  20G

# create initialization ISO
genisoimage -output seed.iso -volid cidata -joliet -rock \
  user-data \
  meta-data \
  network-config
```

Launch with init:

```shell
# start VM
qemu-system-x86_64 \
  -accel kvm \
  -smp 4 \
  -m size=4G \
  -cdrom seed.iso \
  -hda fedora-cloud-proxy.qcow2 \
  -device vhost-vsock-pci,guest-cid=4  \
  -netdev user,id=proxy-net,net=192.168.75.0/24,hostfwd=tcp:127.0.0.1:8080-:8080,dhcpstart=192.168.75.11 \
  -netdev socket,id=dev-proxy,listen=127.0.0.1:9100 \
  -device e1000,netdev=proxy-net \
  -device e1000,netdev=dev-proxy \
  -nographic
  
  # in VM, launch podman services
  cd /opt/podman-services
  podman compose up -d
```

Specifics explanation:

- `-netdev user,...` is to connect this to internet,
- `-netdev socket,...listen...` - is to create internal network.

## DEV VM

### Configuration

Create `meta-data`:

```yaml
instance-id: fedora-dev
local-hostname: fedora-dev
```

Create `network-config`:

```yaml
network:
  version: 1
  config:
    - type: physical
      name: ens4
      subnets:
        - type: static
          address: 192.168.76.21/24
```

Explanation:

- this will run one network connection, to connect to Proxy VM,
- QEMU's socket type of network for internal communication ends up being `ens4`,
  - it's without DHCP and static configuration needs to be set up.

Create `user-data`:

```yaml
#cloud-config

# user and password
system_info:
  default_user:
    name: fedora
chpasswd:
  list: |
    fedora:fedora
  expire: False
ssh_pwauth: False

# filesystem
resize_rootfs: True

# packages
packages:
  - waypipe
  - gnome-builder

write_files:
  - path: /etc/yum.conf
    content: |
      proxy=http://192.168.76.11:8443
    append: true
  - path: /etc/dnf/dnf.conf
    content: |
      proxy=http://192.168.76.11:8443
    append: true
  - path: /etc/environment
    content: |
      http_proxy=http://192.168.76.11:8443
      https_proxy=http://192.168.76.11:8443
    append: true
  - path: /home/fedora/.ssh/config
    content: |
      Host *
        ProxyCommand=nc -X connect -x 192.168.76.11:8222 %h %p
```

Explanation:

1. set up user and basic configuration,
2. install:
   - `waypipe` - connect to host's waypipe,
   - `gnome-builder` - I actually don't use it. It's the fist wayland-native IDE I found in Fedora packages. Will iterate on it later.
3. use `write_files` to initialize configuration in declarative approach:
  - configure HTTP(S) proxy for package manages in `/etc/yum.conf` and `/etc/dnf/dnf.conf`,
  - configure HTTP(S) proxy for environment in `/etc/environment`,
  - configure SSH proxy for user in `/home/fedora/.ssh/config`:
    - `ProxyCommand` - uses `nc` to establish connection.

### Setup

To set this up, first create disk image(s):

```shell
# create working disk for VM
# assuming Fedora cloud is downloaded at ../fedora-cloud-base.qcow2 
qemu-img \
  create \
  -f qcow2 -F qcow2 \
  -b ../fedora-cloud-base.qcow2 \
  fedora-cloud-dev.qcow2 \
  20G

# create initialization ISO
genisoimage -output seed.iso -volid cidata -joliet -rock \
  user-data \
  meta-data \
  network-config
```

Launch with init:

```shell
# start VM
qemu-system-x86_64 \
  -accel kvm \
  -smp 4 \
  -m size=4G \
  -cdrom seed.iso \
  -hda fedora-cloud-dev.qcow2 \
  -device vhost-vsock-pci,guest-cid=3  \
  -netdev socket,id=dev-proxy,connect=127.0.0.1:9100 \
  -device e1000,netdev=dev-proxy \
  -nographic
  
  # in VM, try ssh
  ssh git@github.com -o "ProxyCommand=nc -X connect -x 192.168.76.11:8222 %h %p"
  
  # Wayland GUI also works
  waypipe --vsock --socket 2:1234 server gnome-builder
```

Specifics explanation:

- `-netdev socket,...connect...` - is to connect to internal network.

## Further improvements

Which IDE:

- my favourite JetBrains IDE(s) don't support Wayland natively, yet.

Further security:

- firewalling of proxy VM (?),
- hardening access to exposed Wayland:
  - some Wayland protocols might be insecure or leaking things,
  - proxying connection through some Wayland compositor to filter Wayland protocols would fix this,
  - Waypipe officially doesn't have security as a goal.
- allow-list on HTTP(s) traffic instead of deny-list,
- add IDS/IPS to the mix?

Host OS:

- what if host gets compromised?
- minimal base OS:
  - no apps on the host OS,
- which distro is ideal?

## Security

This provides some amount of extra security by isolation.

As mentioned above, Wayland is exposed without any security enhancements. And, attacks targeted at Wayland could potentially escape to host.

And, probably needs further hardening besides Wayland thing.

For the best confidence against malware, which comes at expense of comfort and convenience, QubesOS is praised as malware resistant OS.

## Demonstration

Video showing how it works:

{{< youtube "aKRLjVdRWvk" >}}

## References

Used sources for knowledge:
- https://wiki.qemu.org/Documentation/Networking
- https://tinyproxy.github.io/
- https://cloudinit.readthedocs.io/en/latest/index.html
- https://stackoverflow.com/questions/19161960/connect-with-ssh-through-a-proxy.

Sources for used software:

- [Fedora Cloud Download](https://fedoraproject.org/cloud/download/).
Related posts:

- [Qubes-lite with KVM and Wayland](https://roscidus.com/blog/blog/2021/03/07/qubes-lite-with-kvm-and-wayland/).
