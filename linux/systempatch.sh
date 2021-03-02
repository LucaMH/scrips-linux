#!/bin/sh
#RELEASE     : 20200302-2110
#DISCLAIMER  : if this script breaks your system, it is your fault you ran conde before checking the code, always check code which you dont own before running it!
#RUN PROD    : curl -L https://raw.githubusercontent.com/LucaMH/scripted_server_patching/main/linux/systempatch.sh | bash
#RUN DEV     : curl -L https://raw.githubusercontent.com/LucaMH/scripted_server_patching/dev/linux/systempatch.sh | bash


#GLOBAL SETTINGS
MYTIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
MYLOGFILE=/tmp/systempatch_scripted__"${MYTIMESTAMP}".log

#LETS CREATE SUM FUNCTIONS

#get distro
if [ -f /usr/bin/hostnamectl ]
then
    MYDISTRO=$(hostnamectl | grep "Operating System:")
    MYDISTRO=${MYDISTRO:20}
    echo I am $MYDISTRO
#elif [ -f other  ]
else
    echo "no possibility to set the distro found, will not run systemupdates"
fi

#update appliances with this function
UPDATE_APPLIANCES () {
    echo "running UPDATE_APPLIANCES section now!"

    #update pihole if existing
    if [ -f /usr/local/bin/pihole ]
    then
        echo "updating pihole appliance"
        echo "updating gravity"
        pihole -g
        sleep 2s
        echo "updating pihole"
        pihole -up
        sleep 2s
        echo "pihole done"
    else
        echo "there is no pihole"
    fi


    #update pip if existing (pip2)
    if [ -f /usr/local/bin/pip ]
    then
        echo "updating pip appliance"
        echo "updating pip"
        pip install --upgrade pip
        sleep 2s
        echo "updating outdated pip packages"
        pip list --outdated | cut -f1 -d' ' | tr " " "\n" | awk '{if(NR>=3)print}' | cut -d' ' -f1 | xargs -n1 pip install --upgrade
        sleep 2s
        echo "done"
    else
        echo "there is no pip2"
    fi

    #update pip3 if existing (Thanks to @Sagamir)
    if [ -f /usr/bin/pip3 ]
    then
        echo "updating pip3 appliance"
        echo "updating pip3"
        pip3 install --upgrade pip
        sleep 2s
        echo "updating outdated pip3 packages"
        pip3 list --outdated | cut -f1 -d' ' | tr " " "\n" | awk '{if(NR>=3)print}' | cut -d' ' -f1 | xargs -n1 pip install --upgrade
        sleep 2s
    else
        echo "there is no pip3"
    fi
}

UPDATE_APPLIANCES ()

#exit

if [ ! -f /usr/bin/hostnamectl ]
then
    echo "exiting du to no hostnamectl"
    #exit
fi


exit
#todo: add patching for different distros

#distro switcher


#update server
#centos 7
yum -y update

#centos 8
dnf update -y -v --refresh

#centos stream
dnf update -y -v --refresh

#raspbian
apt -y update
sleep 2s
apt -y upgrade
sleep 2s
#apt-get dist-upgrade -y #be careful with that
#sleep 2s
apt-get clean
sleep 2s
apt -y autoremove
sleep 2s
apt -y autoclean
sleep 2s
sync
sleep 2s

#debian
apt-get update -y
sleep 2s
apt-get upgrade -y
sleep 2s

#ubuntu
apt-get update
sleep 2s
apt-get upgrade -y
sleep 2s
#apt-get dist-upgrade -y #be careful with that
apt-get autoremove -y
sleep 2s
apt-get autoclean -y
sleep 2s

#send email to inform updates are done
#to be implemented

#reboot
echo script finished
echo rebooting now
reboot now
systemctl reboot now

