function [mod, E] = elspm(U, Y, par)
% ELSPM calculates Extended Least Squares (ELS) estimates of ARX model in parameter matrix form.
% In case of static model factors are in matrix is U.
% Pm = elspm(Y, U, na, nb) determines the LS-estimates of ARX model
%    A(q^-1)*yk = B(q^-1)*uk + C(q^-1)*ek
% represented in a parameter matrix form
%    yk = Pm'*fk + ek,
% where:
%    A(q^-1) is [el x el] polynomial matrix
%       A(q^-1) = I + A1*q^-1 + ...  + Ana*q^-na 
%    B(q^-1) is [el x m] polynomial matrix
%       B(q^-1) = 0 + B1*q^-1 + ...  + Bnb*q^-nb
%    C(q^-1) is [el x el] polynomial matrix
%       C(q^-1) = I + C1*q^-1 + ...  + Cnc*q^-nc 
%    na, nb and nc are maximum degrees of the polynomials in A(q^-1), 
%       B(q^-1) and C(q^-1) respectively
%    k - current time instant.
%    uk - input vector in the k-th time instant /with m elements/
%    yk - output vector in the k-th time instant /with el elements/
%    ek - residual vector in the k-th time instant  /with el elements/
%    fk - regression vector with [el*na + m*nb] elements in the k-th
%    Pm - parameter matrix
%    opt - structure:
%        opt...
% 
% Inputs: 
%       where N is the length of the observation interval
%   U - [N x m] input data matrix with structure
%       U = [u(1) u(2) ... u(N)]'
%   Y - [N x el] output data matrix with structure
%       Y = [y(1) y(2) ... y(N)]',
%   par - structure with fields:
%     na - polynomials degree in A(q^-1)
%     nb - polynomials degree in B(q^-1)
%     nc - polynomials degree in C(q^-1)
%     intercept - 1 if model has intercept, otherwise 0. Default is 0.
%
% Outputs: 
%    Pm - [el*(na + nc) + m*nb x el] matrix, containing the estimates of the model parameters
%         Pm = [A1 A2 ... Ana B1 B2 ... Bnb C1 C2 ... Cnc]'
%
% See also ELSPV
% 
%--------------------------------------
% Author: Alexander Efremov            
% Date:   26 Apr 2009                  
% Course: Multivariable Control Systems
%--------------------------------------

na = par.na;
nb = par.nb;
nc = par.nc;

[N, r] = size(Y);
n = max([na nb nc]);
nn = n - max(na, nb) + 1;
% Initialization
if ~isfield(par, 'opt') || ~isfield(par.opt, 'maxIter'), par.opt.maxIter = 50;  end
if ~isfield(par, 'opt') || ~isfield(par.opt, 'tauf'),    par.opt.tauf = 1e-8;   end
if ~isfield(par, 'opt') || ~isfield(par.opt, 'taux'),    par.opt.tauPm = 1e-8;  end
if ~isfield(par, 'opt') || ~isfield(par.opt, 'dsp'),     dsp = 0;               else dsp = par.opt.dsp; end

pab.na = na;
pab.nb = nb;
pab.intercept = par.intercept;
modab = lspm(U, Y, pab);
Pmab = modab.Pm;
Fab = dmpm(U(nn:end, :), Y(nn:end, :), pab);
E = [zeros(n, r); Y(n + 1:end, :) - Fab*Pmab];
f = sum(diag(E'*E)/N);
% iterate
Pm = [Pmab; zeros(r*nc, r)];
iter = 0; iterate = 1;
while iterate
   iter = iter + 1;
   pc.nc = nc;
   pc.intercept = 0;
   F = [Fab dmpm([], [], E, pc)];
   Pm_1 = Pm;
   Pm = (F'*F)^-1*F'*Y(n + 1:N, :);
   E = [zeros(n, r); Y(n + 1:end, :) - F*Pm];
   f_1 = f; 
   f = sum(diag(E'*E)/N);
   if f > f_1, Pm1 = Pm_1; Pm = (Pm + Pm_1)./2; if dsp, disp(['iter: ' num2str(iter) ' Wrong step. Select half step and continue...']), end, end
   par.opt.f = f;
   par.opt.f_1 = f_1;
   par.opt.x = Pm;
   par.opt.x_1 = Pm_1;
   par.opt.iter = iter;
   [iterate, msg] = stoprule(par.opt);
end
mod.par = par;
mod.Pm = Pm;
if f > f_1, mod.Pm = Pm1; else mod.Pm = Pm; end

disp(msg)
