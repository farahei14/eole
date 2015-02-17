#!/bin/bash

# script de nettoyage des répertoires de classes

for i in $(ldapsearch -x objectClass=classe cn | grep "^cn" | cut -d ' ' -f 2)
do
        #j=${i:0:1}
        #rm -fr /home/$j/$i/perso/.Config
        echo "suppression des donnes de $i/donnees/"
        rm -fr /home/workgroups/$i/donnees/*
        echo "suppression des donnes de $i/travail/"
        rm -fr /home/workgroups/$i/travail/*
        sleep 5
done
