%--------------------------------------------
% Author: Alexander Efremov                  
% Date:   26 Sep 2012                        
% Course: Multivariable System Identification
%--------------------------------------------

clear variables
path(path,'.\SpecialFunctions_IMS')
load('data\retail\data.mat')

Y0 = Y(:, 1:2);
Y = Y0;
a = 10;
Y(1:a) = Y(1:a)*50;
m = size(U, 2);
r = size(Y, 2);
par.intercept = 0;
par.mtype = 'full';
par.na = 2;   par.nb = 2;
n = max(par.na, par.nb);

% LS
mdl = lspm(U, Y, par);
Ym1 = lspm_apl(U, Y, mdl);

% RobLS
par.opt.dvaf = 1e-6;
par.opt.maxIter = 1e2;
par.opt.hst = 1;
mdl = roblspm(U, Y, par);
Ym = lspm_apl(U, Y, mdl);

disp('VAFw: ')
disp( num2str(mdl.st.vafw))
disp('VAF: ')
disp( num2str(mdl.st.vaf0))

vaf_model_1 = vaf(Y0(a + n + 1:end, :), Ym1(a + 1:end, :));
vaf_model_2 = vaf(Y0(a + n + 1:end, :), Ym(a + 1:end, :));

Table = table(vaf_model_1, vaf_model_2)
figure, hold on, plot(Y(a + n + 1:end, :))
h = size(mdl.st.PM, 2);
for i = 1:h - 1, Ymi = dv2dm(mdl.st.YM(:, i), r); plot(Ymi(a + 1:end, :), 'g'), end
plot(Ym(a + 1:end, :), 'k'), plot(Ym1(a + 1:end, :), 'r'), grid, zoom
