clear variables
path(path,'.\SpecialFunctions_IMS')
load('data\retail\data.mat')

[N, r] = size(Y);
m = size(U, 2);
par.intercept = 0;
par.mtype = 'sparse';
W = ones(N, 1);

% Model 1
par.na = repmat(2, r, r);   par.nb = zeros(r, m);
mod1 = wlspv(U, Y, W, par);
Ym1 = lspv_apl(U, Y, mod1);

% Model 2
par.na = repmat(2, r, r);   par.nb = repmat(2, r, m);
mod2 = wlspv(U, Y, W, par);
Ym2 = lspv_apl(U, Y, mod2);

% Model 3
par.na = repmat(2, r, r);   par.nb = repmat(2, r, m);
U = [U(2:end, :);  U(end , :)];
mod3 = lspv(U, Y, par);  % lspv.fit(U, Y, par)
Ym3 = lspv_apl(U, Y, mod3);


% Model 4
Ym4 = max(0, Ym3);

nn = max([par.na(:); par.nb(:)]);
vaf_model_1 = vaf(Y(nn + 1:end, :), Ym1);
vaf_model_2 = vaf(Y(nn + 1:end, :), Ym2);
vaf_model_3 = vaf(Y(nn + 1:end, :), Ym3);
vaf_model_4 = vaf(Y(nn + 1:end, :), Ym4);
Table = table(vaf_model_1, vaf_model_2, vaf_model_3, vaf_model_4)

return

for ii = 1:size(Y, 2)
   figure, hold on, plot([Y(nn + 1:end, ii), Ym3(:, ii)]), plot(Ym1(:, ii), ':')
%    plot(Ya(:, ii), ':'), 
   grid, zoom
end
