#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import subprocess


bash_command = "ls output/phi/phi.*.vtk | wc -l"
# process = subprocess.Popen(bash_command.split(), stdout=subprocess.PIPE)
# output, error = process.communicate()

n_plots = 20
n_files = int(os.popen(bash_command).read())

if n_files > n_plots:
    n_iterations = n_files // n_plots
else:
    n_iterations = n_files

print(n_files)
for i in range(n_iterations):
    os.system("output_file=pictures/phi/phi.mesh."+str(i)+".pdf gnuplot gnuplot/plot.plt;")
    os.system("output_file=pictures/mu/mu.mesh."+str(i)+".pdf gnuplot gnuplot/plot.plt;")
    os.system("output_file=pictures/pressure/pressure.filledcurves."+str(i)+".pdf gnuplot gnuplot/plot.plt;")
