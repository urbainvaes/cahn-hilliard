#!/usr/bin/env python

import argparse
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import os
import re

# Parse arguments
parser = argparse.ArgumentParser()
parser.add_argument('label', type=str,
                    help='label used when saving pictures')
parser.add_argument('-i', '--input', type=str, default="output",
                    help='directory of data files')
parser.add_argument('-o', '--output', type=str, default="pictures",
                    help='directory for figure files')
parser.add_argument('-t', '--titles', action='store_true',
                    help='do not print title')
parser.add_argument('-l', '--latex', action='store_true',
                    help='Use latex in matplotlib rc')
args = parser.parse_args()

# Matplotlib configuration
matplotlib.rc('font', size=14)
matplotlib.rc('font', family='serif')
matplotlib.rc('text', usetex=args.latex)

# Load data from files
titles = {'time': 'Time',
          'iteration': 'Iteration',
          'time_step': 'Time step',
          'mass': 'Mass',
          'wall_free_energy': 'Wall free energy',
          'interior_free_energy': 'Mixing energy',
          'total_free_energy': 'Total free energy',
          'diffusive_mass_increment': 'Diffusive mass increment',
          'diffusive_free_energy_increment': 'Diffusive free energy increment',
          'numerical_dissipation': 'Numerical dissipation',
          'rate_numerical_dissipation': 'Rate of numerical dissipation'}

data_file = args.input + '/thermodynamics.txt'
with open(data_file, 'r') as f:
    keys_line = f.readline().strip()
    keys = re.split("\s+", keys_line)
data_aux = np.loadtxt(data_file, skiprows=1)
data = {keys[i]: data_aux[:, i] for i in range(len(keys))}

# Create figures
output_dir = args.output + '/macros'
if not os.path.isdir(output_dir):
    os.makedirs(output_dir)

line_format = 'k-'

# vs iteration
for key in data:
    plt.figure()
    plt.plot(data['iteration'], data[key], line_format)
    if key == 'time_step':
        plt.yscale('log', basey=2)
        plt.ylim([2**(-30), 1])
    if args.titles:
        plt.title(titles[key])
    plt.margins(0.05, 0.05)
    plt.xlabel('Iteration')
    plt.savefig(args.output + '/macros/iteration-' + key + '.pdf',
                bbox_inches='tight')
    plt.close()

# vs time
for key in data:
    plt.figure()
    plt.plot(data['time'], data[key], line_format)
    if key == 'time_step':
        plt.yscale('log', basey=2)
    if args.titles:
        plt.title(titles[key])
    plt.margins(0.05, 0.05)
    plt.xlabel('Time')
    plt.savefig(args.output + '/macros/time-' + key + '.pdf',
                bbox_inches='tight')
    plt.close()
