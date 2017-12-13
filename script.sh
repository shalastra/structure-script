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

#read -p 'Project name: ' varname

#if [ ! -d "$varname" ]
#then
    read -p 'Author: ' varuser

    read -p 'version(default: 0.0.1): ' varversion
    read -p 'package name(domain): ' varpackage

    echo "Are the params correct?"
    echo "Project name: " $varname
    echo "Author:" $varuser
    echo "Version:" $varversion

    make_structure $varname $varpackage
    make_info_file $varname $varuser $varversion $varpackage
#else
#    echo "Project with that name already exists"
fi
