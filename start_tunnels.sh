#!/bin/bash

source ./configs

ssh_test=$(ssh $COASTERUSER@$COASTERSERVER 'echo $USER' | tail -n 1)
if [[ $ssh_test != "$COASTERUSER" ]]
then
    echo "Unable to connect to $COASTERSERVER as $COASTERUSER"
    echo "Please check SSH connectivity"
    exit -1
else
    echo "SSH Connectivity [OK]"
fi


if [[ "$HOSTNAME" == *cooley* ]]
then
    echo "Starting tunnels from Cooley to $COASTERSERVER"
    IPADDR=$(ifconfig eth0 | grep -o addr:[^\ ]* | sed 's/addr://')
    ssh -f -N -L $IPADDR:$WORKERPORT:$COASTERSERVER:$WORKERPORT $COASTERUSER@$COASTERSERVER
    echo "SSH Tunnel open on $WORKERPORT [OK]"

elif [[ "$HOSTNAME" == *blogin* ]]
then
    HOST=$(hostname -f)
    IPADDR=$(nslookup $(hostname -f) | grep Address | tail -n 1 | awk {'print $2'})
    echo "Starting tunnels from Blues to $COASTERSERVER"
    #ssh -v -N -L *:50005:swift.rcc.uchicago.edu:50005 yadunand@swift.rcc.uchicago.edu
    ssh -f -N -L *:$WORKERPORT:$COASTERSERVER:$WORKERPORT $COASTERUSER@$COASTERSERVER
    echo "SSH Tunnel open on $WORKERPORT [OK]"

else
    echo "WARNING : Unknown host [OK]"
    ssh -f -N -L *:$WORKERPORT:$COASTERSERVER:$WORKERPORT $COASTERUSER@$COASTERSERVER

fi