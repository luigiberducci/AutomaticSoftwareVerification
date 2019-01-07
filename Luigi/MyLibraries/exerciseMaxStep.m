clear;

A = [20, 1;
      0, 20];
  
algo = "BDF6";

h_upper = 30;
h_lower = 0;

h_max = met.getMaxStep(A, h_upper, h_lower, algo);

display(h_max);