#!/usr/bin/env bash
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
else
    echo "Project with that name already exists"