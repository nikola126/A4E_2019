function Ym = elspv_apl(U, Y, E, mod)

par = mod.par;
pm = mod.pm;

Pm = pv2m(pm, par);
F = dmpm(U, Y, E, par);
Ym = F*Pm;
