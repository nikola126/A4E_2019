function mdl = roblspv(U, Y, par)
%--------------------------
% Author: Alexander Efremov
% Date:   16.02.2010       
%--------------------------

if isfield(par, 'opt') && isfield(par.opt, 'dvaf'),     dvaf = par.opt.dvaf;       else dvaf = 1e-2; end
if isfield(par, 'opt') && isfield(par.opt, 'maxIter'),  maxIter = par.opt.maxIter; else maxIter = 1e2; end
if isfield(par, 'opt') && isfield(par.opt, 'hst'),      hst = par.opt.hst;         else hst = 0; end
na = par.na;
nb = par.nb;
n = max(max([na nb]));
r = size(Y, 2);

% Data matrix
F = dmpv(U, Y, par);
y = vec(Y(n + 1:end, :)');
pm = (F'*F)^-1*F'*y;
ym = F*pm;
vafw = vaf(dv2dm(y, r), dv2dm(ym, r));
vaf0 = vafw;

if hst, VAFw = vafw; VAF = vaf0; PM = pm; YM = ym; end

iter = 0;
iterate = 1;
while iterate
   iter = iter + 1;
   w = min(1, max(1e-8, abs(y - ym).^-1));
   ww = repmatc(w, size(F, 2));
   pm = (F'*(ww.*F))^-1*(ww.*F)'*y;
   ym = F*pm;
   vafw_1 = vafw;
   vafw = vaf(dv2dm(y, r), dv2dm(ym, r), dv2dm(w, r));
   vaf0 = vaf(dv2dm(y, r), dv2dm(ym, r));
   if hst, PM = [PM pm]; VAFw = [VAFw vafw]; VAF = [VAF vaf0]; YM = [YM ym]; end
   if any(abs(vafw - vafw_1)) <= dvaf || iter >= maxIter, iterate = 0; end
end
if hst, st.PM = PM; st.vafw = VAFw; st.vaf0 = VAF; st.YM = YM; else, st = []; end
mdl.par = par;
mdl.pm = pm;
mdl.st = st;
