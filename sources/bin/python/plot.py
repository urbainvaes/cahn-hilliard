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
import re

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
parser.add_argument('-C', '--nocolorbar', action='store_true',
                    help='draw colorbar')
parser.add_argument('-i', '--iteration', type=str,
                    help='iteration number')
parser.add_argument('-s', '--step', type=int, default=1,
                    help='step for iterations')
parser.add_argument('--input', type=str, default="output",
                    help='directory of data files')
parser.add_argument('--output', type=str, default="pictures",
                    help='directory for figure files')
parser.add_argument('-T', '--notitle', action='store_true',
                    help='do not print title')
parser.add_argument('-l', '--latex', action='store_true',
                    help='Use latex in matplotlib rc')
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

# Parameters for colorbar
lim_aspect_ratio = 2.1
c_orientation = "vertical" if (lim_aspect_ratio*dy > dx) else "horizontal"
c_fraction = 0.045 if dx < dy or dx > lim_aspect_ratio*dy else 0.045*dy/dx

# Define colormaps
c1 = (0.6, 1, 0.6)
c2 = (0.6, 0.6, 1)
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
font_size = inch_size * 2
matplotlib.rc('font', size=font_size)
matplotlib.rc('font', family='serif')
matplotlib.rc('text', usetex=args.latex)

if args.iteration:
    iterations = [int(args.iteration)]
else:
    files = [f for f in os.listdir(args.input + '/done')]
    n_files = max([int(re.findall("\\d+", f)[0]) for f in files])
    n_plots = int(n_files / args.step)
    iterations = [args.step * i for i in range(n_plots)]

# Time
time = np.loadtxt(args.input + '/thermodynamics.txt', skiprows=1)[:,1]

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

# Define titles
titles = {}
titles['phi'] = r'Phase field ($\phi$)'
titles['mu'] = r'Chemical potential ($\mu$)'
titles['pressure'] = r'Pressure ($p$)'
titles['velocity'] = r'Velocity ($\mathbf u$)'


def plot_iteration(iteration):

    print("Generating plots for iteration " + str(iteration) + ".")

    # Load mesh if needed
    if adaptation:
        file_mesh = args.input + '/mesh/mesh-' + str(iteration) + '.msh'
        tri_data, tri_mesh = \
            mesh.mesh(file_mesh).export_matplotlib_triangulation()
    else:
        tri_data = triangulation_data
        tri_mesh = triangulation_mesh

    # Load data files
    data = {}
    for f in fields:
        data[f] = mesh.read_data(
            args.input + '/' + f + '/' + f + '-' + str(iteration) + '.msh')

    # Set figure size and padding
    plt.figure(figsize=(inch_size, inch_size))
    plt.xlim(xlim)
    plt.ylim(ylim)

    # Edges
    for entity in edges:
        vertices_x = [v[0] for v in entity]
        vertices_y = [v[1] for v in entity]
        plt.plot(vertices_x, vertices_y, 'gray')
    plt.axis('scaled')
    plt.axis('off')

    # Mesh
    if args.mesh:
        plt.triplot(tri_mesh, lw=0.5, color='gray')

    # Interface
    plt.tricontour(tri_data, data['phi'], levels=[0], colors='k')

    for f in fields:
        if f == 'phi':
            tricontourf = plt.tricontourf(
                tri_data, data[f], levels=np.linspace(-1.1, 1.1, 40),
                cmap='jet')
        elif f == 'mu':
            tricontourf = plt.tricontourf(
                tri_data, data[f], 40, cmap='jet')
                # tri_data, data[f], levels=np.linspace(-4, 2.5, 80), cmap='jet')
                # tri_data, data[f], levels=np.linspace(0, 8, 80), cmap='jet')
        elif f == 'pressure':
            tricontourf = plt.tricontourf(
                tri_data, data[f], 40, cmap='jet')
        elif f == 'velocity':
            vx = [data[f][i][0] for i in range(len(data[f]))]
            vy = [data[f][i][1] for i in range(len(data[f]))]
            abs_v = [np.sqrt(vx[i] * vx[i] + vy[i] * vy[i])
                     for i in range(len(data[f]))]
            tricontourf = plt.tricontourf(tri_data, abs_v, 40)
        if not args.nocolorbar:
            if f == 'phi':
                colorbar = plt.colorbar(
                        tricontourf, orientation=c_orientation,
                        fraction=c_fraction, pad=0.01)
                        # fraction=c_fraction, pad=0.01, ticks=[-1, -.5, 0, .5, 1])
            elif f == 'mu':
                colorbar = plt.colorbar(
                        tricontourf, orientation=c_orientation,
                        fraction=c_fraction, pad=0.01)
                        # fraction=c_fraction, pad=0.01, ticks=[-4, -3, -2, -1, 0, 1, 2])
                        # fraction=c_fraction, pad=0.01, ticks=list(range(9)))
            else:
                colorbar = plt.colorbar(
                        tricontourf, orientation=c_orientation,
                        fraction=c_fraction, pad=0.01)
        for c in tricontourf.collections:
            c.set_edgecolor("face")  # Fix for white lines between levels
        if f == 'Velocity':
            plt.quiver(x, y, vx, vy)
        if not args.notitle:
            # plt.title(titles[f], y=1.02)
            plt.title("Iteration: {}, time: {:.2f}".format(iteration, time[iteration]), y=1.02)
        output = args.output + '/' + f + '/' + args.label + '-' + f + '-' + \
            '%06d' % (iteration) + '.' + args.extension
        plt.xticks([])
        plt.yticks([])
        plt.tight_layout()
        plt.savefig(output, bbox_inches='tight')
        for c in tricontourf.collections:
            c.remove()
        if not args.nocolorbar:
            colorbar.remove()
    plt.close()


if args.parallel:
    pool = multiprocessing.Pool()
    pool.map(plot_iteration, iterations)
else:
    for iteration in iterations:
        plot_iteration(iteration)
