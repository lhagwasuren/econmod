%% Preliminary

% add IRIS to the path
cd /home/sugarkhuu/Documents/Documents/my/modelling/third
addpath /home/sugarkhuu/Documents/IRIS-Toolbox-Release-20180319

% configure IRIS
irisstartup
irisversion

%%
% what KF does. One dim, two dim simple cases. Measurement and state. Then theory. Actully smoothing!!! Kalman gain can come from just normal distribution.
% 1. obs_x = x + ex; x = Ax{-1} + e; choice between e_{t} and e_{t+1};
% choice between ex and x. observation and state. Minimizing ML. After
% predicting, there will be smoothing recursion.

obs_x = x + ex; % observation is obs_x
x = Ax{-1} + e; % state is x

% Sum_(ex-m_ex)/sigma_ex + Sum_(e-m_e)/sigma_e + log(1/2*pi*sig) -> Minimum Likelihood

% 2. obs_x = x; x = Ax{-1}+ Cy + ex; y = By{-1} + ey; choice between ex and ey


%% Forecast
% show examples baseline, different std, different transition parameter values.
% mention that why it can do maximum likelihood estimation. 
disp('Forecast starts ...');
p   = struct();
p.a_x  = 0.7;
p.a_y  = 0.7;
p.a_xy = 0.2;

m = model('third.mod','linear',true,'assign',p);
m = solve(m);
m = sstate(m);

d=struct();
d.obs_x = tseries();
d.obs_x(qq(2018,1):qq(2019,4)) = [1.5 1.2 0.5 0.8 1.5 2.1 0.2 1.2];

[~, f, v, ~, pe, co] = filter(m, d, qq(2018,1):qq(2019,4)+10);
a=f.mean;

figure;myPlot('range',qq(2018,1):qq(2022,2),'line',a.x,'bar',[a.a_x*a.x{-1} a.a_xy*a.y a.ex]);
figure;myPlot('range',qq(2018,1):qq(2022,2),'line',a.y,'bar',[a.a_y*a.y{-1} a.ey]);
                 

%% different std

p.std_ey = 10;

m = model('third.mod','linear',true,'assign',p);
m = solve(m);
m = sstate(m);

d=struct();
d.obs_x = tseries();
d.obs_x(qq(2018,1):qq(2019,4)) = [1.5 1.2 0.5 0.8 1.5 2.1 0.2 1.2];

[~, f, v, ~, pe, co] = filter(m, d, qq(2018,1):qq(2019,4)+10);
a=f.mean;

figure;myPlot('range',qq(2018,1):qq(2022,2),'line',a.x,'bar',[a.a_x*a.x{-1} a.a_xy*a.y a.ex]);
figure;myPlot('range',qq(2018,1):qq(2022,2),'line',a.y,'bar',[a.a_y*a.y{-1} a.ey]);

%% different transition parameter



%% 4. KF implementation in IRIS. show with keyboard some matrices and give hint on how to debug and understand IRIS implementation and every m file. Mention Hamilton and Durin&Koopman. 
% keyboard - kalmanFilter, onestepbackmean
% Kalman gain can be derived from just normal distribution and correlations
% Hamilton, Durbin&Koopman
