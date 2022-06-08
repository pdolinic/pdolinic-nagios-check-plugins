#!/bin/bash

##Description: Small Check for Educational Purposes 
##Author: pdolinic@netways.de, Junior Consultant at NETWAYS Professional Services GmbH. Deutschherrnstr. 15-19 90429 Nuremberg. 

#Check Single Ports

#License = GNU GPLv2

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

##This Script is not intended with security in mind, and currently does not implement any length or size checks: It depends on the security of the Icinga/Nagios-Account.

#   ______ _     _ _______ ______ _    _         ______  ______         ______   
#   / _____) |   | (_______) _____) |  / )       |  ___ \|  ___ \   /\  (_____ \ 
#  | /     | |__ | |_____ | /     | | / /        | |   | | | _ | | /  \  _____) )  
#  | |     |  __)| |  ___)| |     | |< <         | |   | | || || |/ /\ \|  ____/ 
#  | \_____| |   | | |____| \_____| | \ \ _______| |   | | || || | |__| | |
#   \______)_|   |_|_______)______)_|  \_|_______)_|   |_|_||_||_|______|_|
#

#Exit Codes
Exit_Codes=" >> 0:OK, 1:Warn, 2:Critical, 3:Unkown << "

if [ -z "$1" ] || [ -z "$2" ] 
then
    echo ">> Usage: arg0=programname arg1=hostname arg2=port arg3=Your_Exit_Code#1 arg4=Your_Exit_Code#2 arg5=Your_Exit_Code#3 << " && \
    echo ">> Example: ./check_nmap.sh example.com 445 1 2 0 <<" && \
    echo $Exit_Codes
fi

#Generate Temporary Nmap-Savefile
RandomID=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 20; echo;)
now=$(date +"%Y-%m-%d-%h-%s")
filename="/tmp/nmap-save-${RandomID}"

#Add Arguments for Host & Port
host="$1"
port="$2"

#Exit Codes you as an Admin can adapt for your Needs
cec="$3"
oec="$4"
fec="$5"

clsd="closed"
opn="open"
fltrd="filtered"

#Run Scan
Nmap_Save=$(/usr/bin/nmap -p $port $host -oN $filename)

#Check States
OpenedCheck=$(grep "open" $filename | awk '{ print $2 }' ) 
FilteredCheck=$(grep "filtered" $filename | awk '{ print $2 }' ) 
ClosedCheck=$(grep "closed" $filename | awk '{ print $2 }' )

#Return Resuls
Opened_Result=$(grep "open" $filename | awk '{ print $1,$2 }' )
Filtered_Result=$(grep "filtered" $filename | awk '{ print $1,$2 }' ) 
Closed_Result=$(grep "closed" $filename | awk '{ print $1,$2 }' )


if [ "$ClosedCheck" == $clsd ]
then
    echo $Closed_Result
    rm  "$filename"
    exit $cec
fi

if [ "$OpenedCheck" == $opn ]
then
    echo $Opened_Result
    rm "$filename"
    exit $oec
fi

if [ "$FilteredCheck" == $fltrd ]
then
    echo $Filtered_Result   
    rm "$filename"
    exit $fec   
fi
