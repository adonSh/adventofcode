#!/bin/bash

python=/usr/bin/python3

[[ -z "$1" ]] && read -rp "Day: " day || day="$1"
$python "$day/day$day".py < "$day"/input.txt
