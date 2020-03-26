#!/bin/sh

BOARD_DIR="$(dirname $0)"

cp -f ${HOST_DIR}/lib/grub/i386-pc/boot.img ${BINARIES_DIR}

exit $?
