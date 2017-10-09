#!/bin/sh

CONFIG=/usr/application/configuration.config 
INTERVAL=$(awk '/^polling_Interval/{print $3}' "${CONFIG}")
CAMERA=$(awk '/^basler_address/{print $3}' "${CONFIG}")
ADDRESS=$(awk '/^basler_address/{print $3}' "${CONFIG}")
PORT=$(awk '/^mosquitto_port/{print $3}' "${CONFIG}")
TOPIC=$(awk '/^mosquitto_topic/{print $3}' "${CONFIG}")


#INTERVAL=5
#CAMERA=192.168.88.7
#ADDRESS=192.168.88.49
#PORT=1884
#TOPIC="/Basler"
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