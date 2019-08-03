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

par.intercept = 0;   par.na = 2;   par.nb = 2;   par.nc = 2;
par1.intercept = 0;  par1.na = 2;  par1.nb = 2;

% LS for ARX
mdl0 = lspm(U, Y, par1);
Ym0 = lspm_apl(U, Y, mdl0);
Pm0 = [mdl0.Pm; zeros(r*par.nc, r)];
% ELS
par.opt.maxIter = 50;
par.opt.taux = 1e-6;
par.opt.tauf = 1e-6;
par.opt.dsp = 0;

[mdl, E] = elspm(U, Y, par);
Ym = elspm_apl(U, Y, E, mdl);
Pm = mdl.Pm;


% Variance Accounted For
n = max([par.na par.nb par.nc]);
% VAF_LS  = vaf(Y(n+1:end, :), Ym0, par.na*r + par.nb*m);
% VAF_ELS = vaf(Y(n+1:end, :), Ym, par.na*r + par.nb*m + par.nc*r);
VAF_LS  = vaf(Y(n+1:end, :), Ym0);
VAF_ELS = vaf(Y(n+1:end, :), Ym);

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
