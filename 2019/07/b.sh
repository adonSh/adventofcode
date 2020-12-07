#!/bin/bash

input=$1
perms=b_permutations

for i in {1..600}; do
  if [[ $((i % 5 )) -eq 1 ]]; then
    # start the amplifiers, hooked up to fifo's
    ./amp $input < begin > ab &
    ./amp $input < ab > bc &
    ./amp $input < bc > cd &
    ./amp $input < cd > de &
    ./amp $input < de > end &

    # set the phase for each amp
    p1=$(head -n $i $perms | tail -n 1)
    p2=$(head -n $((i+1)) $perms | tail -n 1)
    p3=$(head -n $((i+2)) $perms | tail -n 1)
    p4=$(head -n $((i+3)) $perms | tail -n 1)
    p5=$(head -n $((i+4)) $perms | tail -n 1)

    echo $p1 > begin
    echo $p2 > ab
    echo $p3 > bc
    echo $p4 > cd
    echo $p5 > de

    # let er rip
    echo 0 > begin

    # feed output back to first amp 9x
    # (not very good general solution, but my input always ran 10 cycles)
    for j in  {0..8}; do
#   for j in  {0..3}; do # (4 cycles for test4)
      read line < end
      echo $line > begin
    done

    # echo final (10th) output
    read line < end
    echo $line

  fi
done
