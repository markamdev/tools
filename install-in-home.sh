#!/bin/bash

INSTALL_DIR=$HOME/.markamdev/tools

echo "Installing utility scripts inside $INSTALL_DIR"

if [ -e "$INSTALL_DIR" ]
then
    echo "-> removing previous version ..."
    rm -rf "$INSTALL_DIR"
fi

echo "-> preparing fresh new directory for scripts"
mkdir -p "$INSTALL_DIR"

echo "--> copying user-saving ..."
cp -r ./user-saving "$INSTALL_DIR"
echo "PATH=\$PATH:$INSTALL_DIR/user-saving" >> $INSTALL_DIR/paths.env

echo "--> copying go-kick-off"
cp -r ./go-kick-off "$INSTALL_DIR"
echo "PATH=\$PATH:$INSTALL_DIR/go-kick-off" >> $INSTALL_DIR/paths.env

echo "-> adding tools to user PATH"
if [ ! -e "$HOME"/.bash_profile ]
then
    touch "$HOME"/.bash_profile
fi

PATH_ADDED=$(grep "$INSTALL_DIR" "$HOME"/.bashrc | wc -l)

if [ "$PATH_ADDED" -eq 0 ]
then
    echo "source $INSTALL_DIR/paths.env" >> "$HOME"/.bashrc
else
    echo "--> already added"
fi

echo "DONE - please reload your shell"
