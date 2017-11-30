#!/usr/bin/env python

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np
import os

# Matplotlib configuration
matplotlib.rc('font', size=14)
matplotlib.rc('font', family='serif')
matplotlib.rc('text', usetex=True)

data_file = 'output/errors.txt'
data = np.loadtxt(data_file)

maxStep = 1e-4 * 2**5
time = [i*maxStep for i in range(len(data))]

plt.figure()
for i in range(1, len(data[0, :])):
    plt.plot(time, data[:, i],
             label='$\Delta t = \Delta t^* \\times 2^{' + str(i) + '}$')
plt.xlabel('Time')
plt.title('$L^2(\Omega)$ error')
plt.yscale('log', basey=2)
plt.legend(bbox_to_anchor=(1.02, 1))
plt.savefig('pictures/errors-time.pdf', bbox_inches='tight')
plt.close()

plt.figure()
x = np.sqrt(2) ** np.arange(1, len(data[0, :]))
y = np.amax(data, 0)[1:]
coefs = np.polyfit(np.log2(x), np.log2(y), 1)
plt.plot(x, y, 'k.', label='Numerical results')
plt.plot(x, 2 ** coefs[1] * x ** coefs[0], 'k-',
         label='Linear approximation: $y = C\,x^{{{:.2f}}}$'.format(coefs[0]))
plt.xscale('log', basex=2)
plt.yscale('log', basey=2)
plt.title('Convergence with respect to the time step')
plt.xlabel('Time step ($\\Delta t/\\Delta t ^*$)')
plt.ylabel('$L^{\infty}(0,T;L^2(\Omega))$ error')
plt.legend()
plt.savefig('pictures/convergence-time.pdf', bbox_inches='tight')
plt.close()
