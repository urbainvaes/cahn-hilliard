#!/usr/bin/env bash

temp_file=$(mktemp)
n=$(ls output/iso/contactLine* | wc -l)
for ((i=0;i<=$n;i=i+1));do 
sed '$ d' "output/iso/contactLine"$i".dat" > ${temp_file}
python << END
import numpy as np
x=np.genfromtxt(r''+"${temp_file}")
print(max(x[:,0]))
END
done
