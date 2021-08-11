#!/bin/bash

CONF=backup.conf
DATA=home.tar.gz

if [[ ! -e $CONF || ! -e $DATA ]];
then
    echo "No backup files found. Please make sure that $CONF and $DATA exist in current directory"
    exit 1
fi

USERNAME=`cat $CONF | grep LOGIN | cut -f2 -d":"`

echo "Trying to restore user: $USERNAME"

USERSHELL=`cat $CONF | grep SHELL | cut -f2 -d":"`
COMMENT=`cat $CONF | grep COMMENT | cut -f2 -d":"`
PASS=`cat $CONF | grep PASS | cut -f2 -d":"`
