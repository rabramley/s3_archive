#!/usr/bin/env bash

PROGNAME=$(basename $0)

echo STOPPING archiving at `date`
echo Run by `id -u -n`

PROCESS_ID=$(pgrep -x "aws")

if [ ! -z "$PROCESS_ID" ]
then
    echo "Still Running. Stopping..."
    kill $PROCESS_ID
    echo STOPPED archiving at `date`
else
    echo "Not running"
fi
