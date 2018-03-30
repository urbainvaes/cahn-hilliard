// INITIAL CONDITION
real radius = 0.24*GEOMETRY_LX;
real x1 = 0.5*GEOMETRY_LX;
real y1 = 0.5*GEOMETRY_LY;
real z1 = 0;
func droplet1 = - tanh((sqrt((x - x1)^2 + (y - y1)^2 + (z - z1)^2) - radius)/(sqrt(2)*Cn));
func phi0 = droplet1;

// func phi0 = 0;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// BOUNDARY CONDITIONS
#ifndef PROBLEM_WELLS_THETA0
#define PROBLEM_WELLS_THETA0 (pi/2.)
#endif

#ifndef PROBLEM_WELLS_AMPLITUDE
#define PROBLEM_WELLS_AMPLITUDE (pi/6.)
#endif

// Space-dependent contact-angle
real theta0 = PROBLEM_WELLS_THETA0;
real frequencyX = 4;
real frequencyY = 4;
real amplitude = PROBLEM_WELLS_AMPLITUDE;
real biasX = 0.0;
real biasY = 0.0;


// Wells
real phobicAngle = 5*pi/6;
func contactAngles = phobicAngle * (label > 2) + amplitude * cos(frequencyX*pi*(x - biasX)) * cos(frequencyY*pi*(y - biasY)) * ((label == 1) + (label == 2));

#include "common.pde"
