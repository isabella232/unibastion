#!/usr/bin/make
include config/config.env
export $(shell sed 's/=.*//' config/config.env)
userid = $(shell id -u)
groupid = $(shell id -g)
BOARD := ec2

## Primary Targets

default: image

build-env-run := \
	mkdir -p build && \
	docker run \
		--rm \
		--tty \
		--interactive \
		--name "bastion-build-env" \
		--hostname "bastion-build-env" \
		--volume $(PWD)/build:/home/build \
		--volume $(PWD)/scripts:/home/build/scripts \
		--volume $(PWD)/config:/home/build/config \
		--user $(userid):$(groupid) \
		--env BUILDROOT_GIT_REF \
		--env BOARD=$(BOARD) \
		local/bastion-build-env:latest

.PHONY: build-env
build-env:
	docker build \
		-t local/bastion-build-env:latest \
		-f Dockerfile \
		--build-arg UID="$(userid)" \
		--build-arg GID="$(groupid)" \
		--build-arg DEBIAN_DOCKER_REF \
		.

.PHONY: image
image: build-env
	$(build-env-run) build
	mkdir -p release
	cp build/buildroot/output/images/bzImage release/bzImage

.PHONY: build-shell
build-shell: build-env
	$(build-env-run) shell

.PHONY: menuconfig
menuconfig:
	$(build-env-run) /bin/bash -c "cd buildroot; make menuconfig"
	cat build/buildroot/.config \
	| grep -v '^$$\|^\s*\#' \
	> config/configs/$(BOARD)_defconfig

.PHONY: vm
vm: build-env
	qemu-system-x86_64 \
    	-m 512 \
    	-nographic \
    	-append console=ttyS0 \
    	-kernel release/bzImage \
    	-netdev user,id=eth0,hostfwd=tcp:127.0.0.1:2222-:22 \
    	-device virtio-net,netdev=eth0

.PHONY: ssh
ssh:
	while sleep 1; do \
		ssh \
			-p 2222 \
			-o "UserKnownHostsFile=/dev/null" \
			-o "StrictHostKeyChecking=no" \
			root@localhost; \
	done
