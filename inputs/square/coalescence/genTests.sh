#!/usr/bin/env bash

meshSizes="0.001 0.002 0.004 0.008 0.016 0.032 0.064 0.128"

for size in ${meshSizes}; do
    problem_name="${size}-config.h"
    cat > ${problem_name} config.h \
        <(echo "#define SOLVER_HMIN ${size}") \
        <(echo "#define SOLVER_HMAX 10*${size}")
done
