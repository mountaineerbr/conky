#!/bin/bash
#version : v2.6.2

#EDIT
#put your hemisphere here: n for north, s for south
hemisphere=n
#STOP EDIT

#put your Weather Underground address API here
#ask your api at http://api.wunderground.com/
#it is free for a limited amount of calls PLEASE DO NOT KEEP USING MINE!!
#    2d1607634da9eeff    is my personal API

address="http://api.wunderground.com/api/2d1607634da9eeff/alerts/q/BE/Antwerp.json"

killall -STOP conky
killall wget

#wget -O $HOME/.conky/Aurora/wunderground/alert_data.json $address

#Alert
#data=${exec cat $HOME/.conky/Aurora/wunderground/alert_data.json | grep -Po '"message":.*?[^\\]",'}
${iconv_start UTF-8 ISO_8859-1}é§iûîçà data ${iconv_stop}
cat $data

killall -CONT conky
