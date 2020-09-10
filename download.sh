#!/usr/bin/env bash

echo "Download all BANO data"

export SOURCE_DIR=~/Documents/Elasticsearch/Talks/postal_addresses/demo/

DEPTS=95
for i in {1..7} {10..19} $(seq 21 $DEPTS) {971..974} {976..976} ; do
    DEPT=$(printf %02d $i)
    $SOURCE_DIR/download_region.sh $DEPT
done

# We need to manually download 08 and 09 departments as there is an issue on Linux
$SOURCE_DIR/download_region_manual.sh 08
$SOURCE_DIR/download_region_manual.sh 09
