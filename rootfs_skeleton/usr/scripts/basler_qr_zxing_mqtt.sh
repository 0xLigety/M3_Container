#!/bin/sh

INTERVAL=5000
CAMERA=192.168.88.7
ADDRESS=192.168.88.49
PORT=1884
TOPIC="/Basler"
MESSAGE="Test"

while [ 1 ]
do
#Grab image from camera
/usr/application/BaslerGrabSave ${CAMERA}
#Read QR Code from grabbed image
MESSAGE= "$(/usr/application/zxing /usr/application/GrabbedImage.png)"
#Push message to mqtt broker
/usr/application/mosquitto_pub -h ${ADDRESS} -p ${PORT} -t ${TOPIC} -m "${MESSAGE}"
#Sleep polling interval
sleep ${INTERVAL}
done