#!/usr/bin/env python

# Import packages
import argparse  # parse options
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import mesh  # gmsh
import multiprocessing
import numpy as np
import os

# Parse options
parser = argparse.ArgumentParser()
parser.add_argument('label', type=str,
                    help='label used when saving pictures')
parser.add_argument('-f', '--flow', action='store_true',
                    help='include pressure and velocity')
parser.add_argument('-m', '--mesh', action='store_true',
                    help='draw triangulation')
parser.add_argument('-p', '--parallel', action='store_true',
                    help='run in parallel')
parser.add_argument('-e', '--extension', type=str, default='pdf',
                    help='extension of output files')
parser.add_argument('-i', '--iteration', type=str,
                    help='iteration number')
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

# Define colormaps
c1 = (0.5, 1, 0.5)
c2 = (0.5, 0.5, 1)
color_dict = {'red':   ((0, c1[0], c1[0]), (1, c2[0], c2[0])),
              'green': ((0, c1[1], c1[1]), (1, c2[1], c2[1])),
              'blue':  ((0, c1[2], c1[2]), (1, c2[2], c2[2]))}
plt.register_cmap(name='blue_green', data=color_dict)
colormaps = {}
colormaps['phi'] = 'blue_green'
colormaps['mu'] = 'jet'
colormaps['pressure'] = 'jet'

# Set canvas and font sizes
inch_size = 20
font_size = inch_size / 10 * 20
matplotlib.rc('font', size=font_size)
matplotlib.rc('font', family='serif')
matplotlib.rc('text', usetex=False)

if args.iteration:
    iterations = [int(args.iteration)]
else:
    n_files = len([f for f in os.listdir(args.input + '/done')])
    n_plots = int(n_files / args.step)
    iterations = [args.step * i for i in range(n_plots)]

# Create directories if they are missing
fields = ['phi', 'mu']
if args.flow:
    fields += ['pressure', 'velocity']
for f in fields:
    directory = args.output + '/' + f
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


def plot_iteration(iteration):

    print("Generating plots for iteration " + str(iteration) + ".")

    # Load mesh if needed
    if adaptation:
        file_mesh = args.input + '/mesh/mesh-' + str(iteration) + '.msh'
        tri_data, tri_mesh = \
            mesh.mesh(file_mesh).export_matplotlib_triangulation()
    else:
        tri_data = triangulation_data
        tri_data = triangulation_mesh

    # Load data files
    data = {}
    for f in fields:
        data[f] = mesh.read_data(
            args.input + '/' + f + '/' + f + '-' + str(iteration) + '.msh')

    # Define titles
    titles = {}
    titles['phi'] = r'Phase field ($\phi$)'
    titles['mu'] = r'Chemical potential ($\mu$)'
    titles['pressure'] = r'Pressure ($p$)'
    titles['velocity'] = r'Velocity ($\mathbf u$)'

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

    # Mesh
    if args.mesh:
        plt.triplot(tri_mesh, lw=1, color='k')

    # Interface
    plt.tricontour(tri_data, data['phi'], levels=[0], colors='k')

    for f in fields:
        if f == 'phi':
            tricontourf = plt.tricontourf(
                tri_data, data[f], 40,
                cmap='blue_green', extend='both')
        elif f == 'mu':
            tricontourf = plt.tricontourf(
                tri_data, data[f], 40, cmap='jet')
        elif f == 'pressure':
            tricontourf = plt.tricontourf(
                tri_data, data[f], 40, cmap='jet')
        elif f == 'velocity':
            vx = [data[f][i][0] for i in range(len(data[f]))]
            vy = [data[f][i][1] for i in range(len(data[f]))]
            abs_v = [np.sqrt(vx[i] * vx[i] + vy[i] * vy[i])
                     for i in range(len(data[f]))]
            tricontourf = plt.tricontourf(tri_data, abs_v, 40)
        colorbar = plt.colorbar(
            tricontourf, orientation=c_orientation, fraction=0.05, pad=0.05)
        for c in tricontourf.collections:
            c.set_edgecolor("face")  # Fix for white lines between levels
        if f == 'Velocity':
            plt.quiver(x, y, vx, vy)
        plt.title(titles[f], y=1.02)
        output = args.output + '/' + f + '/' + args.label + '-' + f + '-' + \
            '%05d' % (iteration) + '.' + args.extension
        plt.xticks([])
        plt.yticks([])
        plt.savefig(output, bbox_inches='tight')
        for c in tricontourf.collections:
            c.remove()
        colorbar.remove()
    plt.close()


if args.parallel:
    pool = multiprocessing.Pool()
    pool.map(plot_iteration, iterations)
else:
    for iteration in iterations:
        plot_iteration(iteration)
