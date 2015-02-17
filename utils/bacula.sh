#!/bin/bash

_wake_rd1000 () {
    # wake up RD1000
    echo "wake up RD1000 (/dev/sda)"
    fdisk -l /dev/sda
}

_remove_eolesauvegarde () {
    # suppression du verrou de sauvegarde si plus vieux de 2 jours
    echo "suppression du verrou de sauvegarde"

    if [ -e /var/lock/eolesauvegarde ]
    then
        find /var/lock/ -maxdepth 1 -iname eolesauvegarde -ctime +1 -exec rm -f /var/lock/eolesauvegarde \; && echo "umount" | bconsole
    fi

   # démontage du support
}

_restart_bacula () {
    # redémarrage de bacula
    echo "redemarrage des service bacula"
    if [ ! -e /var/lock/eole/eolesauvegarde ]
    then
        /etc/init.d/bacula-fd stop
        /etc/init.d/bacula-director stop
        /etc/init.d/bacula-sd stop
        sleep 5
        ps ax | grep bacula-sd | awk '{print $1}' | xargs -I% kill -9 %
        sleep 3
        /etc/init.d/bacula-sd start
        /etc/init.d/bacula-fd start
        /etc/init.d/bacula-director start
    fi
}

_update_volumes () {
    # changer le status des volumes
    _update_now () {
        echo "Mise à jour des volumes de \"Append\" vers \"Full\""
        echo "list volumes" | bconsole | grep amonecole-dir-full | grep -i append | awk '{print $4}' | xargs -I% echo -e "update volume=%\n1\n4\n18" | bconsole
        echo "list volumes" | bconsole | grep amonecole-dir-inc | grep -i append | awk '{print $4}' | xargs -I% echo -e "update volume=%\n1\n4\n18" | bconsole
        echo "list volumes" | bconsole | grep amonecole-dir-diff | grep -i append | awk '{print $4}' | xargs -I% echo -e "update volume=%\n1\n4\n18" | bconsole
    }

case "$1" in
    manual)
        echo "Liste des volumes en status \"Append\""
        echo "list volume" | bconsole | grep -i amonecole-dir-full | grep -i append | awk '{print $4 " " $6}'
        echo "list volume" | bconsole | grep -i amonecole-dir-inc | grep -i append | awk '{print $4 " " $6}'
        echo "list volume" | bconsole | grep -i amonecole-dir-diff | grep -i append | awk '{print $4 " " $6}'
        # mettre à jour les volumes en status "append"?
        echo -n "Voulez mettre à jour le status de ses volumes de \"Append\" à \"Full\"? y/n: "
        read reponse
        reponse=$(echo $reponse | tr [:upper:] [:lower:])
        if [ x$reponse == "xy" ] || [ x$reponse == "xo" ]
        then
            _update_now
        fi
        ;;
    auto)
        _update_now
esac

}

_main () {

#args=("$@")
#for ((i=0; i < $#; i++)) {
#    echo "$((i+1)): ${args[$i]}"
#}

case "$1" in
    all)
        _wake_rd1000
        _remove_eolesauvegarde
        _restart_bacula
        _update_volumes auto
        ;;
    lock)
        echo "removing eolesauvegarde lock"
        _remove_eolesauvegarde
        ;;
    restart)
        echo "restarting bacula"
        _restart_bacula
        ;;
    update)
        echo "updating volumes"
        _update_volumes auto
        ;;
    update_manual)
        echo "manual updating"
        _update_volumes manual
        ;;
    wake)
        echo "waking up"
        _wake_rd1000
        ;;
    *)
        echo "$0 update : mise à jour automatique des volumes de sauvegardes bacula"
        echo "$0 update_manual : mise à jour Manuel des volumes "
        echo "$0 restart : redémarre bacula"
        echo "$0 lock : supprime le verrou s'il est plus vieux d'un jour"
        echo "$0 wake : réveille le périphérique RD1000"
        echo "$0 all : effectue toute les actions ci dessus"
esac

}

_main $@
