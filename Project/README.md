# AutomaticSoftwareVerification
Working directory for exercises and project of Automatic Software Verification course.

# DummyDTS
This model is a very simple discrete time system, defined as

x(k+1) = x(k) + u(k)

y(k+1) = x(k)

Then basically, its dynamics is constant when u(k)=0 and grows +u(k) otherwise.

You can notice that, considering a binary (0/1) input vector, the output could grows up to one for each time step,
then the maximum value is bounded by the time horizon Tf.
We can formalize a LTL specification as _G[x<Tf]_ and only the input vector _[1,1,1...,1]_ could break it.

Then the probability to find such input vector by Uniform Random Sampling is _1/2^Tf_ (rather unlikely)
and the Robustness Satisfation of a state is also extremely simple to compute.

Some Maths below:

1) Phi = G[x<Tf] = not(F[not(x<Tf)]) = not(T U not(x<Tf)) = not(T U not(x-Tf<0)) = not(T U (x-Tf>=0))
2) Rho(not(Phi)) = -Rho(Phi) = -(upper( min( lower(Rho(T)), lower(Rho(x-Tf>=0))))) = -(upper( min( Infinity, lower(Rho(x-Tf>=0))))) = -(upper( min(Infinity, x-Tf))) = -(x-Tf) = Tf-x
3) For instance, in a state x(k) = 5 and Tf=10 then Rho(Phi) is evaluated Tf-x(k)=10-5=5. Then it is also extremely easy to compute.

We could try to see if this "distance" can drive us to falsification faster than Uniform Random Sampling.
