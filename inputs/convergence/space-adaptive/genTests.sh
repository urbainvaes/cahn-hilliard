#!/usr/bin/env bash

minMeshSize="0.002"
ratio="sqrt(2)"
quotient=5

for (( i = 0; i < 10; i++ )); do
    problem_name="${i}-config.h"
    h_min="${minMeshSize}*pow(${ratio},${i})"
    cat > ${problem_name} \
        <(echo "#include xstr(HERE/config.common)") \
        <(echo "#define SOLVER_MESH_ADAPTATION_HMIN ${h_min}") \
        <(echo "#define SOLVER_MESH_ADAPTATION_HMAX ${quotient}*${h_min}")
done
