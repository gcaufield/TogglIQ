#! /bin/bash
BASEDIR=$(dirname "$0")
RUN=0
DEVICE='fenix6xpro'

while getopts rd: option
do
case "${option}"
in 
r) RUN=1;;
d) DEVICE=${OPTARG};;
esac
done

BINDIR=$BASEDIR/bin/$DEVICE
BIN=$BINDIR/TogglIQ.prg

if [[ ! -d $BINDIR ]]
then
    mkdir $BINDIR
fi

if [[ -f $BIN ]]
then
    rm $BIN
fi

RES=$($CIQ_SDK_ROOT/bin/monkeyc -d $DEVICE -f $BASEDIR/monkey.jungle -o $BIN -y $CIQ_KEY 2>&1 > /dev/null)

if [ ! -z "$RES" ]
then
    echo $RES
    exit
fi

if [ $RUN == 1 ]
then
    $CIQ_SDK_ROOT/bin/simulator.exe > /dev/null 2>&1 &
    $CIQ_SDK_ROOT/bin/monkeydo $BINDIR/TogglIQ.prg $DEVICE
fi
