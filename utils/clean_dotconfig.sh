#!/bin/bash

# script de nettoyage de fichier .config

for i in $(ldapsearch -x "cn=$1" memberuid | grep -v "^#" | grep -i memberuid | sed -e s/"memberuid: "//i)
do
    j=${i:0:1}
    echo "rm -fr /home/$j/$i/.Config"
done
