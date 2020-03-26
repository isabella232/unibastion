# unibastion #

<https://github.com/bitgo/unibastion>

## About ##

A linux unikernel that functions as a bare bones bastion host to act as a
secure gateway to private network resources.

## Requirements ##

### Software ###

* Docker
* Packer
* Qemu

## Build ##

## Unikernel

```
make
```

### Amazon AMI

```
make ami
```

## Develop

### Start VM of latest build

```
make vm
```

### SSH to a booted VM

```
make ssh
```


### Reconfigure image

```
make menuconfig
```

### Start shell in build container

```
make build-shell
```
