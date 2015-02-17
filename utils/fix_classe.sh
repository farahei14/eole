#!/bin/bash

# Creation des dossiers de classe
ldapsearch -LLLx objectClass=classe | grep displayName | awk '{print $2}' | while read classe
do
    mkdir -p /home/workgroups/$classe/donnees
    mkdir -p /home/workgroups/$classe/travail
    mkdir -p /home/workgroups/profs-$classe
    mkdir -p /home/classes/$classe
    if [ ! -L /home/workgroups/profs-$classe/classe ]
    then
        ln -s /home/workgroups/$classe /home/workgroups/profs-$classe/classe
    fi
    if [ ! -L /home/workgroups/profs-$classe/eleves ]
    then
        ln -s /home/classes/$classe /home/workgroups/profs-$classe/eleves
    fi
done

# Creation des liens vers le perso des eleves
ldapsearch -LLLx objectClass=eleves divcod uid | grep -v "^#\|^dn:\|^ \|^$"  | while read ligne
do
    uid=$(echo $ligne | awk '{print $2}')
    car1=${uid:0:1}
    read ligne
    classe=$(echo $ligne | awk '{print $2}')
    if [ ! -L /home/classes/$classe/$uid ]
    then
        ln -s /home/$car1/$uid/perso /home/classes/$classe/$uid
    fi
done

# mise en place des droits
/usr/share/eole/backend/droits_partage.sh
