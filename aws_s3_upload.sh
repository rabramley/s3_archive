#!/usr/bin/env bash

PROGNAME=$(basename $0)

function error_exit
{
    echo
    echo "${PROGNAME}: ${1:-"Unknown Error"}"
    echo
    echo "USAGE: ${PROGNAME} <source_directory> <s3_bucket_name>"
    echo
    echo "EXAMPLE: ${PROGNAME} /home/fred/photos fred.archive/photos"
    echo
    exit 1
}

SOURCE_DIR=$1
S3_BUCKET=$2

if [ -z "$SOURCE_DIR" ]; then
    error_exit "source_directory not provided"
fi

if [ ! -d "$SOURCE_DIR" ]; then
    error_exit "source_directory ${SOURCE_DIR} does not exist"
fi

if [ -z "$S3_BUCKET" ]; then
    error_exit "s3_bucket_name not provided"
fi

echo STARTED archiving at `date`
echo Run by `id -u -n`

if pgrep -x "aws" > /dev/null
then
    echo "Upload already running.  Stopping..."
    exit 0
fi

echo "Upload starting"

nice trickle -s -u 16 /usr/local/bin/aws s3 sync ${SOURCE_DIR} s3://${S3_BUCKET} --exclude ".*" --exclude "*/.*" --no-follow-symlinks --size-only

echo COMPLETED archiving at `date`

