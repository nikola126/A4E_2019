# -*- coding: utf-8 -*-
"""
Created on Tue Aug  6 14:39:59 2019

@author: Nikola
"""

# LIBRARIES
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# EXTERNAL FUNCTIONS
# TODO
from py_lspm import lspm
from py_lspm_apl import lspm_apl
from py_elspm.py import elspm
from py_elspm_apl.py import elspm_apl
from py_dm2v.py import dm2v

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

U = pd.read_csv('./data/retail/U.csv',header = None, names = U_header)
Y = pd.read_csv('./data/retail/Y.csv',header = None)

N,r = Y.shape
m = (U.shape)[1]

par_intercept = 0
par_na = 2
par_nb = 2
par_nc = 2

par1_intercept = 0
par1_na = 2
par1_nb = 2

# LS ARX
mdl0 = lspm(U,Y,par1_intercept,par1_na,par1_nb)
Ym0 = lspm_apl(U,Y,mdl0)

Pm0_zeros = np.zeros(((r*par_nc),r))
Pm0 = np.append(mdl0,Pm0_zeros())

# ELS
par_opt_max_iter = 50
par_opt_taux = 1e-06
par_opt_tauf = 1e-06
par_opt_dsp = 0

# elspm vrushta nqkolko promenlivi - struktura i matrica
elspm_tuple = elspm(U,Y,par_na,par_nb,par_nc,par_intercept)
mdl = elspm_tuple(0)
E = elspm_tuple(1)
Ym = elspm_apl(U,Y,E,mdl)
Pm = mdl

# VARIANCE ACCOUNTED FOR
n = max( (par_na.max(),par_nb.max(),par_nc.max()) )

# VAF iska oshte argumenti, zadadeni sa defaults
VAF_LS = dm2v( Y[(n+1):][:], Ym0)
VAF_ELS = dm2v( Y[(n+1):][:], Ym)

# VISUALISATION

# data matrix to vector
LS_est = dm2v(Pm0)
ELS_est = dm2v(Pm)

err_abs = LS_est - ELS_est
# matrix arithmetic, trqbva proverka dali sa sushtite rezultati
err_rel_prc = err_abs / (ELS_est * 100)

# moje da se oformi tablica s matplotlib
print ('VAF LS')
print (VAF_LS)
print ('VAF ELS')
print (VAF_ELS)