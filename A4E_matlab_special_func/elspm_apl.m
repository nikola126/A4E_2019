function Ym = elspm_apl(U, Y, E, mod)

par = mod.par;
Pm = mod.Pm;

F = dmpm(U, Y, E, par);
Ym = F*Pm;
