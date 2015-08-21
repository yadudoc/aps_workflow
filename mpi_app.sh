#!/bin/bash

nproc=$(( $MPI_NODES * $MPI_PPN ))
ppn=$MPI_PPN
nodes=$MPI_NODES

echo "Nproc : $nproc"
echo "ppn   : $ppn"
echo "nodes : $nodes"

PATH=$MPI_INSTALL:$PATH

hosts=$(aprun -n $nodes -d $ppn -N 1 /bin/hostname | grep nid0)
hosts=$(echo $hosts | sed -e "s/ /,/g")
echo hosts=$hosts
echo service hostname=$(hostname -f)

# dummyhosts=$(seq -s , -f "H%03.0f" 10)

cd /lustre/beagle2/yadunandb/IceNine_bgl_test

ls -thor ;
if [ -f icenine_data.tar.gz ];
then
    tar -xzf icenine_data.tar.gz;
    cd icenine_data;
else
    echo "Missing icenine_data.tar.gz" >&2
    echo "Missing icenine_data.tar.gz"
    exit 1
fi

$MPI_INSTALL/mpiexec -iface=ipogif0 -launcher manual -hosts $hosts -n $nproc $MPI_APP_PATH infile outraven 1 2>&1 | tee mpiexec.out &

sleep 3
echo launchlist:
launchlist=$(cat mpiexec.out | grep HYDRA_LAUNCH: | sed -e 's/HYDRA_LAUNCH: //' | head -1 | sed -e 's/--proxy-id.*$/--proxy-id/')

aprun -b -n $nodes -d $ppn -N 1 $MPI_PROX_PATH "$hosts" "$launchlist"

wait
