#!/bin/sh
if [ "$(lipc-get-prop com.lab126.wifid cmState)" = "CONNECTED" ] ; then
  wget -qO- "http://yourserver.com/static/my_kindle.png" > /mnt/us/screensaver/my.png

  if [ "$(cat /proc/keypad)" = "keypad is locked" ] ; then
    eips -g /mnt/us/screensaver/my.png
    eips 17 1 "$(date +%F\ %R)"
  fi
fi
