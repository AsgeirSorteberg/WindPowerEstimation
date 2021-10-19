function [P_wnd_dens,P_wnd_dens_unit]=WIND_calc_WndPowerDensity(wndspd_hub,rho_hub)
% PURPOSE
% Calculate the total wind power density (W/m^2)
% 
% INPUT
% wndspd_hub   -  Windspeed in hub height (m/s)     - wndspd_hub(no_gridpnts,no_times)
% rho_hub      -  Air density in hub height (kg/m3) - rho_hub(no_gridpnts,no_times)
%
% OUTPUT
% P_wnd_dens        - the total wind power density - P_wnd_dens(no_gridpnts,no_times)
% P_wnd_dens_unit   - Unit (Watt)
%
% AUTHOR: Ida Marie Solbrekke, modified by Asgeir Sorteberg
%         Bergen offshore wind centre, Geophysical institute, University in Bergen
%         email: ida.solbrekke@uib.no
%         Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('WIND_calc_WndPowerDensity: Calculating wind power density')

% The total wind power delivered to a wind turbine (W)
P_wnd_dens=0.5*rho_hub.*wndspd_hub.^3;

% unit
P_wnd_dens_unit='W/m^2';

disp('WIND_calc_WndPowerDensity: Finished')

