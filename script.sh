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

    echo "Creating $ROOT project..."
    echo  "$PACKAGE"

    IFS=. components=$PACKAGE

    echo ${components}

    mkdir ./$ROOT
    FILE=$PWD/$ROOT
    echo $FILE
}

make_info_file ()
{
    # Creates a project file with information passed during initialization
    # In form of YAML

    DATE=`date '+%Y-%m-%d %H:%M:%S'`

    echo "project-name: $1
author: $2
version: $3
package: $4
creation-date: $DATE
    " >> $varname/project.yaml
}

varname=""
varuser=""
varversion=""
varpackage=""

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

while [[ "${varpackage}" = "" ]]; do
    read -p 'package name(domain): ' varpackage

    if [[ "${varpackage}" =~ "^(([a-zA-Z]{1})|([a-zA-Z]{1}[a-zA-Z]{1})|([a-zA-Z]{1}[0-9]{1})|([0-9]{1}[a-zA-Z]{1})|([a-zA-Z0-9][a-zA-Z0-9-_]{1,61}[a-zA-Z0-9]))\.([a-zA-Z]{2,6}|[a-zA-Z0-9-]{2,30}\.[a-zA-Z]{2,3})$" ]];
    then
        echo "Correct"
    else
        echo "Incorrect domain, try again."
        varpackage=""
    fi
done

read -p 'version(default: 0.0.1): ' varversion

echo "Entered data, please verify:"
echo "Project name: " $varname
echo "Author:" $varuser
echo "Version:" $varversion
echo "Package:" $varpackage

make_structure $varname $varpackage
make_info_file $varname $varuser $varversion $varpackage