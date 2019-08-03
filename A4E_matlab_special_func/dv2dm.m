function X = dv2dm(x, n)
Nn = length(x);
N = Nn/n;
ind = repmat([1:n:Nn]', 1, n) + repmat(0:n - 1, N, 1);
X = x(ind);
