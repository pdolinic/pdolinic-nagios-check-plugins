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

now=$(date +"%Y-%m-%d-%h-%s")
filename="/tmp/nmap-save-${now}"

host="$1"
port="$2"

cec="$3"
oec="$4"
fec="$5"

clsd="closed"
opn="open"
fltrd="filtered"

Nmap_Save=$(/usr/bin/nmap -p $port $host -oN $filename)
OpenedCheck=$(grep "open" $filename | awk '{ print $2 }' ) 
FilteredCheck=$(grep "filtered" $filename | awk '{ print $2 }' ) 
ClosedCheck=$(grep "closed" $filename | awk '{ print $2 }' )

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
