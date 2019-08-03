function Ym = lspm_apl(U, Y, mod)

par = mod.par;
Pm = mod.Pm;

F = dmpm(U, Y, par);
Ym = F*Pm;
