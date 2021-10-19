function [wbl_shape,wbl_scale] = WIND_calc_WeibullParams(wndspd)
% PURPOSE
% calculates Weibull distribution parameters - shape and scale
% 
% INPUT
% wndspd - wind speed (m/s) - wndspd(no_gridpnts,no_times)
%
% OUTPUT
% wbl_shape - Shape parameter for Weibull distribution [-] wbl_shape(no_gridpnts,1)
% wbl_scale - Scale parameter for Weibull distribution [-] wbl_scale(no_gridpnts,1)
%
% AUTHOR: Ida Marie Solbrekke, modified by Asgeir Sorteberg
%         Bergen offshore wind centre, Geophysical institute, University in Bergen
%         email: ida.solbrekke@uib.no
%         Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('WIND_calc_WeibullParams: Calculating Weibull distribution parameters')
wndspd = double(wndspd);
% init
wbl_params = ones(2,size(wndspd,1))*NaN;

%  loop over all points
for ii = 1:size(wndspd,1)
    wbl_params(:,ii) = wblfit(wndspd(ii,wndspd(ii,:)~=0));
end

% save shape and scale
wbl_shape=wbl_params(1,:); 
wbl_scale=wbl_params(2,:);

disp('WIND_calc_WeibullParams: Finished')
