# Send temperature and pression 

This LUA script is for ESP8266 hardware.

## Description

Read BMP180 data (temperature and pression).

Web server waiting for request to send data.

## Principle

1. Connect to a wifi AP
2. Start a web server and wait for HTTP request
3. If request is ```/temp```, return BMP180 temperature value in response
3. If request is ```/pres```, return BMP180 pression value in response
3. If request is ```/reset```, restart the device

## Scheme

![scheme](https://github.com/Wifsimster/bmp180/blob/master/scheme.png)
