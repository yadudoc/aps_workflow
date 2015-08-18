#!/bin/bash

SERVICEPORT1=50005
WORKERPORT1=50010

SERVICEPORT2=50055
WORKERPORT2=50060


################################################################
# Start the local coaster service to which the MPI workers will
# connect
################################################################
coaster-service -p $SERVICEPORT1 -localport $WORKERPORT1 -nosec -passive &> $PWD/coaster-service1.logs &


exit 0
coaster-service -p $SERVICEPORT2 -localport $WORKERPORT2 -nosec -passive &> $PWD/coaster-service2.logs &
