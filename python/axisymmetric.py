#!/usr/bin/env python
# encoding: utf-8

"""
Solution of the Cahn - Hilliard equation.
"""
import sympy

cn = sympy.Symbol('cn')
r = sympy.Symbol('r')
f = sympy.Function('f')(r)

mu = f*f*f - f - cn * (1/r) * sympy.diff(r * sympy.diff(f,r), r)
dfdt = sympy.simplify( (1/r) * sympy.diff(r * sympy.diff(mu,r), r) )

print(dfdt)
