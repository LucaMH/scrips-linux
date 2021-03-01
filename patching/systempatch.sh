#!/bin/sh
#DISCLAIMER: if this script breaks your system, it is your fault you ran conde before checking the code, always check code which you dont own before running it!
#current release 20200301-1143

#get distro

if [ -f hostnamectl ]; then
MYDISTRO=$(hostnamectl | grep "Operating System:")
MYDISTRO=${MYDISTRO:20}
fi

#UPDATE APPLIANCES
#update pihole if existing
if [ -f /usr/local/bin/pihole ]; then
    pihole -g
    sleep 2s
    pihole -up
    sleep 2s
fi

#UPDATES PIP SUFFS
#update pip if existing (pip2)
if [ -f /usr/local/bin/pip ]; then
    pip install --upgrade pip
    sleep 2s
    pip list --outdated | cut -f1 -d' ' | tr " " "\n" | awk '{if(NR>=3)print}' | cut -d' ' -f1 | xargs -n1 pip install --upgrade
    sleep 2s
fi

#update pip3 if existing (Thanks to @Sagamir)
if [ -f /usr/bin/pip3 ]; then
    pip3 install --upgrade pip
    sleep 2s
    pip3 list --outdated | cut -f1 -d' ' | tr " " "\n" | awk '{if(NR>=3)print}' | cut -d' ' -f1 | xargs -n1 pip install --upgrade
    sleep 2s
fi

exit
#todo: add patching for different distros


#distro switcher
