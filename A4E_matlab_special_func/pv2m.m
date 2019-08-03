function Pm = pv2m(pm, par)
%--------------------------------------
% Author: Alexander Efremov            
% Date:   26 April 2009                
% Course: Multivariable Control Systems
%--------------------------------------
% PV2M converts the parameter vector pm into a matrix form.
%   Pm = pm2v(pm, na, nb) Converts pm into a matrix containing 
%   the estimates of the model parameters (zero is introduced if [Pm]ij 
%   is not estimated).
%
% Inputs: 
%   pm - model parameter vector 
%   na - [el x el] matrix containing the degrees of the polynomials in A(q^-1) 
%   nb - [el x m] matrix containing the degrees of the polynomials in B(q^-1)
%   nc - [el x m] matrix containing the degrees of the polynomials in C(q^-1)
%
% Outputs: 
%   Pm - parameter matrix
%
% See also PV2M.

if isfield(par, 'intercept') && par.intercept, intercept = 1; else intercept = 0; end

na = par.na;
nb = par.nb;
[r, m] = size(nb);
if isfield(par, 'nc'), nc = par.nc; else nc = zeros(r, r); end
nna = max(max(na));  nnb = max(max(nb));  nnc = max(max(nc));
z = r*nna + m*nnb + r*nnc;

if z == 0, Pm = []; return, end

if intercept
   ind = 1 + [0:r - 1]*length(pm)/r;
   pm0 = pm(ind);
   pm(ind) = [];
else
   pm0 = []; 
end
Pm = zeros(r, z);
ii = 0;
for i = 1:r
   if nna
      for j = 1:r
         Pm(i, (0:r:na(i, j)*r - 1) + j) = pm([1:na(i, j)] + ii);
         ii = ii + na(i, j);
      end
   end
   if nnb
      for j = 1:m
         Pm(i, (0:m:nb(i, j)*m - 1) + j + r*nna) = pm([1:nb(i, j)] + ii);
         ii = ii + nb(i, j);
      end
   end
   if nnc
      for j = 1:r
         Pm(i, (0:r:nc(i, j)*r - 1) + j + r*nna + m*nnb) = pm([1:nc(i, j)] + ii);
         ii = ii + nc(i, j);
      end
   end
end
Pm = [pm0'; Pm'];

