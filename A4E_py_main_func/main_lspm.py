# -*- coding: utf-8 -*-
"""
Created on Mon Aug  5 19:27:47 2019

@author: Nikola
"""

# LIBRARIES
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# EXTERNAL FUNCTIONS
# TODO
from py_lspm.py import lspm
from py_lspm_apl.py import lspm_apl
from py_roblspv.py import roblspv
from py_vaf.py import vaf

# CODE
# READING DATA
U_header = ['maxtempC',
  'mintempC',
  'tempC',
  'windspdKmph',
  'winddir16',
  'humidity',
  'pressure',
  'cloudcover',
  'feelslikeC',
  'workingday',
  'bankholiday',
  'workingsat']

U = pd.read_csv('data/retail/U.csv',header = None, names = U_header)
Y = pd.read_csv('data/retail/Y.csv',header = None)

N,r = Y.shape
m = (U.shape)[1]
par_intercept = 0

# MODEL 1
par_na = 2
par_nb = 0
mdl1 = lspm(U,Y,par_na,par_nb)
Ym1 = lspm_apl(U,Y,mdl1)

# MODEL 2
par_na = 2
par_nb = 2
mdl2 = lspm(U,Y,par_na,par_nb)
Ym2 = lspm_apl(U,Y,mdl2)

# MODEL 3
par_na = 2
par_nb = 2
# in data > roll rows 1 up and duplicate last row
U = np.roll(U,-1,axis=0)
U[:][-1] = U[:][-2]

mdl3 = lspm(U,Y,par_na,par_nb)
Ym3 = lspm_apl(U,Y,mdl3)

# MODEL 4
# replaces all negative values with 0
Ym4 = Ym3.clip(max=0)


n = max( (par_na.max(),par_nb.max()))

vaf_model_1 = vaf( Y[(n+1):][:], Ym1)
vaf_model_2 = vaf( Y[(n+1):][:], Ym1)
vaf_model_3 = vaf( Y[(n+1):][:], Ym1)
vaf_model_4 = vaf( Y[(n+1):][:], Ym1)

# moje da se oformi tablica s matplotlib
print ('VAF MODEL 1')
print (vaf_model_1)
print ('VAF MODEL 2')
print (vaf_model_2)
print ('VAF MODEL 3')
print (vaf_model_3)
print ('VAF MODEL 4')
print (vaf_model_4)

# v matlab ima dopulnitelni plot-ove
# TODO


