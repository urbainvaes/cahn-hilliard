#!/usr/bin/env python

import mesh

myMesh = mesh.mesh(filename="output/mesh.msh")
f = open('output/edges.dat', 'w')
for entity in myMesh.entities:
    if entity.dimension == 1:
        for element in entity.elements:
            f.write(str(element.vertices[0][0]) + " " +
                    str(element.vertices[0][1]) + " " +
                    str(entity.physicals[0]) + "\n")
            f.write(str(element.vertices[1][0]) + " " +
                    str(element.vertices[1][1]) + " " +
                    str(entity.physicals[0]) + "\n\n\n")
