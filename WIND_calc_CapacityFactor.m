function [CapFac] = WIND_calc_CapacityFactor(P_turbine)
% PURPOSE
% Calculating the Capacity Factor (CF)
% The capacity factor is its average power output over a given period of time
% divided by the maximum possible power output over that period.
%
% INPUT
% P_turbine - Wind power extracted from the wind for a selected turbine [Watt] - P_turbine(no_gridpnts,no_times)
% P_rated  - Rated power [Watt] (given as a scalar or P_rated(no_gridpnts,1))

% OUTPUT
% CapFac - Capacity Factor (fraction between 0 and 1). CapFac(no_gridpnts,1)
%
% AUTHOR: Ida Marie Solbrekke, modified by Asgeir Sorteberg
%         Bergen offshore wind centre, Geophysical institute, University in Bergen
%         email: ida.solbrekke@uib.no
%         Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(['WIND_calc_CapacityFactor: Calculating the Capacity Factor'])

% Load global variables
global P_rated

% Capacity factor
CapFac = nanmean(P_turbine,2)./P_rated;


disp(['WIND_calc_CapacityFactor: Finished'])