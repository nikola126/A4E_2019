# -*- coding: utf-8 -*-
"""
Created on Wed Jul 31 16:00:13 2019

@author: Nikola
"""

import numpy as np

def py_dv2m(vec,n):
    dim_x = int(vec.shape[0])
    N = int(dim_x / n)

    indexes_1 = np.ones((N,1)) * np.arange(1,n+1)
    indexes_2 = np.array((np.arange(0,(N*n - 1),n))) * np.ones((1,n))
    indexes_2 = indexes_2.transpose()
    
    # EXTENDING
    # SAVE INITIAL MATRIX
    extender = indexes_2
    # APPEND n TIMES
    how_many_times = indexes_1.shape[1]
    for times in range(how_many_times-1):
        #print("Appending")
        indexes_2 = np.append(indexes_2,extender,axis = 1)
    
    ind = indexes_1 + indexes_2
    new_shape = ind.shape
    #print(ind)
    
    # RESHAPE
    X = big_vec.reshape(new_shape)
    return X

# TESTING DATA
big_vec = np.array([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16])
print(py_dv2m(big_vec,4))