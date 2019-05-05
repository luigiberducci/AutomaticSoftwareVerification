#!/bin/bash

algo="RS HC SA"
CC="0125000 0000000"
dir_pre="MCTS_"
dir_post="_2_"
sub="elab"

# Collect robustness
out_file="BestRob.dat"
for C in $CC
do
    for a in $algo
    do
        dir=${dir_pre}${a}${dir_post}${C}/${sub}
        cat ${dir}/*txt | grep 'Best Rob' | cut -d: -f2 > ${dir}/${out_file}
    done
done

# Collect time
out_file1="Time.dat"
out_file2="TraceTime.dat"
for C in $CC
do
    for a in $algo
    do
        dir=${dir_pre}${a}${dir_post}${C}/${sub}
        cat ${dir}/*txt | grep 'Simulation time' | cut -d: -f2 | cut -d ' ' -f 1 > ${dir}/${out_file1}
        cat ${dir}/*txt | grep 'time.*trace' | cut -d: -f2 | cut -d ' ' -f 1 > ${dir}/${out_file2}
    done
done
