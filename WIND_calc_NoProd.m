function [NoProd_LowWnd_hours,NoProd_LowWnd_frac,NoProd_HighWnd_hours,NoProd_HighWnd_frac,NoProd_Total_hours,NoProd_total_frac] = WIND_calc_NoProd(wndspd_hub,P_turbine)
% PURPOSE
% Calculates the number of hours and fraction of time with no Wnd power 
% due to too high (higher than the cut-out Wnd speed)  or too low Wnds
% lower than the cut-in Wnd speed) and the power production is zero
%
% INPUT
% wndspd_hub - Wndspeed in hub height [m/s] - wndspd_hub(no_gridpnts,no_times)
% P_tubine   - Power production [Watt) - P_tubine(no_gridpnts,no_times)
% u_ci       - cut-in wind speed [m/s]   - scalar 
% u_co       - cut-out wind speed [m/s]  - scalar
%
% OUTPUT
% NoProd_LowWnd_hours    - numbers of hours with no wind power production cause by u < u_ci [hours] - NoProd_LowWnd_hours(no_gridpnts,1)
% NoProd_LowWnd_frac     - fraction of the time the wind power production is zero caused by  u < u_ci [%] -  NoProd_LowWnd_frac(no_gridpnts,1)
% NoProd_HighWnd_hours   - numbers of hours with no wind power production cause by u >= u_c0 [hours] - NoProd_HighWnd_hours(no_gridpnts,1)
% NoProd_HighWnd_frac    - fraction of the time the wind power production is zero caused by  u >= u_co [%] -  NoProd_HighWnd_frac(no_gridpnts,1)
% NoProd_Total_hours     - numbers of hours with no wind power production cause by u < u_ci and u >= u_c0 [hours] - NoProd_Total_hours(no_gridpnts,1)
% NoProd_total_frac      - fraction of the time the wind power production is zero caused by u < u_ci and u < u_ci [%] -  NoProd_Total_frac(no_gridpnts,1)
%
% AUTHOR: Ida Marie Solbrekke, modified by Asgeir Sorteberg
%         Bergen offshore wind centre, Geophysical institute, University in Bergen
%         email: ida.solbrekke@uib.no
%         Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Wnd_calc_NoProd: Number of hours with no wind power production due to high/low windspeeds')

% Call global variables
global u_ci u_co

% number of timesteps with values for each point
no_stps=sum(~isnan(wndspd_hub),2);

% Hours and fraction with no production due to low (<u_ci) winds 
NoProd_LowWnd_hours = nansum((wndspd_hub<u_ci & P_turbine<1E-6),2);
NoProd_LowWnd_frac = nansum(NoProd_LowWnd_hours,2)./no_stps;

% Hours and fraction with no production due to high (>u_co) winds 
NoProd_HighWnd_hours = nansum((wndspd_hub>=u_co & P_turbine<1E-6),2);
NoProd_HighWnd_frac = nansum(NoProd_HighWnd_hours,2)./no_stps;

% Total hours and fraction with no production due to low and high winds 
NoProd_Total_hours = NoProd_LowWnd_hours+NoProd_HighWnd_hours;
NoProd_total_frac = NoProd_LowWnd_frac+NoProd_HighWnd_frac;


disp('Wnd_calc_NoProd: Finished')
