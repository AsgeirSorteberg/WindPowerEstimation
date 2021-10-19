function [perc_wndspd_cubed] = WIND_calc_PercCubedProd(wndspd_hub)

% PURPOSE
% Calculates the fraction of time the wind power is a function of the wind speed cubed.
% wndspd >= u_ci & wndspd_hub<u_r
%
% INPUT
% wndspd_hub - Wndspeed in hub height (m/s) - wndspd_hub(no_gridpnts,no_times)
% u_ci       - cut-in wind speed (m/s)   - scalar, global variable
% u_r        - cut-out wind speed (m/s)  - scalar, global variable
%
% OUTPUT
% perc_wndspd_cubed - Percentage of the time the wind power poductiuon is a function of the wind speed cubed (u_ci <= u < u_r) [%] - perc_wndspd_cubed(no_gridpnts,1)
%
% AUTHOR: Ida Marie Solbrekke, modified by Asgeir Sorteberg
%         Bergen offshore wind centre, Geophysical institute, University in Bergen
%         email: ida.solbrekke@uib.no
%         Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Wnd_calc_PercCubedProd: Calc the percentage of time where the power prod is a function of the wind speed cubed')

% Call global variables
global u_ci u_r

% number of timesteps with values for each point
no_stps=sum(~isnan(wndspd_hub),2);

% calc the sum of elements where wndspd_hub>=u_ci & wndspd_hub<u_r
wndspd_cubed = sum(wndspd_hub>=u_ci & wndspd_hub<u_r,2); 
% calc the relative percentage
perc_wndspd_cubed = (wndspd_cubed./no_stps)*100;

disp('Wnd_calc_PercCubedProd: Finished')

