#!/bin/bash

year=$(basename "$PWD")
if [[ -z "$1" ]]; then
  read -rp "Day? " day
else
  day="$1"
fi
addr=https://adventofcode.com/"$year"/day/"$day"/input

if [[ ! -f cookie.txt ]]; then
  echo "Missing cookie" 1>&2
  exit 1
fi

[ -d "$day" ] || mkdir "$day"
curl -b "$(cat cookie.txt)" "$addr" > "$day/input.txt"
