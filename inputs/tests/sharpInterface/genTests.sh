#!/usr/bin/env bash

cahn_numbers="25e-4 5e-3 1e-2 2e-2 4e-2"
script_dir=$(dirname "$0")

for number in ${cahn_numbers}; do
    problem_dir=$(echo ${number} | tr "-" "m")
    mkdir -p ${problem_dir}
    ln -sft  ${problem_dir} ../square.geo ../config.mk
    sed "s#CAHN#${number}#" problem.pde > ${problem_dir}/problem.pde
done
