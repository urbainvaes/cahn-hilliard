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

for key in data:
    if not key == 'time':
        plt.figure()
        plt.plot(data['time'], data[key])
        plt.title(titles[key])
        plt.savefig(args.output_dir + '/' + key + '.pdf', bbox_inches='tight')
