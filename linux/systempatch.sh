#!/bin/bash

#RELEASE         : 20200302-2242
#CREATOR         : LucaMH
#CONTRIBUTORS    : Sagamir, ...
#LICENSE         : tbd
#DISCLAIMER      : if this script breaks your system, it is your fault you ran conde before checking the code, always check code which you dont own before running it!
#RUN PROD        : curl -L https://raw.githubusercontent.com/LucaMH/scripted_server_patching/main/linux/systempatch.sh | bash
#RUN DEV         : curl -L https://raw.githubusercontent.com/LucaMH/scripted_server_patching/dev/linux/systempatch.sh #| #bash

#GLOBAL SETTINGS
MYTIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
MYLOGFILE=/tmp/systempatch_scripted__"${MYTIMESTAMP}".log

#get distro
if [ -x "$(command -v hostnamectl)" ]
then
    MYDISTRO=$(hostnamectl | grep "Operating System:")
    MYDISTRO=${MYDISTRO:20}
    echo I am $MYDISTRO
#elif [ -f other  ]
else
    echo "no possibility to set the distro found, will not run systemupdates"
    MYDISTRO=SKIPPSKIPPSKIPP
fi

#update appliances with this function
UPDATE_APPLIANCES () {
    echo "running UPDATE_APPLIANCES section now!"
    
    #update pihole if existing
    echo "trying to updatie pihole"
    if [ -x "$(command -v pihole)" ]
    then
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
    echo "trying to update pip2"
    if [ -x "$(command -v pip2)" ]
    then
        echo "updating pip2"
        pip install --upgrade pip
        sleep 2s
        echo "updating outdated pip2 packages"
        pip list --outdated | cut -f1 -d' ' | awk '{if(NR>=3)print}' | xargs -n1 pip install --upgrade
        sleep 2s
        echo "done"
    else
        echo "there is no pip2"
    fi 

    #update pip3 if existing (Thanks to @Sagamir)
    #echo "trying to update pip3"
    #if [ -x "$(command -v pip3)" ]
    #then
    #    echo "updating pip3"
    #    pip3 install --upgrade pip
    #    sleep 2s
    #    echo "updating outdated pip3 packages"
    #    pip3 list --outdated | cut -f1 -d' ' | tr " " "\n" | awk '{if(NR>=3)print}' | cut -d' ' -f1 | xargs -n1 pip install --upgrade
    #    sleep 2s
    #else
    #    echo "there is no pip3"
    #fi

    #update npm if existing
    echo "trying to update npm"
    if [ -x "$(command -v npm)" ]
    then
        echo "updating npm"
        npm install -g npm
        sleep 2s
        #echo "updating outdated npm packages"
        #npm outdated -g | cut -f1 -d' ' | awk '{if(NR>=2)print}' | xargs -n1 npm update -g
        echo "updating npm packages"
        npm update -g
        sleep 2s
        echo "scanning your projects for vulnerabilities and automatically fixes them"
        npm audit fix
        sleep 2s
        echo "done"
    else
        echo "there is no npm"
    fi

}

UPDATE_APPLIANCES

# skip 

if [[ $MYDISTRO = SKIPPSKIPPSKIPP ]]
then
    echo "exiting du to no hostnamectl"
    exit
else
    echo "going forward to patch the os"
fi



exit
exit
exit
exit
exit
exit
exit
exit
exit
exit
#todo: add patching for different distros

#distro switcher


#update server
#yum
yum -y update

#dnf
dnf update -y -v --refresh

#apt
apt -y update
apt -y upgrade
apt -y full-upgrade
apt -y autoremove


#apt-get
apt-get -y clean
apt-get -y autoclean
apt-get -y update
apt-get -y upgrade
apt-get -y full-upgrade
apt-get -y autoremove
#apt-get -y dist-upgrade #handle with care

#send email to inform updates are done
#to be implemented

#zypper
#zypper refresh
#zypper update
#have to install suse to test that


#sync
#sync - Synchronize cached writes to persistent storage
sync

#reboot
echo "script finished"
echo "rebooting now"
reboot now
systemctl reboot now
shutdown -r now
