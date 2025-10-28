---
title: Run graphical application in a container
subtitle: With docker and podman, sommelier, Wayland and XWayland

keywords:
  - Wayland
  - Containers
  - Docker
  - Podman
  - Sommelier

date: 2025-10-19T12:13:28+02:00

description: Guide with examples describing how to run Wayland a X applications in containers, using docker and podman.

intro: Creation of isolated environment in declarative way to run graphical application.
---

Chromium is picked as an application for demonstration, because it's one I know where it's possible to easily to select and force application to use Wayland or X11 backend.

It also provides `chrome://gpu/` to some details to check things, and it can run WebGL also with software rendering.

## Step one - direct wayland connection

Starting simple:

1. create base image with Chromium,
2. run container:
   - pass host's Wayland socket,
   - application connects to host's Wayland directly through socket.

Create base image `chromium-only.Dockerfile`:

```Dockerfile
FROM debian:12

RUN apt-get update && \
    apt-get install -y chromium && \
    rm -rf /var/lib/apt/lists/*

# Set non-root user and group
ARG user=appuser
ARG group=appuser
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group} -f
RUN useradd -u ${uid} -g ${group} -m ${user}

USER ${uid}:${gid}
```

Build the image with docker or podman:

```shell
docker build . \
  --file chromium-only.Dockerfile \
  --build-arg uid=$(id -u) \
  --build-arg gid=$(id -g) \
  -t debian-with-chromium
  
podman build . \
  --file chromium-only.Dockerfile \
  --build-arg uid=$(id -u) \
  --build-arg gid=$(id -g) \
  -t debian-with-chromium
```

Run Chromium in the container:

```shell
docker run -e XDG_RUNTIME_DIR=/tmp \
           -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
           -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY  \
           debian-with-chromium \
           chromium --no-sandbox --ozone-platform=wayland
           
podman run -e XDG_RUNTIME_DIR=/tmp \
           -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
           -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY  \
           --userns=keep-id:uid=$(id -u),gid=$(id -g) \
           debian-with-chromium \
           chromium --no-sandbox --ozone-platform=wayland
```

Notes:

- Chromium's sandbox requires extra capabilities, that are not given to container, so running with `--no-sandbox`,
- podman needs extra configuration to not get permission denied, which can be done with `--userns=keep-id:uid=$(id -u),gid=$(id -g)`,
- running with `--ozone-platform=x11` will fail.

## Step two - through sommelier (same container)

Add sommelier to the mix:

1. create base image with Chromium & sommelier installed,
2. run container:
   - pass host's Wayland socket,
   - sommelier connects to host's Wayland,
   - applications connects to sommelier. 

```dockerfile
FROM debian:12

RUN apt-get update && \
    apt-get install -y git meson libwayland-bin python3-jinja2 build-essential pkg-config cmake libgbm-dev libdrm-dev libpixman-1-dev librust-wayland-client-dev xcb libxcb-render-util0-dev libxcb-composite0-dev libxkbcommon-dev && \
    apt-get install -y chromium && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp-sommelier-build && \
    cd /tmp-sommelier-build && \
    git clone https://chromium.googlesource.com/chromiumos/platform2 --depth 1 && \
    cd platform2/vm_tools/sommelier/ && \
    meson setup build -Dwith_tests=false && \
    meson compile -C build && \
    meson install -C build && \
    cd / && \
    rm -rf /tmp-sommelier-build


RUN apt-get update && \
    apt-get install -y xwayland && \
    rm -rf /var/lib/apt/lists/*

# Set non-root user and group
ARG user=appuser
ARG group=appuser
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group} -f
RUN useradd -u ${uid} -g ${group} -m ${user}

USER ${uid}:${gid}
```

```shell
docker build . \
  --file chromium-sommelier.Dockerfile \
  --build-arg uid=$(id -u) \
  --build-arg gid=$(id -g) \
  -t debian-with-chromium-sommelier
  
podman build . \
  --file chromium-sommelier.Dockerfile \
  --build-arg uid=$(id -u) \
  --build-arg gid=$(id -g) \
  -t debian-with-chromium-sommelier
```

Run Chromium in the container through sommelier - Wayland:

```shell
docker run -e XDG_RUNTIME_DIR=/tmp \
           -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
           -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY  \
           debian-with-chromium-sommelier \
           sommelier --display=$WAYLAND_DISPLAY --noop-driver chromium --no-sandbox --ozone-platform=wayland
           
podman run -e XDG_RUNTIME_DIR=/tmp \
           -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
           -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY  \
           --userns=keep-id:uid=$(id -u),gid=$(id -g) \
           debian-with-chromium-sommelier \
           sommelier --display=$WAYLAND_DISPLAY --noop-driver chromium --no-sandbox --ozone-platform=wayland
```

