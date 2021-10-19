function [FullLoadHours] = WIND_calc_FullLoadHours(P_turbine,delta_t)
% PURPOSE
% Calculate Full load hours 
% Full load hours are calculated as the turbine's accumulated energy production
% over a given time period divided by its rated power. 
%
% The full load hours multiplied with the installed capacity will give the production 
% over the time period. Full load hours is a measure of the quality of the production site
% without having to know what the installed rated capacity will be (but it is not
% independent of turbine design as the production is dependent on the selected power 
% curve used in production calculation).
% Often a full year is used as the time period
%
% INPUT
% P_turbine - Wind power extracted from the wind for a selected turbine - P_turbine(no_gridpnts,no_times)
%             (must have unit of Watts, W, kW, MW or similar is ok)
% P_rated   -  P_rate: Rated power - scalar or P_rated(no_gridpnts,1)
%             (P_rate must have same unit as P_turbine)
% delta_t   - time between values in P_turbine (hours) - scalar
%             Ex: if P_turbine is the power production value every second hour delta_t=2;
%
% OUTPUT 
% FullLoadHours - Full load hours over the time period of data (given by
%                 P_turbine) [hours] - FullLoadHours(no_gridpnts,1)
%
% AUTHOR: Ida Marie Solbrekke, modified by Asgeir Sorteberg
%         Bergen offshore wind centre, Geophysical institute, University in Bergen
%         email: ida.solbrekke@uib.no
%         Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call global variables
global P_rated
%

disp('WIND_calc_WndPower_FullLoadHours: Calculates Full load hours over given time period')

% accumulated energy production (J/s*hours)
E_Turbine_acc=nansum(P_turbine*delta_t,2);

% Full load hours (hours)
FullLoadHours=E_Turbine_acc./P_rated;

disp('WIND_calc_WndPower_FullLoadHours: Finished')



