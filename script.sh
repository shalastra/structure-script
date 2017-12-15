#!/bin/bash

# HELP MESSAGE
usage="$(basename "$0") [-h] [--help] -- script to set up a project structure

where:
    -h  display this help

    After running the script user is asked to input several parameters for
    newly created project structure:
    - project name - this is going to be the root folder name
    - author - will be saved in a proper file(Not Yet Implemented)
    - version - default is set as 0.0.1, user can change it
                by providing new version(Not Yet Implemented)
    - package name - should be written in domain format, i.e. your.company.com.
                This is used later as a folder and a group name"

# DISPLAY HELP MESSAGE
while getopts ':hs:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
  esac
done
shift $((OPTIND - 1))

make_structure ()
{
    ROOT=$1
    PACKAGE=$2
    DESCRIPTION=$3

    echo "Creating $ROOT project..."
    echo  "$PACKAGE"

    IFS=. components=$PACKAGE

    echo ${components}

    mkdir -p ./$ROOT/src/main/$DESCRIPTION ./$ROOT/src/test/$DESCRIPTION
    FILE=$PWD/$ROOT
    echo $FILE
}

make_info_file ()
{
    # Creates a project file with information passed during initialization
    # In form of YAML

    CONTENT=$1
    DATE=`date '+%Y-%m-%d %H:%M:%S'`

    echo "$CONTENT
creation-date: $DATE
    " >> $varname/project.yaml
}

varname=""
varuser=""
varlang=""
varversion=""
varpackage=""
vardesc=""

while [[ "${varname}" = "" ]]; do
    read -p 'Project name: ' varname

    if [ -d "$varname" ]
    then
        echo "Project with that name already exists"
        varname=""
    fi
done

while [[ "${varuser}" = "" ]]; do
    read -p 'Author: ' varuser
done

while [[ "${varlang}" = "" ]]; do
    read -p 'Programming language: ' varlang
done

while [[ "${varpackage}" = "" ]]; do
    read -p 'package name(domain): ' varpackage

    if [[ "$varpackage" != *"."* ]];
    then
        echo "Incorrect domain name, should be in format: xxx.xxx.xxx, try again."
        varpackage=""
    fi
done

while [[ "${varversion}" = "" ]]; do
    read -p 'version(default: 0.0.1): ' varversion

    if [[ "$varversion" != *"."* ]];
    then
        echo "Incorrect version format, should be xxx.xxx.xxx, try again."
        varversion=""
    fi
done

read -p 'Project description: ' vardesc

CONTENT="project-name: $varname
author: $varuser
programming-language: $varlang
version: $varversion
package: $varpackage
description: $vardesc"

echo
echo "Entered data, please verify: "
echo "$CONTENT"
read -p "Is the data correct?[Y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    make_structure $varname $varpackage $varlang
    make_info_file "$CONTENT"
else
    echo "Data is incorrect, please run script again."
fi