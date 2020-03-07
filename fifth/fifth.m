%% Preliminary

% add IRIS to the path
cd /home/sugarkhuu/Documents/Documents/my/modelling/econmod/fourth
addpath /home/sugarkhuu/Documents/IRIS-Toolbox-Release-20180319

% configure IRIS
irisstartup

disp('Forecast starts ...');
p   = struct();
fourth_param;


m = model('fourth.mod','linear',true,'assign',p);
m = solve(m);


d=struct();
d.obs_y = tseries();
d.obs_y(qq(2018,1):qq(2019,4)) = ...
[100.546316773439
105.781594142913
92.1793414415762
101.232565810543
105.596889704456
106.254394062807
109.114767757587
111.560505992009];

[~, f, v, ~, pe, co] = filter(m, d, qq(2018,1):qq(2019,4)+40);
a=f.mean;

