# -*- coding: utf-8 -*-
"""
Created on Wed Aug  7 11:07:51 2019

@author: Nikola
"""
import numpy as np

# INPUTS
# U, Y, E (matrices), par (structure)

# OUTPUTS
# F (matrix)

def dmpm(U,Y,E,par_na = 0, par_nb = 0, par_nc = 0, par_intercept = 0):
    # DEFAULTS INCLUDED
    
    if U.size() != 0:
        N = np.shape(U)
        N = N[1]
    elif Y.size() != 0:
        N = np.shape(U)
        N = N[1]
    elif E.size() != 0:
        N = np.shape(E)
        N = N[1]
    else:
        print("ERROR: AT LEAST ONE MATRIX SHOULD BE NOT EMPTY!")
        return

    if np.any(par_na) :
        na = np.max(par_na[:][:])
    if np.any(par_nb) :
        nb = np.max(par_nb[:][:])
    if np.any(par_nc) :
        nc = np.max(par_nc[:][:])
        
    n = max( (na.max(),nb.max(),nc.max()) )
    
    if par_intercept:
        F = np.ones(((N-n),1))
    else:
        F = np.empty((1,1))
        
    for i in range(na,1,-1):
        # in MATLAB:
        # F = [F -Y(n - na + i:N - na + i - 1, :)]
        # ????????
        
        row_idx_start = (n-na+i)
        row_idx_end = (N-na+i-1)
        
        val_to_append = Y[row_idx_start:row_idx_end,:] * (-1)
        # axis = ???
        # v kakva posoka raste F ???
        F = np.append(F,val_to_append,axis = 0)
        
    