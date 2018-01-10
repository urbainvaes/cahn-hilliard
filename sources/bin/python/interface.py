#!/usr/bin/env python

# Import packages
import argparse  # parse options
import matplotlib
# matplotlib.use('Agg')
import matplotlib.pyplot as plt
import mesh  # gmsh
import multiprocessing
import numpy as np
import os

# Parse options
parser = argparse.ArgumentParser()
parser.add_argument('label', type=str,
                    help='label used when saving pictures')
parser.add_argument('-s', '--step', type=int, default=1,
                    help='step for iterations')
parser.add_argument('--input', type=str, default="output",
                    help='directory of data files')
parser.add_argument('--output', type=str, default="pictures",
                    help='directory for figure files')
args = parser.parse_args()

# Extract boundary of domain
initial_mesh = mesh.mesh(args.input + '/mesh.msh')
edges = initial_mesh.get_matplotlib_triangulation_edges()
initial_triangulation, nil = initial_mesh.export_matplotlib_triangulation()

# Calculate limits size of domain
x = initial_triangulation.x
y = initial_triangulation.y
dx = max(x) - min(x)
dy = max(y) - min(y)
padding = 0.1 * min(dx, dy)
xlim = (min(x) - padding, max(x) + padding)
ylim = (min(y) - padding, max(y) + padding)
c_orientation = "vertical" if (dy > dx) else "horizontal"

# Set canvas and font sizes
inch_size = 20
font_size = inch_size / 10 * 20
matplotlib.rc('font', size=font_size)
matplotlib.rc('font', family='serif')
matplotlib.rc('text', usetex=False)

n_files = len([f for f in os.listdir(args.input + '/done')])
n_plots = int(n_files / args.step)
iterations = [args.step * i for i in range(n_plots)]

# Create directories if they are missing
directory = args.output + '/interface'
if not os.path.isdir(directory):
    os.makedirs(directory)

# Guess if file exist
adaptation = os.path.isfile(args.input + '/mesh/mesh-0.msh')

# Guess if high order elements were used
file_ho = args.input + '/high-order-mesh.msh'
high_order = os.path.isfile(file_ho)

# Set triangulation for data in plots
if adaptation:
    print('Detected mesh adaptation\n')
else:
    if high_order:
        print('Detected a high order mesh\n')
        triangulation_data, triangulation_mesh = \
            mesh.mesh(file_ho).export_matplotlib_triangulation()
    else:
        print('Using initial gmsh mesh for plots\n')
        triangulation_mesh = initial_triangulation
        triangulation_data = initial_triangulation

# Set figure size and padding
plt.figure(figsize=(inch_size, inch_size))
plt.xlim(min(x) - padding, max(x) + padding)
plt.ylim(min(y) - padding, max(y) + padding)

# Edges
for entity in edges:
    vertices_x = [v[0] for v in entity]
    vertices_y = [v[1] for v in entity]
    plt.plot(vertices_x, vertices_y, 'gray')
plt.axis('scaled')
plt.axis('off')

for iteration in iterations:

    print("Adding interface of iteration " + str(iteration) + ".")

    # Load mesh if needed
    if adaptation:
        file_mesh = args.input + '/mesh/mesh-' + str(iteration) + '.msh'
        tri_data, tri_mesh = \
            mesh.mesh(file_mesh).export_matplotlib_triangulation()
    else:
        tri_data = triangulation_data
        tri_data = triangulation_mesh

    # Load data files
    phase = mesh.read_data(args.input + '/phi/phi-' + str(iteration) + '.msh')

    # Interface
    plt.tricontour(tri_data, phase, levels=[0], colors='k')

output = args.output + '/interface/' + args.label + '-interfaces.pdf'
plt.savefig(output, bbox_inches='tight')
plt.close()
