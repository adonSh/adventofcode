#!/bin/bash

input=$1
perms=permutations
out=0

for i in {1..600}; do
  phase="$(head -n $i $perms | tail -n 1)"
  out=$( { echo $phase; echo $out; } | ./main $input )
# echo "$i $phase $out"
  if [[ $((i % 5)) -eq 0 ]]; then
    echo $out
    out=0
  fi
done
