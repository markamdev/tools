#!/bin/bash

CONF=backup.conf
DATA=home.tar.gz
GRPS=groups.list

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

echo "Creating user account ..."
useradd -s $USERSHELL -p \'$PASS\' -c \"$COMMENT\" $USERNAME

echo "Adding user to selected groups ..."
for grp in `cat $GRPS`
do
    EXIST=$(cat /etc/group | cut -f1 -d ":" | grep -c $grp)
    if [ $EXIST -eq 1 ]
    then
        echo "- $grp"
        usermod -a -G $grp $USERNAME
    else
        echo "(skipping non-existing group $grp)"
    fi
done
