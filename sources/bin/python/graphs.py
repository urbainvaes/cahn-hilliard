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
          'iter': 'Iteration',
          'timeStep': 'Time step',
          'mass': 'Mass',
          'bulkFree': 'Free energy',
          'wallFree': 'Wall free energy',
          'diffMass': 'Diffusive mass flux',
          'diffFree': 'Diffusive free energy flux'}

data = {key: np.genfromtxt(args.input + '/macros/' + key + '.txt')
        for key in titles}

# Create figures
output_dir = args.output + '/macros'
if not os.path.isdir(output_dir):
    os.makedirs(output_dir)

line_format = 'k.-'

# vs iteration
for key in data:
    plt.figure()
    if key == 'timeStep':
        plt.semilogy(data['iter'], data[key], line_format)
    else:
        plt.plot(data['iter'], data[key], line_format)
    plt.title(titles[key])
    plt.xlabel('Iteration')
    plt.savefig(args.output + '/macros/iter-' + key + '.pdf',
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
