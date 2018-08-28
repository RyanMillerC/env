#!/bin/bash
#
# Copy files into home directory
#

echo "diff ./.bashrc ~/.bashrc"
sdiff -s ./.bashrc ~/.bashrc
echo "This will replace ~/.bashrc and ~/.bash_profile. Are you sure you want to do this?"

# Wait for input
read dummy  

# Backup just in case
cp ${HOME}/.bashrc{,_old}
cp ${HOME}/.bash_profile{,_old}

# Replace files
cp .bash_profile .bashrc ${HOME}

echo "Completed!"

