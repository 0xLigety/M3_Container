#!/bin/sh

source /usr/application/configuration.config 



#INTERVAL=5
#CAMERA=192.168.88.7
#ADDRESS=192.168.88.49
#PORT=1884
#TOPIC="/Basler"



#Grab image from camera
/usr/application/BaslerGrabSave ${basler_address}
#Read QR Code from grabbed image
MESSAGE=$(/usr/application/zxing /usr/application/GrabbedImage.png)
#Push message to mqtt broker
/usr/application/mosquitto_pub -h ${mosquitto_address} -p ${mosquitto_port} -t ${mosquitto_topic} -m "${MESSAGE}"

