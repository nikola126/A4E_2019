function pm = pm2v(Pm, par)
% PM2V converts the parameter matrix Par into a vector form.
%   par = pm2v(Par, na, nb) Converts Par into a vector containing the estimates 
%   of the model parameters (the introduced zeros in the parameter matrix Par 
%   from pv2m are omitted).
%
% Inputs: 
%   Pm - model parameter matrix
%   par.na - [el x el] matrix containing the degrees of the polynomials in A(q^-1) 
%   par.nb - [el x m] matrix containing the degrees of the polynomials in B(q^-1)
%
% Outputs: 
%   par - parameter vector
%
%--------------------------------------
% Author: Alexander Efremov            
% Date:   26 Apr 2009                  
% Course: Multivariable Control Systems
%--------------------------------------
%
% See also PV2M.

if isfield(par, 'intercept') && par.intercept, intercept = 1; else intercept = 0; end
na = par.na;
nb = par.nb;
[r, m] = size(nb);
if isfield(par, 'nc'), nc = par.nc; else nc = zeros(r, r); end
z = sum(sum([na nb nc]));
if z == 0, pm = []; return, end
nna = max(max(na));  nnb = max(max(nb));  nnc = max(max(nc));

% todo: with intercept
% pm = zeros(z, 1);
% if intercept
%    ind = 1 + [0:r - 1]*z/r;
%    pm(ind) = Pm(1, :);
%    Pm(1, :) = [];
% else
%    pm0 = []; 
% end
% Pm = zeros(r, z);
% ii = 0;

pm = [];
for i = 1:r      % aijp
    pari = Pm(:, i);
    if any(any(na))
       for j = 1:r
           pij = [pari(j:r:r*(na(i, j) - 1) + j)];
           pm = [pm; pij];
       end
    end
    if any(any(nb))
       for j = 1:m   % bijp
           pij = [pari((j:m:m*(nb(i, j) - 1) + j) + r*nna)];
           pm = [pm; pij];
       end
    end
    if any(any(nc))
       for j = 1:r   % bijp
           pij = [pari((j:r:r*(nc(i, j) - 1) + j) + r*nna + m*nnb)];
           pm = [pm; pij];
       end
    end
end
