#!/usr/bin/env bash

temp_file=$(mktemp)
n=$(ls output/iso/contactLine* | wc -l)
for ((i=0;i<=$n;i=i+1));do
    file="output/iso/contactLine"$i".dat"
    end_r=$(head -n 1 ${file} | cut -f 1 -d ' ')
    end_l=$(tail -n 2 ${file} | head -n 1 | cut -f 1 -d ' ')
    echo $(python -c "print((${end_r} - ${end_l})/2.)")
done
