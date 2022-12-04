#!/bin/bash

shopt -s extglob
python=/usr/bin/python3

[[ -z "$1" ]] && read -rp "Day: " day
[[ -z "$day" ]] && days="$*" || days="$day"
[[ "$1" = all ]] && days='[0-9]?([0-9])'

for d in $days; do
  [[ -z "$day" ]] && echo "Day $d:"
  $python "$d/day$d".py < "$d"/input.txt | sed 's/^/  /'
done
