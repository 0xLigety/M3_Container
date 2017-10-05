#!/bin/sh

CAMERA=192.168.88.6
ADDRESS=broker.hivemq.com
PORT=1883
TOPIC="/BaslerQR"
MESSAGE="Test"

mkdir /usr/application/data
./usr/application/BaslerGrabSave ${CAMERA}
MESSAGE = "$(./usr/application/zxing GrabbedImage.png)"
./usr/application/mosquitto_pub -h ${ADDRESS} -p ${PORT} -t ${TOPIC} -m "${MESSAGE}"