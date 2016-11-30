#!/usr/bin/env bash

temp_file=$(mktemp)
n=$(ls output/iso/contactLine* | wc -l)
for ((i=0;i<=$n;i=i+1));do
head -n 50 "output/iso/contactLine"$i".dat" > ${temp_file}
python << END
import numpy as np
x=np.genfromtxt(r''+"${temp_file}")
fit=np.polyfit(x[:,1],x[:,0],2)
# In units of pi
# print(fit)
print((0.5*np.pi+np.arctan(fit[1]))/np.pi)
END
done
