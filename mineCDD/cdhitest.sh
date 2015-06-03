#!/bin/bash
##dependencies: cd-hit-est

FILES=*.fa
for f in $FILES
do
  echo "Processing $f file..."
  cd-hit-est -i $f -o $f.clust -c 0.9 -n 8 -aL 0.9 -aS 0.9 -g 1
done