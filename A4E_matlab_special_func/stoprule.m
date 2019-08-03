function [iterate, msg] = stoprule(opt)
%--------------------------------------------
% Author: Alexander Efremov                  
% Date:   07 Dec 2012                        
% Course: Multivariable System Identification
%--------------------------------------------

maxIter = opt.maxIter;
tauf = opt.tauf;
taux = opt.taux;
F = opt.f;
F_1 = opt.f_1;
x = opt.x;
x_1 = opt.x_1;
iter = opt.iter;
absXCONV = max(max(abs((x - x_1)./x_1)));
absFCONV = abs(F_1 - F);
if iter >= maxIter,     iterate = 0;  msg = ['Maximum iterations (' num2str(iter) ') has been reached...']; return,  end
if absXCONV < taux,     iterate = 0;  msg = ['absXCONV (' num2str(absXCONV) ') is satisfied...']; return,  end
if absFCONV < tauf, iterate = 0;  msg = ['absFCONV (' num2str(absFCONV) ') is satisfied...']; return,  end
iterate = 1;  msg = [];
