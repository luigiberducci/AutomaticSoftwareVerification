#!/bin/bash

algo="RS HC SA"
CC="0500000 0250000 0125000 0000000"
dir_pre="MCTS_"
dir_post="_1_2_3_"
sub="elab"

# Create `elab` dirs and copy txt files into them
for C in $CC
do
    for a in $algo
    do
        dir=${dir_pre}${a}${dir_post}${C}
        mkdir ${dir}/${sub}
        cp ${dir}/*txt ${dir}/${sub}
    done
done
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
