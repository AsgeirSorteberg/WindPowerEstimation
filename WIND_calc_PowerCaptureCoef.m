function [Pc,Pc_unit]= WIND_calc_PowerCaptureCoef(P_turbine,P_wnd)
%
% PURPOSE
% Estimates of the  power capture  coefficient- Pc for a given turbine.
% Pc is a dimensionless measure of the efficiency of a wind turbine in
% extracting the energy content of a wind stream.
%  
% The power coefficient Cp is defined as the ratio of the power extracted
% by the rotor of the wind turbine relative to the energy available 
% in the wind stream just before it interacted with the rotor of the turbine. 
%
%
%  INPUT
% P_turbine      - Wind power extracted from the wind for a selected turbine - P_turbine(no_gridpnts,no_times)
%                  Note: Can be calculated with WIND_calc_TurbinePowerProd.m
% P_wnd          - The total wind power delivered to a wind turbine 
%                  Note: Can be calculated with WIND_calc_WndPower.m
%                NB: P_turbine and P_wnd must have same unit (W, kW, MW or
%                    similar
%              
% OUTPUT
% Pc          - Theoretical extractable wind power as the fraction of energy available 
%               in the wind stream - Pc(no_gridpnts,1)            
% Pc_unit     - Unit (fraction between 0 and 1)
%
% AUTHOR: Asgeir Sorteberg, modified by Ida Marie Solbrekke
%         Bergen offshopre wind centre, Geophysical institute, University in Bergen
%         email: asgeir.sorteberg@uib.no
%         Nov 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('WIND_calc_PowerCaptureCoef: Calculating the  power capture coefficient')

% the  power coefficient- Cp
Pc=nanmean(P_turbine,2)./nanmean(P_wnd,2); 

% unit
Pc_unit='Fraction';


disp('WIND_calc_PowerCaptureCoef: Finished')

