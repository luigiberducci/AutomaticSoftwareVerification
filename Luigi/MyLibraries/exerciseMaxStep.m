clear;

A = [100,   1;
       0, 100];
  
algo = "BDF5";

h_upper = 30;
h_lower = 0;

h_max = met.getMaxStep(A, h_upper, h_lower, algo);

display(h_max);