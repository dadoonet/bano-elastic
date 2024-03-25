#!/usr/bin/env zsh

echo "Downloading BANO region $1"

DATASOURCE_DIR=$(pwd)/bano-data

import_region () {
    export REGION=$1
    FILE="$DATASOURCE_DIR"/bano-$REGION.csv
    URL=http://bano.openstreetmap.fr/data/bano-$REGION.csv
    # We import the region from openstreet map if not available yet
    if [ ! -e $FILE ] ; then
        echo "Fetching $FILE from $URL"
        wget $URL -P "$DATASOURCE_DIR"
    fi
}

if [ ! -e "$DATASOURCE_DIR" ] ; then
    echo "Creating $DATASOURCE_DIR dir"
    mkdir "$DATASOURCE_DIR"
fi

DEPT=$(printf %02d $1)
import_region $DEPT
