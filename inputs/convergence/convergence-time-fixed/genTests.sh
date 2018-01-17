#!/usr/bin/env bash

minDt="BASE_TIME_STEP"
ratio="2.0"
maxPower="5"
minIter="100"

for (( i = 0; i <= ${maxPower}; i++ )); do
    problem_name="${i}-config.h"
    dt="${minDt}*pow(${ratio},${i})"
    cat > ${problem_name} \
        <(echo "#include xstr(HERE/config.common)") \
        <(echo "#define SOLVER_NITER ${minIter}*${ratio}^(${maxPower}-${i})") \
        <(echo "#define SOLVER_DT ${dt}")
done
