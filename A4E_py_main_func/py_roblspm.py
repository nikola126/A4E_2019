# -*- coding: utf-8 -*-
"""
Created on Sun Aug  4 16:37:01 2019

@author: Nikola
"""

# LIBRARIES
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# EXTERNAL FUNCTIONS
# TODO
from py_lspv.py import lspv
from py_lspv_apl.py import lspv_apl
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

Y0 = Y[[0,1]].copy()
Y = Y0
a = 10

# za6to 50? normirane?
Y[0:a][0] = Y[0:a][0].multiply(50).copy()

m, r = (U.shape)[1], (Y.shape)[1]

# v matlab se suzdava struktura PAR
# v python shte se podavat nqkolko parametura s podobni imena PAR
par_intercept = 0
par_matrix_type = 'full'

par_na = 2
par_nb = 2

n = max(par_na,par_nb)

# LS
# trqbva oformqne na PAR v nqkakva struktura za da se sukrati izvikvaneto na funkciqta
# dictionary?
mdl = lspv(U,Y,par_intercept,par_matrix_type,par_na,par_nb)
# mdl e struktura ot struktura i matrica (dictionary?)
Ym1 = lspv_apl(U,Y,mdl)
# Ym1 e matrica s dve koloni


# RobLS
par_opt_dvaf = 1*10^-6
par_opt_maxiter = 100
par_opt_hst = 1
mdl = roblspv(U,Y,par_intercept,par_matrix_type,par_na,par_nb,\
              par_opt_dvaf,par_opt_maxiter,par_opt_hst)
# mdl e struktura ot dve strukturi i matrica (dictionary?)
Ym = lspv_apl(U,Y,mdl)
# Ym e matrica s dve koloni

# VAFw
print ('VAFw')
# izvedenite danni v matlab sa na dve niva vutre v strukturata
# trqbva da se napravi nqkakuv dictionary v python za da se izkarat dannite
print (mdl[st][vafw])

print ('VAF')
print (mdl[st][vaf0])

vaf_model_1 = vaf( Y0[(a+n+1):][:], Ym1[(a+1):][:])
vaf_model_2 = vaf( Y0[(a+n+1):][:], Ym[(a+1):][:])

# moje da se oformi tablica s matplotlib
print ('VAF MODEL 1')
print (vaf_model_1)
print ('VAF MODEL 2')
print (vaf_model_2)

# v matlab ima dopulnitelni plot-ove
# TODO