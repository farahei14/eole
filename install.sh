#!/bin/bash

#cp DomainUsers.txt /home/netlogon/scripts/groups
cp patch/control-alt-delete.conf /usr/share/eole/creole/modif
gen_patch
mkdir -p /root/utils
cp -R utils/* /root/utils/

# installation freespace
cp freespace/purgeHome /etc/cron.d
chmod 644 /etc/cron.d/purgeHome
cp freespace/purgelog /etc/logrotate.d
chmod 644 /etc/logrotate.d/purgelog

cat <<EOF
Type de Serveur : 
[1] - Amonecole
[2] - Scribe
EOF
echo -n "Choix: "
read choix
case "$choix" in
         1)
            cat freespace/DomainUsers.txt | sed -e s/X_SERVEURTYPE/Amonecole/ > /home/netlogon/scripts/groups/DomainUsers.txt
            chmod 644 /home/netlogon/scripts/groups/DomainUsers.txt
            cp freespace/FreeSpace.vbs /home/netlogon/scripts
            ;;
         2)
            cat freespace/DomainUsers.txt | sed -e s/X_SERVEURTYPE/Scribe/ > /home/netlogon/scripts/groups/DomainUsers.txt
            chmod 644 /home/netlogon/scripts/groups/DomainUsers.txt
            cp freespace/FreeSpace.vbs /home/netlogon/scripts
            ;;
         *)
            echo "Choix incorrect"
esac
