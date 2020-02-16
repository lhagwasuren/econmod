!variables:transition
x, y

!parameters
a_x, a_y
a_xy

!shocks:transition
ex, ey

!equations:transition
x = a_x*x{-1} + a_xy*y + ex;
y = a_y*y{-1} + ey;

!variables:measurement
obs_x

!equations:measurement
obs_x = x;