#!/bin/bash

NODES=$1
TIME=$2
source ./configs

JID=$RANDOM
WORKER_SCRIPT=worker.$JID.sbatch

if [[ "$HOSTNAME" == *cooley* ]]
then
    echo "Submitting workers on Cooley "
    IPADDR=$(ifconfig eth0 | grep -o addr:[^\ ]* | sed 's/addr://')

cat <<'EOF' > $WORKER_SCRIPT
#!/bin/bash

NODES=`cat $COBALT_NODEFILE | wc -l`
PROCS=$((NODES * 16))
ID=$RANDOM

EOF

cat <<EOF >> $WORKER_SCRIPT
worker.pl -w $WORKERWAITTIME http://$IPADDR:$WORKERPORT $HOSTNAME.$ID $PWD/worker-$HOSTNAME.$ID.log &> worker_stdlogs
EOF
    chmod a+x $WORKER_SCRIPT
    qsub -n $NODES -t $TIME -A $COOLEYPROJECT $WORKER_SCRIPT

elif [[ "$HOSTNAME" == *blogin* ]]
then
    HOST=$(hostname -f)
    IPADDR=$(nslookup $(hostname -f) | grep Address | tail -n 1 | awk {'print $2'})
    
else
    echo "WARNING : Unknown host [OK]"
    exit 0
fi


