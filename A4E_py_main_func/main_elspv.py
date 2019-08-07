# -*- coding: utf-8 -*-
"""
Created on Tue Aug  6 11:45:57 2019

@author: Nikola
"""

# LIBRARIES
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# EXTERNAL FUNCTIONS
# TODO
from py_lspv import lspv
from py_lspv_apl import lspv_apl
from py_elspv.py import elspv
from py_elspv_apl.py import elspv_apl
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
par_na = np.ones((r,r)) * 2
par_nb = np.ones((r,m)) * 2
par_nc = np.ones((r,r)) * 2

# LS for ARX
# mdl0 e struktura v matlab no v sledvashti stupki se izpolzva vektor stoinosti
mdl0 = lspv(U,Y,par_intercept,par_na,par_nb)
# Ym0 e matrica
Ym0 = lspv_apl(U,Y,mdl0)
# vektor ot mdl0_pm i nuli
Pm0_zeros = np.zeros(((int(sum(sum(par_nc))),1)))
Pm0 = np.append(mdl0,Pm0_zeros())

# ELS
par_opt_max_iter = 50
par_opt_taux = 1e-06
par_opt_tauf = 1e-06
par_opt_dsp = 0

# elspv vrushta nqkolko promenlivi - struktura i matrica
elspv_tuple = elspv(U,Y,par_na,par_nb,par_nc,par_intercept,par_opt_dsp, \
                    par_opt_max_iter,par_opt_tauf,par_opt_taux)
mdl = elspv_tuple(0)
E = elspv_tuple(1)
Ym = elspv_apl(U,Y,E,mdl)
Pm = mdl0

# VARIANCE ACCOUNTED FOR
n1 = max( (par_na.max(),par_nb.max()) )
n2 = max( (par_na.max(),par_nb.max(),par_nc.max()) )

# VAF iska oshte argumenti, zadadeni sa defaults
VAF_LS = dm2v( Y[(n1+1):][:], Ym0)
VAF_ELS = dm2v( Y[(n2+1):][:], Ym)

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

# ima dopulnitelni vizualizacii