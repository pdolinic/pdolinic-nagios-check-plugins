#!/bin/bash

## Description: Small Check for Educational Purposes 
## Author: pdolinic@netways.de, Junior Consultant at NETWAYS Professional Services GmbH. Deutschherrnstr. 15-19 90429 Nuremberg. 

## Date 2021-09-13
## Regex-Credit to : https://stackoverflow.com/questions/106179/regular-expression-to-match-dns-hostname-or-ip-address
## Usage-Credit to: https://stackoverflow.com/questions/687780/documenting-shell-scripts-parameters the plugini
## Inspiration from monitoring-plugins.org adapte
## https://linuxize.com/post/bash-read/

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

##This Script is not intended with security in mind, and currently does not implement any length or size checks: It depends on the security of the Icinga/Nagios-Account.


#Var Help
#help="--help"

OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3
DEPENDENT=4


#Greeter
if [ $# == 0 ]
then
    echo "Usage: $0 Programname $Hostname/DNS $Port"
    echo "* param1: Hostname or DNS"
    echo "* param2: Port "
fi

#Read in hostname, port
#"-h"==hostname
#"-p"==port
hostname="$1"
port="$2"
#read hostname
#read port
# ValidHostnameRegex="^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])\
#(\.([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]))*$"

#if [ "$hostname" != $ValidHostnameRegex  || "$port" != $ValidHostnameRegex ]
#	then
#		echo "Wrong Input, Please Enter an IP or DNS" 		
#fi

check=$(openssl s_client -connect $hostname:$port -status 2> /dev/null | grep "OCSP Response Status" | awk '{ print $4 }')
bad="trylater"
good="successful"

if [ "$check" == $bad ]
then
echo "OCSP trylater"
exit 1;
fi

if [ "$check" == $good ]
then
echo "OCSP successful"
exit 0;
fi
