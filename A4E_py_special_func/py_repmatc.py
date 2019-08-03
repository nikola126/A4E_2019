# -*- coding: utf-8 -*-
"""
Created on Wed Jul 31 17:40:41 2019

@author: Nikola
"""
import numpy as np

def py_repmatc(X,m):
    # APPENDS MATRIX TO MATRIX
    n = np.shape(X)
    n = n[1]
    
    # EXTENDING
    # SAVE INITIAL MATRIX
    extender = X
    # APPEND M TIMES
    for times in range(m-1):
        X = np.append(X,extender,axis = 1)
    return X

# TESTING DATA
X = np.array([[1,2,3,4],[1,2,3,4],[1,2,3,4],[1,2,3,4]])
reps = 2
print(py_repmatc(X,reps))