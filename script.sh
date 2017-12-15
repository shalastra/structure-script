#!/bin/bash

# HELP MESSAGE
usage="$(basename "$0") [-h] [--help] -- script to set up a project structure

where:
    -h  display this help

    After running the script user is asked to input several parameters for
    newly created project structure:
    - project name - this is going to be the root folder name
    - author - will be saved in a proper file(Not Yet Implemented)
    - programming language - defines language of the project
    - version - version of the project
    - package name - should be written in domain format, i.e. your.company.com.
                This is used later as a folder and a group name
    - description - adds simple description of the project

Additionally, all above data is stored in project.yaml file
in root folder of a newly created project"

# DISPLAY HELP MESSAGE
while getopts ':hs:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
  esac
done
shift $((OPTIND - 1))

# Function responsible for creating structure based on provided data
make_structure ()
{
    ROOT=$1
    PACKAGE=$2
    LANGUAGE=$3

    echo "Creating $ROOT project..."

    REVERT_PACK=""

    IFS=. read -ra line <<< "$PACKAGE"
    let x=${#line[@]}-1;
    while [ "$x" -ge 0 ]; do
          REVERT_PACK+="/${line[$x]}";
          let x--;
    done

    mkdir -p ./$ROOT/src/main/$LANGUAGE$REVERT_PACK ./$ROOT/src/test/$LANGUAGE$REVERT_PACK
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

# Collecting information about new project
varname=""
varuser=""
varlang=""
varversion="0.0.1"
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
    read -p 'version: ' varversion

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

# Verification of provided data
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