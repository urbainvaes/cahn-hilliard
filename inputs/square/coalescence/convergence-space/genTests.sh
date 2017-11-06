#!/usr/bin/env bash

minMeshSize="0.001"
ratio="sqrt(2)"
quotient=10

for (( i = 0; i < 12; i++ )); do
    problem_name="${i}-config.h"
    h_min="${minMeshSize}*pow(${ratio},${i})"
    cat > ${problem_name} \
        <(echo "#include xstr(HERE/config.common)") \
        <(echo "#define SOLVER_HMIN ${h_min}") \
        <(echo "#define SOLVER_HMAX ${quotient}*${h_min}")
done
