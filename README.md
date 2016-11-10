# Denoise-Galaxy-Spectra

### **Code for Denoising of Spectroscopic Data**

# Table of contents
1. [Introduction](#introduction)
2. [Dependencies](#paragraph1)
3. [Execution](#paragraph2)

## Introduction <a name="introduction"></a>
This repository contains MATLAB codes and scripts designed for the denoising of spectroscopic data.

## Dependencies <a name="paragraph1"></a>
In order to run the code, both the data and the dictionaries must be downloaded: 

* This link provides the sample data:
[link](https://www.dropbox.com/sh/bh7mhnstk393q7g/AADx6rPJt1hX_0lhMJB3AmoCa?dl=0)

* This link contains the coupled dictionaries, that are utilized for the sparse decomposition.
[link](https://www.dropbox.com/sh/fkvxjfor14k4hwu/AAB20Iz0LI84NBxCoK6V9cQca?dl=0)

**Both the data and the dictionaries should be placed in the same folder**

## Execution <a name="paragraph2"></a>

The primary function is **Sc-Denoising.m** which is designed to take a sequence of observed, degraded spectral profiles,
the coupled dictionaries, and a sparsity regularization parameter , and attemp to reconstruct the high-resolution spectral profiles.

The primary script that loads the data, the dictionaries and provides visual results of the reconstructed spectral profiles 
is **demo.m**

In the **demo.m**, we reconstruct the denoised spectral profiles from Medium SNR noise conditions. 