Run Chromium in the container through sommelier providing XWayland proxy for X11 clients:

```shell
docker run -e XDG_RUNTIME_DIR=/tmp \
           -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
           -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY  \
           debian-with-chromium-sommelier \
           sommelier --display=$WAYLAND_DISPLAY --noop-driver -X --xwayland-path=/usr/bin/Xwayland chromium --no-sandbox --ozone-platform=x11

podman run -e XDG_RUNTIME_DIR=/tmp \
           -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
           -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY  \
           --userns=keep-id:uid=$(id -u),gid=$(id -g) \
           debian-with-chromium-sommelier \
           sommelier --display=$WAYLAND_DISPLAY --noop-driver -X --xwayland-path=/usr/bin/Xwayland chromium --no-sandbox --ozone-platform=x11
```

Check outputs of `wayland-info`:

```shell
docker run ... debian-with-chromium-sommelier \
           wayland-info
```

```shell
docker run ... debian-with-chromium-sommelier \
           sommelier --display=$WAYLAND_DISPLAY --noop-driver wayland-info
```

Notes:

- development packages to build sommelier not required to run are present in the final image (I'll eventually iterate on this and clean up),
- uses `--noop-driver` which simply forwards buffers to host without any special processing.

## Step three - separate sommelier and application containers

Sorry, not achieved.

The idea is to have separate containers:

- container for parent sommelier proxying Wayland to apps,
  - access to host's Wayland through socket, 
- container with app
  - no access to host's Wayland,
  - access to sommelier through socket.

This seems to not be possible with the latest version of sommelier, and I have not tried previous versions.

The `noop` shm and data driver was removed with [this commit](https://chromium.googlesource.com/chromiumos/platform2/+/180e42dbd81e0a675b476e824e22bdb28d653a93) in 2021.

## Final step - docker compose

With the limitations of not doing separation,...

Create `docker-compose.yaml`:

```yaml
services:
  chromium:
    image: debian-with-chromium-sommelier
    build:
      context: .
      dockerfile: chromium-sommelier.Dockerfile
      args:
        uid: "$USER_UID"
        gid: "$USER_GID"
    environment:
      XDG_RUNTIME_DIR: /tmp
      WAYLAND_DISPLAY: $WAYLAND_DISPLAY
    volumes:
      - type: bind
        source: $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY
        target: /tmp/$WAYLAND_DISPLAY
    command: sommelier --display=$WAYLAND_DISPLAY --noop-driver chromium --no-sandbox --ozone-platform=wayland
```

Run docker compose:

```shell
USER_UID=$(id -u) USER_GID=$(id -g) docker compose up

# if rebuild is needed:
USER_UID=$(id -u) USER_GID=$(id -g) docker compose up --build 
```

Create `podman-compose.yaml`:

```yaml
x-podman:
  in_pod: false
  
services:
  chromium:
    image: debian-with-chromium-sommelier
    build:
      context: .
      dockerfile: chromium-sommelier.Dockerfile
      args:
        uid: "$USER_UID"
        gid: "$USER_GID"
    userns_mode: "keep-id:uid=$USER_UID,gid=$USER_GID"
    environment:
      XDG_RUNTIME_DIR: /tmp
      WAYLAND_DISPLAY: $WAYLAND_DISPLAY
    volumes:
      - type: bind
        source: $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY
        target: /tmp/$WAYLAND_DISPLAY
    command: sommelier --display=$WAYLAND_DISPLAY --noop-driver chromium --no-sandbox --ozone-platform=wayland
```

Run podman compose:

```shell
USER_UID=$(id -u) USER_GID=$(id -g) podman-compose up

# if rebuild is needed:
USER_UID=$(id -u) USER_GID=$(id -g) podman-compose up --build 
```

## Security notes

While this provides isolation through containers, I have NOT done a security research.

At minimum, the attack surface is following:

- exploits (if present) in docker or podman container technology (or misconfiguration),
- exploits (if present) in host's Wayland compositor that are executable through socket connection,
- exploits (if present) in Wayland's protocols that can leak things.

Notes:

- sommelier is maybe redundant, because socket to host's wayland is present in the application's container.

If the purpose is not security, but work organization into some reproducible workspaces, setups, throwaway experiment environments, running apps on top of different base distributions.... then this approach should be fine.

For full confidence in isolation (against malware), go with [Qubes OS](https://www.qubes-os.org/).

## References:

Things mentioned:

- [sommelier](https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/vm_tools/sommelier/) - Wayland proxy compositor.

Used sources:

- [answer](https://unix.stackexchange.com/a/359244/13428) on Unix & Linux Stack Exchange - bind-mounting essential wayland pieces.
- [crosvm's docs on wayland](https://chromium.googlesource.com/chromiumos/platform/crosvm/+/refs/heads/main/docs/book/src/devices/wayland.md) - sommelier build steps.
