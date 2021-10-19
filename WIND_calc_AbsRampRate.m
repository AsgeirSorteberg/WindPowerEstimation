function [ARR] = WIND_calc_AbsRampRate(data)
% PURPOSE
% calculate the absolute ramp rates. 
% Absoulute ramp-rates is defined as the absolute value of  how much a 
% time varying variable (such as wind speed or wind power) changes during a time-increment
% 
% INPUT
% data - timeseries for a given variable - data(no_gridpnts,no_times)
%
% OUTPUT
% ARR - absolute ramp rates - ARR(no_gridpnts,no_times-1)
%

disp('WIND_calc_AbsRampRate: Calculates the absolute ramp rates')

% Calculate the abs. ramp rate
ARR= abs(diff(data,1,2));

disp('WIND_calc_AbsRampRate: Finished')
