function Y = repmatc(X, m)
%--------------------------
% Author: Alexander Efremov
% Date:   10.02.2012       
%--------------------------
% Columnwise reproduction (m times) of X matrix, i.e. Y = [X X ... X] 

n = size(X, 2)
Y = X(:, rem(0:(n*m - 1), n) + 1);
