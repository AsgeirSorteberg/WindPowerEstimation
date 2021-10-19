function [WIND_Shear_Data,WIND_Grad_Data] =  WIND_calc_wndshr_wndgrad(z1,z2,wndspd_z1,wndspd_z2)

% PURPOSE: Calculate the vertical wind shear and wind gradient between the different heights z1 and x2

% INPUT
% z2 - height level 2 [m] - scalar
% z1 - height level 1 [m] - scalar
% wndspd_z2 - Wndspeed in height z2 [m/s] - wndspd_hub(no_gridpnts,no_times)
% wndspd_z1 - Wndspeed in height z1 [m/s] - wndspd_hub(no_gridpnts,no_times)
%
% OUTPUT
% WIND_Shear_Data  - Vertical wind shear data [m/s] - WIND_Shear_Data(no_gridpnts,no_times)
% WIND_Grad_Data  - Vertical wind gradient data [1/s] - WIND_Shear_Data(no_gridpnts,no_times)
%
% AUTHOR: Ida Marie Solbrekke, modified by Asgeir Sorteberg
%         Bergen offshore wind centre, Geophysical institute, University in Bergen
%         email: ida.solbrekke@uib.no
%         Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% chech if height_low < height_high and calculating wind shear
if height_high>height_low
    WIND_Shear_Data = (wndspd_z2-wndspd_z1);
    WIND_Grad_Data = (wndspd_z2-wndspd_z1)./(z2-z1);
elseif z2<z1
    disp('ERROR: z1>z2. Make sure that z1<z2 when calculating windshear')
elseif z1 == z2
    disp('ERROR: Calculating wind shear for the same height -> z1 == z2 -> WND_Shear_Data = 0')
end


