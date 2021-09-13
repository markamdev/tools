#!/bin/bash

APP_NAME=$(basename "$0")
APP_DIR=$(dirname "$0")

function _checkOutdir() {
    if [ -z "$1" ]
    then
        echo "Invalid outdir: \"$1\""
        exit 1
    fi

    if [ -e  "$1" ]
    then
        if [ ! -d "$1" ]
        then
            echo "Output path $1 exists but is not a directory"
            exit 1
        fi
    else
        mkdir -p "$1"
        if [ "$?" -ne 0 ]
        then
            echo "Failed to create output directory: $1"
            exit 1
        fi
    fi
}

function prepareSimple() {
    echo "Preparing simple project in $1 (with files from $APP_DIR)"

    (
        cd "$1"
        cp "$APP_DIR"/main-template.go ./main.go

        BIN_NAME=$(basename "$1")
        sed -i "s/APPLICATION/$BIN_NAME/" main.go

        GO_FOUND=$(command -v go)
        if [ -n "$GO_FOUND" ]
        then
            go mod init "$BIN_NAME" &>> /dev/null
            go mod tidy &>> /dev/null
        fi
    )
}

function prepareMulti() {
    echo "Preparing multi binary project"
    # output directory at $1 already checked
    if [ -z "$2" ]
    then
        echo "Binary names not provided - please check --help"
        exit 1
    fi
}

function preparePackage() {
    echo "Preparing Go library"
    # output directory at $1 already checked
    if [ -z "$2" ]
    then
        echo "Package name not provided - please check --help"
        exit 1
    fi
}

function gitInit() {
    echo "Initializing repository in $1 and creating initial commit"
    (
        cd "$1"

        git init . &>> /dev/null
        git add ./* &>> /dev/null
        git commit -m "Initial commit with application stub"
    )
}

function printHelp() {
    cat <<EOF
Go Kick-Off usage:"

$APP_NAME --outdir DIRECTORY [--git-init] --simple
$APP_NAME --outdir DIRECTORY [--git-init] --multi BINARY_1_NAME,[BINARY_2_NAME[,...,BINARY_N_NAME]]
$APP_NAME --outdir DIRECTORY [--git-init] --package PACKAGE_NAME
$APP_NAME --help

Options description:
--outdir DIRECTORY  mandatory output path (will be created if does not exist)
--git-init          optional, initialize git repo inside output directory and creates initial commit form created files
--simple            create simple project with single main.go file in main directory
--multi  NAMES...   create project for multiple output binaries (names given as a comma separated list)
--package NAME      create a package project (go library) with given name
--help              print this message

Please note that only one option from --simple, --multi and --package can be used at time

EOF
}

OUTDIR=""
GIT_INIT=0
SIMPLE_PROJECT=0
MULTI_PROJECT=0
MULTI_NAMES=""
PACKAGE_PROJECT=0
PACKAGE_NAME=""

while [[ $# -gt 0 ]]; do
  option="$1"

    case $option in
    --outdir)
        OUTDIR="$2"
        shift
        shift
        ;;
    --git-init)
        GIT_INIT=1
        shift
        ;;
    --simple)
        SIMPLE_PROJECT=1
        shift
        ;;
    --multi)
        MULTI_PROJECT=1
        MULTI_NAMES="$2"
        shift
        shift
        ;;
    --package)
        PACKAGE_PROJECT=1
        PACKAGE_NAME="$2"
        shift
        shift
        ;;
    --help)     # help requested so print help and exit without error
        printHelp
        exit 0
        ;;
    *)  # unknown option - print help and return error
        printHelp
        exit 1
        ;;
  esac
done

echo "Go project Kick-off script"

if [[ "$SIMPLE_PROJECT" -eq 1 && "$MULTI_PROJECT" -eq 1 ]]
then
    echo "Cannot use --simple and --multi at the same time"
    exit 1
fi

if [[ "$SIMPLE_PROJECT" -eq 1 && "$PACKAGE_PROJECT" -eq 1 ]]
then
    echo "Cannot use --simple and --multi at the same time"
    exit 1
fi

if [[ "$MULTI_PROJECT" -eq 1 && "$PACKAGE_PROJECT" -eq 1 ]]
then
    echo "Cannot use --simple and --multi at the same time"
    exit 1
fi

if [[ "$SIMPLE_PROJECT" -eq 0 && "$MULTI_PROJECT" -eq 0 && "$PACKAGE_PROJECT" -eq 0 ]]
then
    echo "Exactly one option from --simple, --multi and --package has to be selected"
    exit 1
fi

_checkOutdir "$OUTDIR"

if [ $SIMPLE_PROJECT -eq 1 ]
then
    prepareSimple "$OUTDIR"
fi

if [ $MULTI_PROJECT -eq 1 ]
then
    prepareMulti "$OUTDIR" "$MULTI_NAMES"
fi

if [ $PACKAGE_PROJECT -eq 1 ]
then
    preparePackage "$OUTDIR" "$PACKAGE_NAME"
fi

if [ $GIT_INIT -eq 1 ]
then
    gitInit "$OUTDIR"
fi

echo "Go project ready for development in $OUTDIR"
