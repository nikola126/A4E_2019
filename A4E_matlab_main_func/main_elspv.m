%--------------------------------------------
% Author: Alexander Efremov                  
% Date:   26 Sep 2012                        
% Course: Multivariable System Identification
%--------------------------------------------

clear variables
path(path, '.\SpecialFunctions_IMS')
load('data\retail\data.mat')

[N, r] = size(Y);
m = size(U, 2);
par.intercept = 0;  
par.na = repmat(2, r, r);
par.nb = repmat(2, r, m);
par.nc = repmat(2, r, r);

% rng(0); par.na = round(rand(r, r)*2);
% rng(1); par.nb = round(rand(r, m)*2);
% rng(2); par.nc = round(rand(r, r)*2);

par1 = par; 
par1 = rmfield(par1, 'nc');

% LS for ARX
mdl0 = lspv(U, Y, par1);
Ym0 = lspv_apl(U, Y, mdl0);
Pm0 = [mdl0.pm; zeros(sum(sum(par.nc)), 1)];
% ELS
par.opt.maxIter = 50;
par.opt.taux = 1e-6;
par.opt.tauf = 1e-6;
par.opt.dsp = 0;

[mdl, E] = elspv(U, Y, par);
Ym = elspv_apl(U, Y, E, mdl);
Pm = mdl.pm;

% Variance Accounted For
n1 = max(max([par.na par.nb]));
n2 = max(max([par.na par.nb par.nc]));
VAF_LS  = vaf(Y(n1 + 1:end, :), Ym0);
VAF_ELS = vaf(Y(n2 + 1:end, :), Ym);

% ---------- 5. Visualization ----------
LS_est = vec(Pm0');  
ELS_est = vec([Pm]');
err_abs = LS_est - ELS_est;
err_rel_prc = err_abs./ELS_est*100;
% Table1 = table(LS_est, ELS_est, err_abs, err_rel_prc);
% Table1
Table2 = table(VAF_LS, VAF_ELS);
Table2

return

for ii = 1:size(Y, 2)
   figure, hold on, plot([Y(n + 1:end, ii), Ym(:, ii)]), plot(Ym0(:, ii), ':'), grid, zoom
end
