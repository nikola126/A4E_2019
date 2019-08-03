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
par.na = repmat(2, r, r);   par.nb = repmat(2, r, m);
% rng(0); par.na = round(rand(r, r)*2);
% rng(1); par.nb = round(rand(r, m)*2);

n = max(max([par.na par.nb]));

% LS
mdl = lspv(U, Y, par);
Ym1 = lspv_apl(U, Y, mdl);

% RobLS
par.opt.dvaf = 1e-6;
par.opt.maxIter = 1e2;
par.opt.hst = 1;
mdl = roblspv(U, Y, par);
Ym = lspv_apl(U, Y, mdl);

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
