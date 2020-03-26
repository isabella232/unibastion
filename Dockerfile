ARG DEBIAN_DOCKER_REF

FROM debian:buster@sha256:${DEBIAN_DOCKER_REF}

ARG UID=1000
ARG GID=1000

ENV HOME=/home/build
ENV PATH=/home/build/scripts:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y \
    bash-completion \
    build-essential \
    libssl-dev \
    libelf-dev \
    sudo \
    wget \
    cpio \
    python \
    file \
    unzip \
    rsync \
    bc \
    git \
    libncurses-dev \
    qemu \
    qemu-system-x86

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN groupadd -g ${GID} -o build
RUN useradd -G sudo -g ${GID} -u ${UID} -ms /bin/bash build

USER build
WORKDIR /home/build

CMD [ "/bin/bash", "/home/build/scripts/build" ]
