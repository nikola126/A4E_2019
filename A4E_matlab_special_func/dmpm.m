function F = dmpm(U, Y, E, par)
% DM2M constructs the data matrix for the model in a parameter matrix form.
% F = dmpm(U, Y, E, na, nb, nc)
% 
% Inputs:
%   U - [N x m] input data matrix with structure
%       U = [u(1) u(n + 2) ... u(N)]'
%       where N is the length of the observation interval and u(i) is m dimensional vectos
%   Y - [N x el] output data matrix with structure
%       Y = [y(1) y(2) ... y(N)]',
%   E - [N x el] residual data matrix with structure
%       E = [e(1) e(2) ... e(N)]',
%   par - structure with fields:
%     na - maximum degree of polynomials in A(q^-1)
%     nb - maximum degree of polynomials in B(q^-1)
%     nc - maximum degree of polynomials in C(q^-1)
%     intercept - 1 if model has intercept, otherwise 0. Default is 0.
%
% Outputs:
%   F - [N - n x z] data matrix /z = na*el + nb*m + nc*el/
%
% See also DMPV.
% 
%--------------------------------------
% Author: Alexander Efremov            
% Date:   26 Apr 2009                  
% Course: Multivariable Control Systems
%--------------------------------------

if nargin == 2, par = Y; clear Y; end
if nargin == 3, par = E; clear E; end

if exist('U', 'var') && ~isempty(U), N = size(U, 1); 
elseif exist('Y', 'var') && ~isempty(Y), N = size(Y, 1); 
elseif exist('E', 'var') && ~isempty(E), N = size(E, 1); 
else, error('At least one data matrix should be not empty...'), 
end

if isfield(par, 'intercept') && par.intercept, intercept = 1; else intercept = 0; end
if isfield(par, 'na'), na = par.na; else na = 0; end
if isfield(par, 'nb'), nb = par.nb; else nb = 0; end
if isfield(par, 'nc'), nc = par.nc; else nc = 0; end

if any(size(na) > 1), na = max(par.na(:)); end
if any(size(nb) > 1), nb = max(par.nb(:)); end
if any(size(nc) > 1), nc = max(par.nc(:)); end

n = max([na nb nc]);

if intercept, F = ones(N - n, 1); else F = []; end
for i = na:-1:1,  F = [F -Y(n - na + i:N - na + i - 1, :)];  end
for i = nb:-1:1,  F = [F  U(n - nb + i:N - nb + i - 1, :)];  end
for i = nc:-1:1,  F = [F  E(n - nc + i:N - nc + i - 1, :)];  end
