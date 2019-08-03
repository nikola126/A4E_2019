function Ym = lspv_apl(U, Y, mod)

par = mod.par;
pm = mod.pm;

Pm = pv2m(pm, par);  % lspv.pred(U, Y, par)
F = dmpm(U, Y, par);
Ym = F*Pm;
