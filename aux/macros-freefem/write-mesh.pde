// Copyright (C) 2009, 2010 G. D. McBain -*- c++ -*-

// Save a scalar solution in Gmsh .msh format.  The arguments are
// strings for the file and variable, the real array containing the
// variable (e.g. u[]), and the Gmsh element type (2 = TRI3, 4 = TET4,
// 9 = TRI6, 11 = TET10).

// Inspired from the scrpit by G. D. McBain <gdmcbain@freeshell.org>

func int gmshelmtyp (int n)
{
    // Return the Gmsh element type number, inferred from the number of
    // degrees of freedom per element.

    int e;
    if (n == 3) {       // TRI3
        e = 2;
    } else if (n == 4) {  // TET4
        e = 4;
    } else if (n == 6) {    // TRI6
        e = 9;
    } else if (n == 10) { // TET10
        e = 11;
    } else {
        cout << "Unknown element type, having " << n << "nodes!" << endl;
        assert (false); // Shouldn't get here!
    }
    return e;
}

func int[int] en (int t)
{
    // Return a one-dimensional array of permutation of the nodes of an
    // element for output to Gmsh, for Gmsh element type t.

    int[int] ndofK = [0, 0, 3, 0, 4, 0, 0, 0, 0, 6, 0, 10];
    int[int] r(ndofK[t]);

    if (t == 2) {     // 3-node triangle
        r = [0, 1, 2];
    } else {
        if (t == 4) {   // 4-node tetrahedron
            r = [0, 1, 2, 3];
        } else {
            if (t == 9) {   // 6-node triangle
                r = [0, 1, 2, 5, 3, 4];
            } else {
                if (t == 11) {  // 10-node tetrahedron
                    r = [0, 1, 2, 3, 4, 7, 5, 6, 9, 8];
                } else {
                    cout << "Unknown element type: " << t << "!" << endl;
                    assert (false);   // Shouldn't get here!
                }
            }
        }
    }
    return r;
}

macro writeHeader (ff) {
    ff << "$MeshFormat" << endl;
    ff << "2.2 0 8" << endl;
    ff << "$EndMeshFormat" << endl;
}//

// -- Write Nodes to file --
//
// ff : output file
// Vh : Finite element space
macro writeNodes (ff, Vh) {
    Vh[int] xh(3);
    xh[0] = x;
    xh[1] = y;
    xh[2] = z;
    ff << "$Nodes" << endl;
    ff << Vh.ndof << endl;
    for (int i = 0; i < Vh.ndof; i++)
    {
        ff << i + 1;
        for (int d = 0; d < 3; d++)
        {
            ff << "  " << xh[d][][i];
        }
        ff << endl;
    }
    ff << "$EndNodes" << endl;
}//

// -- Macro write elements --
//
// ff : output file
// Vh : Finite element space
macro writeElements (ff, Vh, Th) {
    int elmtyp = gmshelmtyp (Vh.ndofK);
    int[int] np = en (elmtyp);
    ff << "$Elements" << endl;
    ff << Vh.nt << endl;
    for (int e = 0; e < Vh.nt; e++) {
        ff << e+1 << "  "
            << elmtyp << "  "
            << "2  "
            << Th[e].label << "  "
            << Th[e].region;
        for (int n = 0; n < Vh.ndofK; n++)
            ff << "  " << Vh (e, np[n]) + 1;
        ff << endl;
    }
    ff << "$EndElements" << endl;
}//

// -- Write Node data to file --
//
// ff : output file
// desc : description of the data
// time : time corresponding to time step
// index : index of the time step
// function : scalar function to plot
macro write1dData (ff, desc, time, index, function) {
    ff << "$NodeData" << endl;
    ff << "1" << endl << desc << endl;
    ff << "1" << endl << time << endl;
    ff << "3" << endl << index << endl << "1" << endl << function.n << endl;
    for (int i = 0; i < function.n; i++)
    {
        ff << i + 1 << "  " << function[][i] << endl;
    }
    ff << "$EndNodeData" << endl;
}//

macro write2dData (ff, desc, time, index, f1, f2) {
    ff << "$NodeData" << endl;
    ff << "1" << endl << desc << endl;
    ff << "1" << endl << time << endl;
    ff << "3" << endl << index << endl << "2" << endl << f1.n << endl;
    for (int i = 0; i < function.n; i++)
    {
        ff << i + 1 << "  " << f1[][i] << "  " << f2[][i] << endl;
    }
    ff << "$EndNodeData" << endl;
}//

macro write3dData (ff, desc, time, index, f1, f2, f3) {
    ff << "$NodeData" << endl;
    ff << "1" << endl << desc << endl;
    ff << "1" << endl << time << endl;
    ff << "3" << endl << index << endl << "3" << endl << f1.n << endl;
    for (int i = 0; i < function.n; i++)
    {
        ff << i + 1 << "  " << f1[][i] << "  " << f2[][i] << "  " << f3[][i] << endl;
    }
    ff << "$EndNodeData" << endl;
}//

// -- Write mesh (without data) --
macro writeMsh (filename, Vh, Th) {
    ofstream ff(filename);
    writeHeader(ff);
    writeNodes(ff, Vh);
    writeElements(ff, Vh, Th);
}//

macro writeData (filename, desc, time, index, function) {
    ofstream ff(filename);
    writeHeader(ff);
    write1dData(ff, desc, time, index, function);
}//

macro writeAll (filename, Vh, Th, desc, time, index, function) {
    ofstream ff(filename);
    writeHeader(ff);
    writeNodes(ff, Vh);
    writeElements(ff, Vh, Th);
    write1dData(ff, desc, time, index, function);
}//
