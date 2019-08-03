%--------------------------------------------
% Author: Alexander Efremov                  
% Date:   26 Sep 2012                        
% Course: Multivariable System Identification
%--------------------------------------------

clear variables
path(path, '.\SpecialFunctions_IMS')
load('data\retail\data.mat')

[N, r] = size(Y);
m = size(U, 2);
par.intercept = 0;

% Model 1
par.na = repmat(2, r, r);   par.nb = zeros(r, m);
mdl1 = lspv(U, Y, par);
Ym1 = lspv_apl(U, Y, mdl1);

% Model 2
par.na = repmat(2, r, r);   par.nb = repmat(2, r, m);
mdl2 = lspv(U, Y, par);
Ym2 = lspv_apl(U, Y, mdl2);

% Model 3
par.na = repmat(2, r, r);   par.nb = repmat(2, r, m);
% rng(0); par.na = round(rand(r, r)*2);
% rng(1); par.nb = round(rand(r, m)*2);

U = [U(2:end, :);  U(end , :)];
mdl3 = lspv(U, Y, par);
Ym3 = lspv_apl(U, Y, mdl3);

% Model 4
Ym4 = max(0, Ym3);

n = max([par.na(:); par.nb(:)]);
vaf_model_1 = vaf(Y(n + 1:end, :), Ym1);
vaf_model_2 = vaf(Y(n + 1:end, :), Ym2);
vaf_model_3 = vaf(Y(n + 1:end, :), Ym3);
vaf_model_4 = vaf(Y(n + 1:end, :), Ym4);
Table = table(vaf_model_1, vaf_model_2, vaf_model_3, vaf_model_4)

return

for ii = 1:size(Y, 2)
   figure, hold on, plot([Y(n + 1:end, ii), Ym3(:, ii)]), plot(Ym1(:, ii), ':')
%    plot(Ya(:, ii), ':'), 
   grid, zoom
end
