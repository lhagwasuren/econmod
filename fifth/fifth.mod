!variables:transition
'Output (log)'                     l_y
'Potential output (log)'           l_y_tnd
l_y_gap
e_l_y_gap
dl_y_tnd
y

!shocks:transition
shock_l_y_gap, shock_dl_y_tnd


!variables:log
y
obs_y


!parameters
c1_l_y_gap
c2_l_y_gap
c1_dl_y_tnd
ss_dl_y_tnd



!equations:transition
l_y_gap =  c1_l_y_gap*l_y_gap{-1}
         + c2_l_y_gap*e_l_y_gap
%        - rmci{-1}
%        + l_y_foreign_gap
         + shock_l_y_gap;

l_y = l_y_tnd + l_y_gap;
l_y = 100*log(y);
e_l_y_gap = l_y_gap{+1};

dl_y_tnd = 4*(l_y_tnd - l_y_tnd{-1}); % QoQ @ar
dl_y_tnd = c1_dl_y_tnd*dl_y_tnd{-1} + (1-c1_dl_y_tnd)*ss_dl_y_tnd + shock_dl_y_tnd;


!variables:measurement
obs_y

!equations:measurement
obs_y = y;


'I. IS curve'
'II. Phillips curve'
'III. Taylor rule or Monetary policy'
'IV. UIP condition'