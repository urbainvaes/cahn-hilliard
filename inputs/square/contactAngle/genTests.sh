#!/usr/bin/env bash

contact_angles="pi/3 5*pi/12 pi/2 7*pi/12 2*pi/3"

for angle in ${contact_angles}; do
    escaped_angle=$(echo ${angle} | tr "*" "t" | tr "/" "o")
    problem_name="${escaped_angle}-config.h"
    cat > ${problem_name} \
        <(echo "#include xstr(HERE/config.common)") \
        <(echo "#define CONTACT_ANGLE ${angle}")
done
