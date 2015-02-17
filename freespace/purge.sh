#!/bin/bash
# Ce script purge certains fichiers dans les repertoires personnels
# Version 3.2 - Decembre 2011
 
if [ ! -d /var/log/purge ] ; then
mkdir /var/log/purge
fi
 
log="/var/log/purge/purge.log"
google=`ls /home/workgroups/commun/logiciels/ |grep -i '^googleearth$'`
 
purge()
{
 
## Suppression du cache GoogleEarth
#if [ -n "$google" ] ; then
#  find /home/workgroups/commun/logiciels/$google -iregex '^.*\.dat.*$' -exec rm -rf {} \; -print
#fi
 
####################
## FIREFOX
# On n'utilise pas de chemin plus precis pour prendre aussi en compte les fichiers d'Eclair
# qui ne sont pas au meme endroit
  echo + Nettoyage Firefox
# Purge des fichiers .sqlite de Firefox
find /home -maxdepth 10 -type f -iregex '^.*Firefox.*urlclassifier.\.sqlite$' -exec rm {} \; -print
# Purge des fichiers .sqlite.corrupt de Firefox
find /home -maxdepth 10 -type f -iregex '.*\.corrupt$' -exec rm {} \; -print
# Purge du cache de Firefox
find /home -maxdepth 10 -type d -iregex '^.*Firefox.*Cache.*$' -exec rm -r {} \; -print
# Purge des rapports de plantage de Firefox
find /home -maxdepth 10 -type f -iregex '^.*Firefox.Crash\ Reports.*$' -exec rm {} \; -print
####################
 
####################
## Open Office
  echo + Nettoyage Open Office
# Purge du cache d'OpenOffice
find /home -maxdepth 12 -type f -iregex '^.*OpenOffice\.org.*cache.*\.dat$' -exec rm {} \; -print
# Suppression des anciens dossier OpenOffice.org2
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/\.Config/Application Data/OpenOffice\.org2' -exec rm -r {} \; -print
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/config_eole/Application Data/OpenOffice\.org2' -exec rm -r {} \; -print
####################
 
####################
## Fichiers dvd
#  echo + Nettoyage DVD
#find /home -maxdepth 10 -type f -iregex '^.*\.VOB$' -exec rm -r {} \; -print
####################
 
####################
## Fichiers du cache SunJava
  echo + Nettoyage Cache SunJava
find /home -maxdepth 14 -type f -iregex '^.*Sun.*cache.*$' -exec rm {} \; -print
####################
 
####################
## Suppression des dossiers de cle USB U3
  echo + Nettoyage Cle USB U3
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/\.Config/Application\ Data.U3' -exec rm -r {} \; -print
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/config_eole/Application\ Data.U3' -exec rm -r {} \; -print
####################
 
####################
## Suppression des historiques de IE
  echo + Nettoyage Historique IE
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/\.Config/Local Settings/Historique/History.IE5' -exec rm -r {} \; -print
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/config_eole/Local Settings/Historique/History.IE5' -exec rm -r {} \; -print
####################
 
}
 
echo "">>  $log
echo "******************************************************************">>  $log
echo "Purge des /home/<user>/.Config/Application Data du $(date)">>  $log
purge 1>>  $log 2>&1
echo "Purge terminee a $(date)">>  $log
