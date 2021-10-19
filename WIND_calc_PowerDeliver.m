function [P_wnd,P_wnd_unit]=WIND_calc_PowerDeliver(wndspd_hub,rho_hub)
% PURPOSE
% Calculate the total wind power delivered to a wind turbine (W)
% 
% INPUT
% wndspd_hub   -  Windspeed in hub height (m/s)     - wndspd_hub(no_gridpnts,no_times)
% rho_hub      -  Air density in hub height (kg/m3) - rho_hub(no_gridpnts,no_times)
% A_sweep      -  Swept area of the turbine rotor (m^2) - scalar  
%                 A_sweep is available from WIND_TurbineInfo.m
%
% OUTPUT
% P_wnd        - the total wind power delivered to a wind turbine P_wnd(no_gridpnts,no_times)
% P_wnd_unit   - Unit (Watt)
%
% AUTHOR: Ida Marie Solbrekke, modified by Asgeir Sorteberg
%         Bergen offshore wind centre, Geophysical institute, University in Bergen
%         email: ida.solbrekke@uib.no
%         Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('WIND_calc_PowerDeliver: Calculating wind power delivered to a wind turbine')
% call global variables
global A_sweep

% The total wind power delivered to a wind turbine (W)
P_wnd=0.5*rho_hub.*A_sweep.*wndspd_hub.^3;

% unit
P_wnd_unit='Watt';

disp('WIND_calc_WndPower: Finished')


