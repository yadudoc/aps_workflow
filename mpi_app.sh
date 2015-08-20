#!/bin/bash

nproc=$(( $MPI_NODES * $MPI_PPN ))
ppn=$MPI_PPN
nodes=$MPI_NODES

echo "Nproc : $nproc"
echo "ppn   : $ppn"
echo "nodes : $nodes"

cd $PBS_O_WORKDIR
PATH=/home/users/p01532/mpich-3.1.4/install/bin:$PATH

hosts=$(aprun -n $nodes -d $ppn -N 1 /bin/hostname | grep nid0)
hosts=$(echo $hosts | sed -e "s/ /,/g")
echo hosts=$hosts

echo service hostname=$(hostname -f)

# dummyhosts=$(seq -s , -f "H%03.0f" 10)

/home/users/p01532/mpich-3.1.4/install/bin/mpiexec -iface=ipogif0 -launcher manual -hosts $hosts -n $nproc ./mpicatnap infile outraven 1 2>&1 | tee mpiexec.out &

sleep 3
echo launchlist:
launchlist=$(cat mpiexec.out | grep HYDRA_LAUNCH: | sed -e 's/HYDRA_LAUNCH: //' | head -1 | sed -e 's/--proxy-id.*$/--proxy-id/')

aprun -b -n $nodes -d $ppn -N 1 ./prox "$hosts" "$launchlist"

wait
