#!/usr/bin/env zsh

echo "Download all BANO data"

DEPTS=95
for i in {1..7} {10..19} $(seq 21 $DEPTS) {971..974} {976..976} ; do
    DEPT=$(printf %02d $i)
    ./download_region.sh $DEPT
done

# We need to manually download 08 and 09 departments as there is an issue on Linux
./download_region_manual.sh 08
./download_region_manual.sh 09
