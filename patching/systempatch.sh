#!/bin/sh
#current release 20200301-11




#update pihole if existing
if [ -f /usr/local/bin/pihole ]; then
    pihole -g
    sleep 2s
    pihole -up
    sleep 2s
fi