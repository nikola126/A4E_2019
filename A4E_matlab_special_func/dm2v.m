function y = dm2v(Y)
% Data matrix to data vector
% Useful for output data matrix/vector conversion.
% 
% See also dv2m
% 
%--------------------------------------
% Author: Alexander Efremov            
% Date:   26 Apr 2009                
% Course: Multivariable Control Systems
%--------------------------------------

y = v ec(Y');
