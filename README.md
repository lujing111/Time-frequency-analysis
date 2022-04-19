# Time-frequency analysis
resting-state EEG
For each participant, time-frequency decomposition was performed on the first 60 seconds of artifact-free EEG data using Fast Fourier Transformation with a 2s Hanning window for 0.5-40Hz. 
Relative power was calculated based on the alpha peak freqeuncy 
The frequency bands were anchored to individual alpha peak frequency (IFAs) .
IFA = max(eyes_close-eyes_open)
The frequency bands were defined as 1-0.4*IAF, 0.4*IAF-0.8*IAF, 0.8*IAF-1.2*IAF, 1.2*IAF-3*IAF, and 3*IAF-40Hz for delta, theta, alpha, beta, and gamma.
