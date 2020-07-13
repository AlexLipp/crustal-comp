#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 13 15:06:22 2020

This script numerically  calculates the weathering, provenance coefficients for
a suite of major-element compositions incorporating a correction for cation 
exchange. 



Authors: Alex Lipp, Oliver Shorttle
Contact: a.lipp18@imperial.ac.uk
"""



import numpy as np
from scipy.stats.mstats import gmean
from scipy.optimize import minimize
import sys as sys
import time as time 

# These are command line arguments

# Path to a file which contains major element compositions to be inverted
target_comp_file = sys.argv[1]
# Path to where the output coefficients will be written 
coeffs_out_filename = sys.argv[2]
# Path to where the output fitted compositions will be written
fit_out_filename = sys.argv[3]


# Define some useful functions for compositional data analysis
def clr_trsfm(comp):
    # Centred log ratio transformation
  return(np.log(comp/(gmean(comp,axis=1).reshape(comp.shape[0],1))))

def clr_trsfm_row(comp):
    # Centred log ratio transformation for a row
  return(np.log(comp/(gmean(comp))))

def clr_inv(clr):
    # Inverse centred log-ratio transformation
  exp_clr = np.exp(clr)
  return(exp_clr/(np.sum(exp_clr,axis=1).reshape(clr.shape[0],1)))

def close(comp):
    # normalise a composition to 1
  return(comp/(np.sum(comp,axis=1).reshape(comp.shape[0],1)))  

def exchange_naca_prop(comp,prop_max_ca):
    # Synthetically models cation exchange
  init_nmol_ca = comp[5]/(56.0774) # mass to moles 
  init_nmol_na = comp[4]/(61.97894)*2
  
  total_max_ca = init_nmol_ca + 0.5*(init_nmol_na)
  new_nmol_ca = prop_max_ca*total_max_ca
  
  d_nmol_ca = new_nmol_ca - init_nmol_ca 
  new_nmol_na = init_nmol_na - 2*d_nmol_ca
  
  out = np.copy(comp)
  out[5] = new_nmol_ca*56.0774
  out[4] = new_nmol_na*61.97894*0.5  
  return(out/np.sum(out))

def coefficients_to_comp(omega,psi):
    # Calculates compositions from omega/psi pairs
    exp_clr = np.exp(UCC_clr + omega*w + psi*p)
    return(exp_clr/np.sum(exp_clr))
    
def find_coefficients_gradient_row(target_comp):
    # For an individual composition calculates omega, psi, and cation exchange 
    # values using gradient descent minimisation
    
  target_clr = clr_trsfm_row(target_comp)
  def objf(x, target_comp, target_clr): 
    # Define a cost/objective function to minimise. 
    omega = x[0]
    psi = x[1]
    prop_ca = x[2]
    comp = exchange_naca_prop(coefficients_to_comp(omega,psi),prop_ca)
    clr = clr_trsfm_row(comp)
    residuals = clr-target_clr
    misfit = np.linalg.norm(residuals)

    # This function generates a composition for a given omega, psi, catex 
    # and then calculates the misfit between this composition and the 'target' 
    # composition.
    return misfit

  # omega, psi, catex 
  x0 = (0., 0., 0.05) # Arbitrary starting point
  bnds = ((-6, 10), (-8, 8), (0.000001, 0.999999)) # Define bounds
  # Minimise objective function using gradient descent within bounds using 
  # Broyden–Fletcher–Goldfarb–Shanno (BFGS) algorithm.
  res = minimize(objf, x0, args=(target_comp, target_clr), bounds=bnds, method='L-BFGS-B')
          
  return(res.x)  
def find_coefficients_gradient(target_comp):
    # Wrapper function that applies the above function sequentially to a matrix 
    # of compositions. 
    nrow = target_comp.shape[0]
    start=time.time()
    print("Inverting",nrow,"rows")
    print("Predicted runtime:",nrow*0.0025,"s") # 0.0003675s per loop
    out_coeffs = np.zeros((nrow,3))
    for i in range(nrow):
        out_coeffs[i,:] = find_coefficients_gradient_row(target_comp[i,:])
    end = time.time()
    print("Actual runtime:", end-start,"s")
    return(out_coeffs)

target_comp = np.loadtxt(target_comp_file,skiprows=1,delimiter=",")

UCC_clr = np.array([2.333699,	0.8690621, -0.1423602,	-0.9570468, -0.6805154, -0.5871532,	-0.835686])
# p vector from Lipp et al. 2020; w vector is average of Toorongo and White 2001 vectors;
p = np.array([0.23373465,  0.09797867, -0.23159232, -0.60061708, 0.24779572, -0.33628409,  0.58898446])
w = np.array([0.2418534,  0.3691629,  0.2349810,  0.1338786, -0.4874057, -0.6782411,  0.1857709]) 

target_comp = close(target_comp)  # Normalise to 1

coeffs = find_coefficients_gradient(target_comp) # Calculate coefficients (takes time)
fit = np.copy(target_comp) 
for i in range(coeffs.shape[0]): # Calculate fitted values
    fit[i,:] = exchange_naca_prop(coefficients_to_comp(coeffs[i,0],coeffs[i,1]),coeffs[i,2])

# Write output to file    
np.savetxt(coeffs_out_filename,coeffs,delimiter=",")
np.savetxt(fit_out_filename,fit,delimiter=",")
