#!/bin/bash

DATA_DIR=$(pwd)/data
BACKUP_DIR=${DATA_DIR}/backups
SAVED_DIR=${DATA_DIR}/Pal/
RESTORE_DATE=$1

if [ -z "$RESTORE_DATE" ]; then
  echo "Please provide a date to restore"
  exit 1
fi

# echo "tar xvf ${BACKUP_DIR}/saved-${RESTORE_DATE}0000.tar.gz -C ${SAVED_DIR}"

docker stop palworld-dedicated-server

rm -rf ${SAVED_DIR}/Saved
tar xvf ${BACKUP_DIR}/saved-${RESTORE_DATE}0000.tar.gz -C ${SAVED_DIR}

docker-compose up -d