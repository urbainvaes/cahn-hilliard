#!/usr/bin/env bash

ratio="sqrt(2)"
maxPower=8

for (( i = 0; i <= maxPower; i++ )); do
    problem_name="${i}-config.h"
    cat > ${problem_name} \
        <(echo '#include "./config.common"') \
        <(echo "#define SOLVER_CN CONFIG_BASE_CN*${ratio}^(${i})")
done
