#!/usr/bin/env python

import argparse  # parse options
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import os
import re

# Parse options
parser = argparse.ArgumentParser()
parser.add_argument('label', type=str,
                    help='label used when saving pictures')
parser.add_argument('-c', '--convergence', type=str, default='time',
        help='variable with respect to which the convergence is studied')
parser.add_argument('-l', '--latex', action='store_true',
                    help='Use latex in matplotlib rc')
args = parser.parse_args()

# Matplotlib configuration
matplotlib.rc('font', size=14)
matplotlib.rc('font', family='serif')
matplotlib.rc('text', usetex=args.latex)

# In the case of convergence with respect to the time step, remove data
# relative to 0-th iteration, because the error would be 0 there.
data_file = 'output/errors.txt'
data = np.loadtxt(data_file)
if args.convergence == 'time':
    data = data[1:]

# Create figures
output_dir = 'pictures'
if not os.path.isdir(output_dir):
    os.makedirs(output_dir)

line_format = 'k-'
plt.figure()
for i in range(1, len(data[0, :])):
    if args.convergence == 'time':
        plt.plot(data[:, i],
                 label='$\Delta t = \Delta t^* \\times 2^{' + str(i) + '}$')
    else:
        plt.plot(data[:, i],
                 label='$\log_2(h/h^*) = {:.1f}$'.format(i/2.))
plt.yscale('log', basey=2)
plt.xlabel('Iteration')
plt.title('$L^2(\Omega)$ error')
plt.legend(loc='upper right', bbox_to_anchor=(1.4, 1))
plt.savefig('pictures/' + args.label + '-errors-time.pdf', bbox_inches='tight')
plt.close()

plt.figure()
ratio = np.sqrt(2) if args.convergence == 'space' else 2
x = ratio ** np.arange(1, len(data[0, :]))
y = np.amax(data, 0)[1:]
coefs = np.polyfit(np.log2(x), np.log2(y), 1)
plt.plot(x, y, 'k.', label='Numerical results')
plt.plot(x, 2 ** coefs[1] * x ** coefs[0], 'k-',
         label='Linear approximation: $y = C\,x^{{{:.2f}}}$'.format(coefs[0]))
plt.xscale('log', basex=2)
plt.yscale('log', basey=2)
if args.convergence == 'time':
    convergence_label = 'Time step ($\\Delta t/\\Delta t ^*$)'
else:
    convergence_label = 'Mesh size $(h/h^*)$'
plt.xlabel(convergence_label)
plt.title('$L^{\infty}(0,T;L^2(\Omega))$ error')
plt.xlim(min(x)/pow(2., .25), max(x)*pow(2, .25))
plt.legend(loc='upper left')
plt.savefig('pictures/' + args.label + '-convergence.pdf', bbox_inches='tight')
plt.close()

if args.convergence == 'time':
    n_points = 6
    data = []
    for i in range(n_points):
        data_file = '../' + str(i) + '/output/thermodynamics.txt'
        with open(data_file, 'r') as f:
            keys_line = f.readline().strip()
            keys = re.split("\s+", keys_line)
        data_aux = np.loadtxt(data_file, skiprows=1)
        data.append({keys[j]: data_aux[:, j] for j in range(len(keys))})

    plt.figure()
    ratio = 2
    x = ratio ** np.arange(0, n_points)
    y = [max(np.abs(dic['int_numerical_dissipation'])) for dic in data]
    coefs = np.polyfit(np.log2(x), np.log2(y), 1)
    plt.plot(x, y, 'k.', label='Numerical results')
    plt.plot(x, 2 ** coefs[1] * x ** coefs[0], 'k-',
             label='Linear approximation: $y = C\,x^{{{:.2f}}}$'.format(coefs[0]))
    plt.xscale('log', basex=2)
    plt.yscale('log', basey=2)
    convergence_label = 'Time step ($\\Delta t/\\Delta t ^*$)'
    plt.xlabel(convergence_label)
    plt.title('Numerical dissipation')
    plt.xlim(min(x)/pow(2., .25), max(x)*pow(2, .25))
    plt.legend(loc='upper left')
    plt.savefig('pictures/' + args.label + '-numerical_dissipation.pdf', bbox_inches='tight')
    plt.close()
