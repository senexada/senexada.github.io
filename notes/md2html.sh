#!/bin/sh

for file in 2025/*.md
do
    hfile=`echo $file | sed 's/\.md$/.html/'`
    echo "Converting '$file' --> '$hfile'"
    markdown $file > $hfile
done

