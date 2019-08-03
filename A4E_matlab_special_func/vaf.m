function VAF = vaf(Y, Ym, w, p)
% Variance Accounted For
%--------------------------------------
% Author: Alexander Efremov            
% Date:   26 April 2009                
% Course: Multivariable Control Systems
%--------------------------------------

if nargin == 2,                                 % weights = 1; p = 0 (unknown model degrees of freedom)
   VAF = max(0, diag(eye(size(Y, 2)) - cov(Y - Ym)./cov(Y)))*100; 
   return, 
end
if nargin == 3 && size(w, 1) ~= size(Y, 1) && ~isscalar(Y)   % unknown weight, but known model degrees of freedom
   p = w;
   [N, r] = size(Y);
   mY = mean(Y);
   E = Y - Ym;
   Yc = Y - ones(N, 1)*mY;
   SSE = sum(E.*E)';
   SST = sum(Yc.*Yc)';
   VAF = max(zeros(r, 1), 100*(ones(r, 1) - (SSE./(N - p - 1))./(SST/(N - 1))));
   return
end
if nargin == 3 && all(size(Y) == size(w))       % unknown model degrees of freedom
   p = 0;
end

[N, r] = size(Y);
Nw = sum(w)';
if size(w, 2) < r, w = repmat(w, 1, r); end
mY = sum(Y.*w)'./Nw;
E = Y - Ym;
Yc = Y - repmat(mY', N, 1);
SSE = sum(E.*(E.*w))';
SST = sum(Yc.*(Yc.*w))';
VAF = max(zeros(r, 1), 100*(ones(r, 1) - (SSE./(Nw - p - 1))./(SST./(Nw - 1))));

