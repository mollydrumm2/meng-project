# meng-project
Using Fourier Series and Spherical Harmonics to Smooth a Beating Heart Model in Time and Space

For this project I aided in smoothing ultrasound data from a PhD student's research. The motivation for this project is that heart defects in newborns develop in embryonic stages. If the development of the heart in these stages can be studied using CFD and muscle strains simulations, more can be learned about these defects. Stacked ultrasounds over the period which the heart beats are used to make a 3D model for simulations. This data creates a model with a lot of high frequency noise in the movement over time, and some artifacts of the discrete data in space. The data is smoothed over time using a Fourier transform, which approximates a function using superposition of sine and cos waves. Then, the high noise frequencies are removed from the function. I did this using Matlab Fast Fourier Transform (fft) and its inverse (ifft). The data is smoothed in space using a spherical harmonic transform at a relatively low value of of order l, which approximates the surface with less spherical basis functions to make a smoother file. This smoothed model can be used in simulations for more accurate results.

To see the results of the project see: https://www.youtube.com/watch?v=l4rvc1FyW7g

For the smoothing in space I used the uja_shfd code from the article Encoding Cortical Surface By Spherical Harmonics by Chung, M., Hartley, R., Dalton, K., and Davidson, R.

The file fourier.m in this repository is the time smoothing code that I wrote. It can be run on a set of csv files containing the coordinates at different time steps to smooth the data in time.

The input csv files must be set as:

1.csv (mesh nodes coordinates at time frame 1)
2.csv (mesh nodes coordinates at time frame 2)
51.csv (mesh nodes coordinates at time frame 51)

and fourier.m must run in the same folder these are all stored.

There are 2 user inputs in the code. p should be set to the number of time points in the data. 
  b should be set to the percent of modes you wish to take for smoothing over time. This can be used to tweak the amount of modes taken and how much the function is smoothed. 
  After running the code, the smoothed coordinates are output in the files 1_smoothed.csv, 2_smoothed.csv, and so on.
