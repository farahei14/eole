#!/bin/bash

scan_dir="/home/workgroups/scans"
scan_dir_users="/home/workgroups/scans/users"
liste="/home/workgroups/scans/liste_profs"
photocop_user="sp3e"

mkdir -p ${scan_dir_users}
setfacl -Rm u:${photocop_user}:rwx ${scan_dir}
setfacl -Rm g:scans:r-x ${scan_dir}

for utilisateur in $(cat $liste)
do
    mkdir -p $scan_dir_users/${utilisateur}
    chown ${photocop_user}.scans $scan_dir_users/${utilisateur}
    setfacl -m user:${utilisateur}:rwx $scan_dir_users/${utilisateur}
    setfacl -m d:user:${utilisateur}:rwx $scan_dir_users/${utilisateur}
    setfacl -m g:scans:--- $scan_dir_users/${utilisateur}
    setfacl -m default:g:scans:--- $scan_dir_users/${utilisateur}
    chmod 700 $scan_dir_users/${utilisateur}
done
