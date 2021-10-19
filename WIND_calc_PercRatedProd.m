function [perc_wndspd_rated] = WIND_calc_PercRatedProd(wndspd_hub)

% PURPOSE
% Calculates the fraction of time with rated wind power power.
% wndspd_hub>=u_r & wndspd_hub<u_co
%
% INPUT
% wndspd_hub - Wndspeed in hub height (m/s) - wndspd_hub(no_gridpnts,no_times)
% u_r        - cut-in wind speed (m/s)   - scalar, global variable
% u_co       - cut-out wind speed (m/s)  - scalar, global variable
%
% OUTPUT
% perc_wndspd_rated - Percentage of the time the wind power poduction is rated/nameplate (u_r <= u < u_co) [%] - perc_wndspd_rated(no_gridpnts,1)
%
% AUTHOR: Ida Marie Solbrekke, modified by Asgeir Sorteberg
%         Bergen offshore wind centre, Geophysical institute, University in Bergen
%         email: ida.solbrekke@uib.no
%         Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Wnd_calc_PercRatedProd: Calc the percentage of time where the power prod is rated')

% call global variables
global u_r u_co

% number of timesteps with values for each point
no_stps=sum(~isnan(wndspd_hub),2);

% calc the sum of elements where wndspd_hub>=u_r & wndspd_hub<u_co
wndspd_rated = sum(wndspd_hub>=u_r & wndspd_hub<u_co,2); 
% calc the relative percentage
perc_wndspd_rated = (wndspd_rated./no_stps)*100;

disp('Wnd_calc_PercRatedProd: Finished')
