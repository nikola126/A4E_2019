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
% dannite v purvata kolona pokazvat kolko to4en e modela (100 e nai-dobre,
% povtarq vxoda) 
% na - broi predi6ni stoinosti na izx veli4ini
% nb - vxodni
% 5 vxoda za mnogo dni nazad
% AR
par.na = 2;   par.nb = 0;
mdl1 = lspm(U, Y, par);
Ym1 = lspm_apl(U, Y, mdl1);

% Model 2
% dobavqt se vxodni veli4ini
% po-malki greshki
% ARX
par.na = 2;   par.nb = 2;
mdl2 = lspm(U, Y, par);
Ym2 = lspm_apl(U, Y, mdl2);

% Model 3
% izmestvane na vxodni danni
% s edin takt nazad, u4astvat i vx veli4ini ot predi6niq takt

% ARX + biznes logika
par.na = 2;   par.nb = 2;
U = [U(2:end, :);  U(end , :)];
mdl3 = lspm(U, Y, par);
Ym3 = lspm_apl(U, Y, mdl3);

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
