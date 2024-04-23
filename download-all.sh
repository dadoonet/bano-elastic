#!/usr/bin/env zsh

DATASOURCE_DIR=./bano-data

echo "Remove all BANO data"

rm -r "$DATASOURCE_DIR"/*.csv

./download.sh
