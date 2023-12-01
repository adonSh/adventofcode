#!/bin/bash

year=$(basename "$PWD")
[[ -z "$1" ]] && read -rp "Day? " day || day="$1"
addr="https://adventofcode.com/${year}/day/${day}/input"
fname=$(printf "%02d" "$day")

if [[ ! -f cookie.txt ]]; then
  echo "Missing cookie" 1>&2
  exit 1
fi

[[ -d "$fname" ]] || mkdir "$fname"
curl -b "$(cat cookie.txt)" "$addr" > "${fname}/input.txt"
echo "from .day${fname} import *" > "${fname}/__init__.py"
