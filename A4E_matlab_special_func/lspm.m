function mod = lspm(U, Y, par)
% LSPV calculates Least Squares (LS) estimates of ARX model in parameter matrix form.
% In case of static model factors are in matrix is U.
% mod = lspm_fit(U, Y, na, nb) determines the LS-estimates of ARX model
%    A(q^-1)*yk = B(q^-1)*uk + ek
% represented in a parameter matrix form
%    yk = Pm'*fk + ek,
% where:
%    A(q^-1) is [el x el] polynomial matrix
%       A(q^-1) = I + A1*q^-1 + ...  + Ana*q^-na 
%    B(q^-1) is [el x m] polynomial matrix
%       B(q^-1) = 0 + B1*q^-1 + ...  + Bnb*q^-nb
%    na and nb are the maximum degrees of the polynomials in A(q^-1) and B(q^-1)
%    respectively
%    k - current time instant.
%    uk - input vector in the k-th time instant /with m elements/
%    yk - output vector in the k-th time instant /with el elements/
%    ek - residual vector in the k-th time instant  /with el elements/
%    fk - regression vector with [el*na + m*nb] elements in the k-th
%    Pm - parameter matrix
% 
% Inputs: 
%   Y - [N x el] output data matrix with structure
%       Y = [y(1) y(2) ... y(N)]',
%       where N is the length of the observation interval
%   U - [N x m] input data matrix with structure
%       U = [u(1) u(2) ... u(N)]'
%   par - structure with fields:
%     na - polynomials degree in A(q^-1)
%     nb - polynomials degree in B(q^-1)
%     intercept - 1 if model has intercept, otherwise 0. Default is 0.
%
% Outputs: 
%    mod.Pm - [el*na + m*nb x el] matrix, containing the estimates of the model parameters
%         Pm = [A1 A2 ... Ana B1 B2 ... Bnb]'
%    mod.par
%
% See also LSPV
% 
%--------------------------------------
% Author: Alexander Efremov            
% Date:   26 Apr 2009                  
% Course: Multivariable Control Systems
%--------------------------------------

mod.par = par;
if nargin == 2, mod.Pm = (U'*U)^-1*U'*Y;  return,  end % static system without intercept
na = par.na;
nb = par.nb;
n = max(na, nb);
N = size(Y, 1);

% Data matrix
F = dmpm(U, Y, par);

% LS
if max(na, nb) == 0,  Pm = [];  return,  end
Pm = (F'*F)^-1*F'*Y(n + 1:N, :);

mod.Pm = Pm;
