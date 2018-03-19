#!/usr/bin/env bash

maxDt="BASE_TIME_STEP"
ratio="2"
maxPower="5"
minIter="BASE_NITER"

for (( i = 0; i <= maxPower; i++ )); do
    problem_name="${i}-config-3.h"
    cat > ${problem_name} \
        <(echo '#include "./config.common"') \
        <(echo "#define SOLVER_NITER ${minIter}*${ratio}^(${maxPower}-${i})") \
        <(echo "#define PLOT_FLAGS --extension \"png\" --step $((ratio ** (maxPower -i)))") \
        <(echo "#define SOLVER_DT ${maxDt}*${ratio}.0^(${i}-${maxPower})")
done
