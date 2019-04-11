#!/usr/bin/env bash

echo "Importing BANO data with Logstash into elasticsearch"

export SOURCE_DIR=~/Documents/Elasticsearch/Talks/postal_addresses/demo/

DEPTS=95
for i in {1..19} $(seq 21 $DEPTS) {971..974} {976..976} ; do
    DEPT=$(printf %02d $i)
    $SOURCE_DIR/download_region.sh $DEPT
done
