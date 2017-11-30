#!/usr/bin/env python

import argparse
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import os

# Parse arguments
parser = argparse.ArgumentParser()
parser.add_argument('label', type=str,
                    help='label used when saving pictures')
parser.add_argument('-i', '--input', type=str, default="output",
                    help='directory of data files')
parser.add_argument('-o', '--output', type=str, default="pictures",
                    help='directory for figure files')
args = parser.parse_args()

# Matplotlib configuration
matplotlib.rc('font', size=14)
matplotlib.rc('font', family='serif')
matplotlib.rc('text', usetex=True)

# Load data from files
titles = {'time': 'Time',
          'iteration': 'Iteration',
          'time_step': 'Time step',
          'mass': 'Mass',
          'wall_free_energy': 'Wall free energy',
          'interior_free_energy': 'Mixing energy',
          'total_free_energy': 'Total free energy',
          'diffusive_mass_increment': 'Diffusive mass increment',
          'diffusive_free_energy_increment': 'Diffusive free energy increment'}

data_file = args.input + '/thermodynamics.txt'
with open(data_file, 'r') as f:
    keys = f.readline().strip().split(" ")
data_aux = np.loadtxt(data_file, skiprows=1)
data = {keys[i]: data_aux[:, i] for i in range(len(titles))}

# Create figures
output_dir = args.output + '/macros'
if not os.path.isdir(output_dir):
    os.makedirs(output_dir)

line_format = 'k.-'

# vs iteration
for key in data:
    plt.figure()
    if key == 'time_step':
        plt.plot(data['iteration'], data[key], line_format)
        plt.yscale('log', basey=2)
    else:
        plt.plot(data['iteration'], data[key], line_format)
    plt.title(titles[key])
    plt.xlabel('Iteration')
    plt.savefig(args.output + '/macros/iteration-' + key + '.pdf',
                bbox_inches='tight')
    plt.close()

# vs time
for key in data:
    plt.figure()
    plt.plot(data['time'], data[key], line_format)
    plt.title(titles[key])
    plt.xlabel('Time')
    plt.savefig(args.output + '/macros/time-' + key + '.pdf',
                bbox_inches='tight')
    plt.close()
