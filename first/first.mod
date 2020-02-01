!variables:transition
x

!parameters
a

!shocks:transition
e

!equations:transition
x = a*x{-1} + e;

!variables:measurement
obs_x

!equations:measurement
obs_x = x;