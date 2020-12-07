#!/usr/bin/env bash

DATASOURCE_DIR=$(pwd)/bano-data

echo "Remove all BANO data"

rm -r $DATASOURCE_DIR/*.csv

./download.sh
