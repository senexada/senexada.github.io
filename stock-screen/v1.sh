#!/bin/sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 <csv file> [...]"
    exit 1
fi

# The seds eliminate the commas inside double quotes
# There are awks for min price $1, must have an industry & subindustry
# The last awk converts the M & B mktcap labels to numbers

cat $@ | sed 's/","/@/g' | sed 's/,//g' | sed 's/"//g' | sed 's/@/,/g' | sed 's/\$//g' |\
grep -v Limited | grep -v LP | grep -v 'L.P.' |\
  awk -F, '{if ($3 > 1.0) print}' |\
  awk -F, '{if ($6 != "n/a" && $7 != "n/a") print}' |\
  awk -F, '{OFS=","; num = substr($4,1,length($4)-1); letter = substr($4,length($4)); if (letter == "M") mult = 1; else if (letter == "B") mult = 1000; else mult = 1e-6; $4 = num * mult; print}'