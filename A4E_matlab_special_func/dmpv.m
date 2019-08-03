function F = dmpv(U, Y, E, par)
% DM2M constructs the data matrix for the model in a parameter vector form.
% F = dmpv(U, Y, E, nna, nnb) constructs the data matrix containing the factors 
% used in the model representation in a parameter vector form.
% 
% Inputs: 
%   U - [N x m] input data matrix with structure
%       u = [u(1) u(2) ... u(N)]'
%       where N is the length of the observation interval
%   Y - [N x el] output data matrix with structure
%       y = [y(1) y(2) ... y(N)]',
%   E - [N x el] output data matrix with structure
%       e = [e(1) e(2) ... e(N)]',
%   par - structure with fields:
%     na - [el x el] matrix with elements naij - degree of polynomial aij(q^-1) in A(q^-1)
%     nb - [el x m] matrix with elements naij - degree of polynomial bij(q^-1) in B(q^-1)
%     intercept - 1 if model has intercept, otherwise 0. Default is 0.
%     mtype - data matrix type: 'sparse' or 'full'
% Output:
%   F - [(N - n)*el x p] data matrix, where p = sum(sum(nna)) + sum(sum(nnb))
%
%--------------------------------------
% Author: Alexander Efremov            
% Date:   26 Apr 2009                  
% Course: Multivariable Control Systems
%--------------------------------------
%
% See also DMPM.

if nargin == 2, par = Y; clear Y; end
if nargin == 3, par = E; clear E; end

flg = 0;
if exist('U', 'var') && ~isempty(U), [N, m] = size(U); flg = 1; else m = 0; end
if exist('Y', 'var') && ~isempty(Y), [N, r] = size(Y); flg = 1; else r = 0; end
if exist('E', 'var') && ~isempty(E), [N, r] = size(E); flg = 1; end
if ~flg, error('At least one data matrix should be not empty...'), end

if isfield(par, 'mtype'), mtype = par.mtype; else mtype = 'full'; end
if isfield(par, 'intercept') && par.intercept, intercept = 1; else intercept = 0; end
if isfield(par, 'na'), na = par.na; else na = zeros(r, r); end
if isfield(par, 'nb'), nb = par.nb; else nb = zeros(r, m); end
if isfield(par, 'nc'), nc = par.nc; else nc = zeros(r, r); end
n = max(max([na nb nc]));

if intercept, Y = [-ones(N, 1) Y]; na = [ones(r, 1) na]; end
if strcmp(mtype, 'full')
   F = [];
   for i = 1:r, 
       YY = [];
       for j = 1:r + intercept,
         if na(i, j) > 0
            Yi = Y(:, j);
            YY = [YY Yi([1:N - n]'*ones(1, na(i, j)) + ones(N - n, 1)*[0:-1:-(na(i, j) - 1)] + n - 1)]; 
         end
       end
       UU = []; 
       for j = 1:m, 
         if nb(i, j) > 0
            Ui = U(:, j);
            UU = [UU Ui([1:N - n]'*ones(1, nb(i, j)) + ones(N - n, 1)*[0:-1:-(nb(i, j) - 1)] + n - 1)]; 
         end
       end
      pi = sum(na(i, :)) + sum(nb(i, :));
      Fi = zeros((N-n)*r, pi);
      Fi(i:r:(N-n)*r, 1:pi) = [-YY UU];
      F = [F Fi];
   end
   for i = 1:r, 
       EE = [];
       for j = 1:r,
         if nc(i, j) > 0
            Ei = E(:, j);
            EE = [EE Ei([1:N - n]'*ones(1, nc(i, j)) + ones(N - n, 1)*[0:-1:-(nc(i, j) - 1)] + n - 1)]; 
         end
       end
      pi = sum(nc(i, :));
      Fi = zeros((N-n)*r, pi);
      Fi(i:r:(N-n)*r, 1:pi) = EE;
      F = [F Fi];
   end  
elseif strcmp(mtype, 'sparse')
   F = sparse([]);
   for i = 1:r, 
      YY = [];
      for j = 1:r + intercept,
         if na(i, j) > 0
            Yi = Y(:, j);
            YY = [YY Yi([1:N - n]'*ones(1, na(i, j)) + ones(N - n, 1)*[0:-1:-(na(i, j) - 1)] + n - 1)]; 
         end
      end
      UU = []; 
      for j = 1:m,
         if nb(i, j) > 0
            Ui = U(:, j);
            UU = [UU Ui([1:N - n]'*ones(1, nb(i, j)) + ones(N - n, 1)*[0:-1:-(nb(i, j) - 1)] + n - 1)]; 
         end
      end
      EE = [];
      for j = 1:r,
         if nc(i, j) > 0
            Ei = E(:, j);
            EE = [EE Ei([1:N - n]'*ones(1, nc(i, j)) + ones(N - n, 1)*[0:-1:-(nc(i, j) - 1)] + n - 1)]; 
         end
      end
      pi = sum(na(i, :)) + sum(nb(i, :)) + sum(nc(i, :));
      ii = vec(repmat([i:r:(N - n)*r]', 1, pi));
      jj = vec(repmat(1:pi, N-n, 1));
      YUE = vec([-YY UU EE]);
      Fi = sparse(ii, jj, YUE, (N - n)*r, pi);
      F = [F Fi];
   end
end
