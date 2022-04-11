#!/bin/bash

## Description: Small Check for Educational Purposes 
## Author: pdolinic@netways.de, Junior Consultant at NETWAYS Professional Services GmbH. Deutschherrnstr. 15-19 90429 Nuremberg. 

# Check Single Ports

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

##This Script is not intended with security in mind, and currently does not implement any length or size checks: It depends on the security of the Icinga/Nagios-Account.

if [ $# == 0 ]
then
    echo "Usage: arg0=Programname  arg1=Hostname arg2=Port arg3=ClosedExitCode arg4=OpenedExitCode arg5=FilteredExitCode"
    echo "./check_nmap.sh example.com 22 1 0 2"
fi

host="$1"
port="$2"

cec="$3"
oec="$4"
fec="$5"

clsd="closed"
opn="open"
fltrd="filtered"

openedcheck=$(/usr/bin/nmap -p $port $host | grep "open"| awk '{ print $2 }' ) 
filteredcheck=$(/usr/bin/nmap  -p $port $host | grep "filtered"| awk '{ print $2 }' ) 
closedcheck=$(/usr/bin/nmap -p $port $host | grep "closed"| awk '{ print $2 }' )

o_res=$(/usr/bin/nmap -p $port $host | grep "open" | awk '{ print $1,$2 }' )
f_res=$(/usr/bin/nmap -p $port $host | grep "filtered" | awk '{ print $1,$2 }' ) 
c_res=$(/usr/bin/nmap -p $port $host | grep "closed" | awk '{ print $1,$2 }' )


if [ "$closedcheck" == $clsd ]
then
    echo $c_res
    exit $cec
fi

if [ "$openedcheck" == $opn ]
then
    echo $o_res
    exit $oec
fi

if [ "$filteredcheck" == $fltrd ]
then
    echo $f_res   
    exit $fec
fi
