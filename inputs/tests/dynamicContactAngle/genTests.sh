#!/usr/bin/env bash

contact_angles="pi/3 5*pi/12 pi/2 7*pi/12 2*pi/3"
script_dir=$(dirname "$0")

for angle in ${contact_angles}; do
    problem_dir=$(echo ${angle} | tr "*" "t" | tr "/" "o")
    mkdir -p ${problem_dir}
    ln -sft  ${problem_dir} ../square.geo ../config.mk
    sed "s#CONTACTANGLE#${angle}#" problem.pde > ${problem_dir}/problem.pde
done
