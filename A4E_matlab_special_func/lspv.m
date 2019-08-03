function [mod, F] = lspv(U, Y, par)
% LSPV calculates Least Squares (LS) estimates of ARX model in parameter vector form.
% In case of static model factors are in matrix U and Y = [].
% [pm, F] = lspv(U, Y, par) determines the LS-estimates of ARX model
%    A(q^-1)*yk = B(q^-1)*uk + ek
% represented in a parameter vector form is
%    yk = Fk*pm + ek,
% where:
%    A(q^-1) is [el x el] polynomial matrix with elements
%       aij(q^-1) = aij0 + aij,1*q^-1 + ...  + aij,naij*q^-naij 
%    B(q^-1) is [el x m] polynomial matrix
%       bij(q^-1) = 0 + bij,1*q^-1 + ...  + bij,nbij*q^-nbij 
%    na and nb are matrices of pollynomials' degrees with elements
%    naij - degree of polynomial aij(q^-1) and nbij - degree of bij(q^-1)
%    k - current time instant
%    uk - input vector in k-th time instant
%    yk - output vector in k-th time instant
%    ek - residual vector in k-th time instant 
%    Fk - [el x p] regression matrix in the k-th time instant with
%       p = sum(sum(na)) + sum(sum(nb))
%    pm is vector of model parameters
% 
% Inputs: 
%   U - [N x m] input data matrix with structure
%       U = [u1 u2 ... uN]'
%       where N is the length of the observation interval
%   Y - [N-n x el] output data matrix with structure
%       Y = [y1 y2 ... yN]',
%   par - structure with fields:
%     na - [el x el] matrix containing the degrees of the polynomials in
%       A(q^-1) /na(i, j) is the degree of aij(q^-1)/
%     nb - [el x m] matrix containing the degrees of the polynomials in
%       B(q^-1) /nb(i, j) is the degree of bij(q^-1)/
%
% Outputs: 
%    pm - [p x 1] vector, containing estimates of model parameters
%
% See also LSPM
% 
%--------------------------------------
% Author: Alexander Efremov            
% Date:   26 Apr 2009                  
% Course: Multivariable Control Systems
%--------------------------------------

mod.par = par;
if nargin == 2,  mod.pm = (U'*U)^-1*U'*Y;  return,  end % todo: static system in pv form
if ~isfield(par, 'mtype'), par.mtype = 'sparse'; end
if ~isfield(par, 'intercept'), par.intercept = 0; end

na = par.na;
nb = par.nb;

n = max(max([na nb]));

% Data matrix
F = dmpv(U, Y, par);

% LS
if n == 0,  mod.pm = [];  return,  end
pm = full(F'*F)^-1*F'*vec(Y(n + 1:end, :)');
mod.pm = full(pm);
