#!/usr/bin/env bash

ref_cahn="25e-4"
iteration_numbers="0 256 512 1024"
cahn_numbers="${ref_cahn} 5e-3 1e-2 2e-2 4e-2"
git_root=$(git rev-parse --show-toplevel)
test_results_dir=${git_root}/sharpInterface

mkdir -p ${test_results_dir}

echo "Cahn numbers: ${cahn_numbers}"
echo "Iterations of interest for Cn=${ref_cahn}: ${iteration_numbers}"

for number in ${cahn_numbers}; do
    for iter_ref in ${iteration_numbers}; do
        problem_dir_rel=$(echo ${number} | tr "-" "m")
        problem_dir_abs=${git_root}/tests/tests/sharpInterface/${problem_dir_rel}
        cd ${problem_dir_abs} && echo "Entering directory ${problem_dir_abs}"
        iteration=$(python -c "print(int(${iter_ref}*${ref_cahn}/${number}))")
        output_file="sharp_interface-Cn${problem_dir_rel}-phi-filledcurves-${iteration}.png"
        output_file=${output_file} gnuplot gnuplot/plot.plt
        mv ${output_file} ${test_results_dir}
        # mv ${output_file/.tex/.eps} ${test_results_dir}
    done
done
