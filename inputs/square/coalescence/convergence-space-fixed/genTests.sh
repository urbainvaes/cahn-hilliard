#!/usr/bin/env bash

minMeshSize="0.01"
ratio="Sqrt(2)"

for (( i = 0; i < 7; i++ )); do
    problem_name="${i}-config.h"
    meshSize="${minMeshSize}*${ratio}^${i}"
    cat > ${problem_name} \
        <(echo "#include xstr(HERE/config.common)") \
        <(echo "#define GEOMETRY_S ${meshSize}")
done
