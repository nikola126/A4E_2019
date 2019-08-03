# -*- coding: utf-8 -*-
"""
Created on Wed Jul 31 15:19:22 2019

@author: Nikola
"""
import numpy as np


def py_dm2v(mat):
    vec = mat.flatten()
    return vec

# TESTING DATA
m = np.array([[1,2],[3,4]])
print(m)
print (py_dm2v(m))
    