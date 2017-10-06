#!/bin/sh

INTERVAL=3000
CAMERA=192.168.88.6
ADDRESS=broker.hivemq.com
PORT=1883
TOPIC="/BaslerQR"
MESSAGE="Test"

while [ 1 ]
do
#Grab image from camera
/usr/application/BaslerGrabSave ${CAMERA}
#Read QR Code from grabbed image
MESSAGE= "$(/usr/application/zxing GrabbedImage.png)"
#Push message to mqtt broker
/usr/application/mosquitto_pub -h ${ADDRESS} -p ${PORT} -t ${TOPIC} -m "${MESSAGE}"
#Sleep polling interval
sleep ${INTERVAL}
done