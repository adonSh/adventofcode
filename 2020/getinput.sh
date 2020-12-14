#!/bin/sh

year=$(pwd | head -c -1 | tail -c 4)
day=$1
addr=https://adventofcode.com/$year/day/$day/input

if [ ! -f cookie.txt ]; then
  echo "Missing cookie" 1>&2
  exit 1
fi

[ -d $day ] || mkdir $day
curl -b $(cat cookie.txt) $addr > $day/input.txt
