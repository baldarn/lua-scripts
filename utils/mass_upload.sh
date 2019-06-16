#! /bin/bash


BIN=nodemcu-uploader
#PORT=/dev/ttyUSB
#PORT=/dev/tty.usbserial-1410

function mcu-upload {
  PORTN=$(seq $1)
  shift 1
  for i in $PORTN; do
	echo $BIN --port ${PORT}${i} $@
	$BIN --port ${PORT} $@
  done
}


if [ $# -lt 2 ]; then
  echo "usage $0 <port_n> <nodemcu-upload-cmd [upload, file erase]> <file or file list>"
fi

#mcu-upload $@
PORTS=$(ls /dev/tty.usbserial-14*)
for i in $PORTS; do
	echo $BIN --port ${i} $@
	$BIN --port ${i} $@
done
