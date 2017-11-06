#!/usr/bin/env python

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

# Matplotlib configuration
matplotlib.rc('font', size=14)
matplotlib.rc('font', family='serif')
matplotlib.rc('text', usetex=True)

maxStep = 1e-4 * 2**5  # Maximum time step: plog manually
errors = [np.genfromtxt('output/error-' + str(i) + '.txt')
          for i in range(1, 6)]
time = [i*maxStep for i in range(len(errors[0]))]

plt.figure()
plt.xlabel('Time')
plt.title('$L^2$ Error')
plt.yscale('log', basey=2)
for i in range(len(errors)):
    # line_format = 'k.-'
    plt.plot(time, errors[i], label='$\Delta t = \Delta t_{\\min} \\times 2^{' + str(i) + '}$')

plt.legend()
plt.savefig('output/error-time.pdf', bbox_inches='tight')
plt.close()
