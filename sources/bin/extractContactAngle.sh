#!/usr/bin/env bash

output_file="contact_angle.txt"

temp_file=$(mktemp)
rm -f ${output_file}
n=$(ls output/iso/contactLine* | wc -l)
for ((i=0;i<=$n;i=i+1));do 
head -n 10 "output/iso/contactLine"$i".dat" > ${temp_file}
python >> ${output_file} << END
import numpy as np
x=np.genfromtxt(r''+"${temp_file}")
fit=np.polyfit(x[:,1],x[:,0],2)
# In units of pi
print((0.5*np.pi+np.arctan(fit[1]))/np.pi)
END
done
