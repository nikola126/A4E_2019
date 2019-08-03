function mdl = roblspm(U, Y, par)
%--------------------------
% Author: Alexander Efremov
% Date:   16.02.2010       
%--------------------------

if isfield(par, 'opt') && isfield(par.opt, 'dvaf'),     dvaf = par.opt.dvaf;       else dvaf = 1e-2; end
if isfield(par, 'opt') && isfield(par.opt, 'maxIter'),  maxIter = par.opt.maxIter; else maxIter = 1e2; end
if isfield(par, 'opt') && isfield(par.opt, 'hst'),      hst = par.opt.hst;         else hst = 0; end
na = par.na;
nb = par.nb;
n = max(na, nb);
r = size(Y, 2);
m = size(U, 2);
% Data matrix
F = dmpm(U, Y, par);
Y = Y(n + 1:end, :);
Pm = (F'*F)^-1*F'*Y;
Ym = F*Pm;
vafw = vaf(Y, Ym);
vaf0 = vafw;

if hst, VAFw = vafw; VAF = vaf0; PM = pm2v(Pm, par); YM = vec(Ym'); end

iter = 0;
iterate = 1;
while iterate
	iter = iter + 1;
   ww = min(1, max(1e-8, abs(Y - Ym).^-1));
   for i = 1:r
      Wi = repmat(ww(:, i), 1, r*na + m*nb);
      Pm(:, i) = (F'*(Wi.*F))^-1*F'*(ww(:, i).*Y(:, i));
   end
   Ym = F*Pm;
   vafw_1 = vafw;
   vafw = vaf(Y, Ym, ww);
   vaf0 = vaf(Y, Ym);
   if hst, PM = [PM pm2v(Pm, par)]; VAFw = [VAFw vafw]; VAF = [VAF vaf0]; YM = [YM vec(Ym')]; end
	if any(abs(vafw - vafw_1)) <= dvaf || iter >= maxIter, iterate = 0; end
end
if hst, st.PM = PM; st.vafw = VAFw; st.vaf0 = VAF; st.YM = YM; else, st = []; end
mdl.par = par;
mdl.st = st;
mdl.Pm = Pm;