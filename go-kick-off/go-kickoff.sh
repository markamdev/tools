#!/bin/bash

APP_NAME=$(basename $0)

function prepareSimple() {
    echo "Preparing simple project"
}

function prepareMulti() {
    echo "Preparing multi binary projec"
}

function preparePackage() {
    echo "Preparing Go library"
}

function gitInit() {
    echo "Initializing repository and creating initial commit"
}

function printHelp() {
    cat <<EOF
Go Kick-Off usage:"

$APP_NAME --outdir DIRECTORY [--git-init] --simple
$APP_NAME --outdir DIRECTORY [--git-init] --multi BINARY_1_NAME,[BINARY_2_NAME[,...,BINARY_N_NAME]]
$APP_NAME --outdir DIRECTORY [--git-init] --package PACKAGE_NAME

Options description:
--outdir DIRECTORY  mandatory output path (will be created if does not exist)
--git-init          optional, initialize git repo inside output directory and creates initial commit form created files
--simple            create simple project with single main.go file in main directory
--multi  NAMES...   create project for multiple output binaries (names given as a comma separated list)
--package NAME      create a package project (go library) with given name

Please note that only one option from --simple, --multi and --package can be used at time

EOF
}

printHelp
