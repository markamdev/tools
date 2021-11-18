#!/bin/bash

if [ -z $1 ];
then
    echo "No username specifed"
    exit 1
fi

if [ `id -u` -ne 0 ];
then
    echo "Script has to be launched as root"
    exit 1
fi

SCRIPTDIR=$(dirname $0)

USERNAME=$1

echo "Saving account for user '$USERNAME'"

USERLINE=`grep $USERNAME /etc/passwd`

if [ $? -ne 0 ];
then
    echo "Failed to get user info from /etc/passwd. Does user $USERNAME exist?"
    exit 1
fi

COMMENT=$(echo $USERLINE| cut -d':' -f 5)
HOMEDIR=$(echo $USERLINE| cut -d':' -f 6)
USERSHELL=$(echo $USERLINE| cut -d':' -f 7)
PASSWORD=$(grep $USERNAME /etc/shadow | cut -d":" -f2)

echo "Saving user configuration"
echo "- homedir: $HOMEDIR"
echo "- shell: $USERSHELL"
echo "- comment: $COMMENT"
echo "- password hash: $PASSWORD"

if [ -d $USERNAME ];
then
    echo "Backup directory ./$USERNAME already exist"
    echo "Rename/remove it and launch script again"
    exit 1
else
    mkdir $USERNAME
fi

touch $USERNAME/backup.conf
echo "LOGIN:$USERNAME" >> "$USERNAME/backup.conf"
echo "HOME:$HOMEDIR" >> "$USERNAME/backup.conf"
echo "SHELL:$USERSHELL" >> "$USERNAME/backup.conf"
echo "COMMENT:$COMMENT" >> "$USERNAME/backup.conf"
echo "PASS:$PASSWORD" >> "$USERNAME/backup.conf"

echo "Saving user groups ..."
touch "$USERNAME/groups.list"
grep "$USERNAME" /etc/group | cut -f1 -d ":" > "$USERNAME/groups.list"

echo "Saving homedir - this can take a long time ..."
OUTPUT=$PWD/$USERNAME

(
    cd "$HOMEDIR" || exit 1
    tar czf "$OUTPUT/home.tar.gz" ./
)

# check if user home directory is encrypted (and save encrypted data)
if [[ -e "$HOMEDIR/.ecryptfs" && -e "$HOMEDIR/.Private" ]]
then
    echo "WARNING: This user has encrypted home directory. Rember to save password and/or decryption key !!"
    echo "ENCRYPTED:true" >> "$USERNAME/backup.conf"

    ECRYPT_PATH=$(dirname $(realpath "$HOMEDIR/.ecryptfs") )
    PRIVATE_PATH=$(dirname $(realpath "$HOMEDIR/.Private") )

    echo "TEST: E_PATH->$ECRYPT_PATH P_PATH->$PRIVATE_PATH"

    (
        cd "$ECRYPT_PATH" || exit 1
        tar czf "$OUTPUT/ecrypt.tar.gz" ./.ecryptfs
    )

    (
        cd "$PRIVATE_PATH" || exit 1
        tar czf "$OUTPUT/private.tar.gz" ./.Private
    )
fi

echo "Copying restore script"
# TODO check script's location (can be called from other location)
cp "$SCRIPTDIR/restore-user.sh" "$USERNAME/"

echo "All operations done!"
