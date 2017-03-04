#!/bin/sh

if [ $# -eq 1 ]; then
    in=$1
else
    in=/dev/stdin
fi

cat $in | awk -F, '{print $6}' | sort | uniq -c |\
   awk '{line[NR] = $0; val[NR] = $1; sum += $1;} END { for (key in line) { printf("%s %.2f\n", line[key], val[key]/sum);} }'