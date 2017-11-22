#!/usr/bin/env bash
usage="$(basename "$0") [-h] -- script to set up a project structure

where:
    -h  show this help text"

while getopts ':hs:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
  esac
done
shift $((OPTIND - 1))

read -p 'Project name: ' varname

if [ ! -d "$varname" ]
then
    read -p 'Author: ' varuser
    read -p 'version(default: 0.0.1): ' varversion
    echo "Are the params correct?"
    echo "Project name: " $varname
    echo "Author:" $varuser
    echo "Version:" $varversion

    mkdir ./$varname
    FILE=$PWD/$varname
    echo $FILE
else
    echo "Project with that name already exists"
fi