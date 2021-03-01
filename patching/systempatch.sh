#!/bin/sh
#current release 20200301-1135




#update pihole if existing
if [ -f /usr/local/bin/pihole ]; then
    pihole -g
    sleep 2s
    pihole -up
    sleep 2s
fi


#update pip if existing (pip2)
if [ -f /usr/local/bin/pip ]; then
    pip install --upgrade pip
    sleep 2s
    pip list --outdated | cut -f1 -d' ' | tr " " "\n" | awk '{if(NR>=3)print}' | cut -d' ' -f1 | xargs -n1 pip install --upgrade
    sleep 2s
fi