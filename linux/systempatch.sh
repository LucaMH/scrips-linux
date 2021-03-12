#!/bin/bash
exit
#RELEASE         : 20210312-2340
#CREATOR         : LucaMH
#CONTRIBUTORS    : Sagamir
#LICENSE         : tbd
#DISCLAIMER      : if this script breaks your system, it is your fault you ran conde before checking the code, always check code which you dont own before running it!
#RUN PROD        : curl -L https://raw.githubusercontent.com/LucaMH/scripted_server_patching/main/linux/systempatch.sh | bash
#RUN DEV         : curl -L https://raw.githubusercontent.com/LucaMH/scripted_server_patching/dev/linux/systempatch.sh | #bash

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
    MYDISTRO=none
fi

#RUNNING UPDATES
UPDATE_APPLIANCES
UPDATE_OS


#sync
#sync - Synchronize cached writes to persistent storage
if [ -x "$(command -v sync)" ]
then
    sync
fi

#reboot
echo "script finished"
echo "rebooting now"
reboot now
systemctl reboot now
shutdown -r now

exit


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

UPDATE_OS () {

    #dnf&yum
    if [ -x "$(command -v dnf)" ] | [ -x "$(command -v yum)" ];
        if [ -x "$(command -v dnf)" ]
        then
            echo "dnf found"
            dnf update -y -v --refresh
        else
            echo "yum found"
            yum update -y 
        fi
    fi


   #apt&apt-get
    if [ -x "$(command -v apt)" ] | [ -x "$(command -v apt-get)" ];
        if [ -x "$(command -v apt)" ]
        then
            echo "apt found"
            apt -y clean
            apt -y update
            apt -y full-upgrade
            apt -y autoremove
        else
            echo "apt-get found"
            apt-get -y clean
            apt-get -y update
            apt-get -y full-upgrade
            apt-get -y autoremove
            #apt-get -y dist-upgrade #handle with carey 
        fi
    fi


    #send email to inform updates are done
    #to be implemented

    #zypper
    #if [ -x "$(command -v zypper)" ]
    #then
    #    zypper refresh
    #    zypper update
    #fi

    #have to install suse to test that
}
