function [P_turbine,P_turbine_unit] = WIND_calc_TurbinePowerProd(wndspd_hub,rho_hub,method)


% PURPOSE
% Calculate wind power that can be extracted from the wind for a selected turbine (W)
% This calculations gives the gross energy production which is the energy production of 
% the wind farm obtained by using the free stream hub height wind speed 
% and the manufacturers supplied turbine power curve 
% It is assumed that there are no loss factors such as wake interactions,
% turbine availability, electrical transmission efficiency or different
% curtailments (when the system operator cuts the amount of power generation 
% for a specified amount of time due to for example grid restrictions,
% noise, visual or environmental related cuts.
%
% Four methods can be used. 
% 1. Without air density corrections on the power curve. 
% 2. With air density corrections on the power curve.
% 3. Without air density corrections on the power curve, but a smooth
%    shutdown and startup from cut-off windspeed to a selected windspeed above cut-off
% 4. Without air density corrections on the power curve, but a startup hysteresis.
%    The wind turbine will shut down when the wind speed reaches cut-off
%    windspeed but will not start up again before the wind speed is reduced
%    to a selected wind speed below the cut-off speed. The startup is
%    assumed to be instant to the rated power.
%
% This calculations gives the gross energy production which is the energy production of 
% the wind farm obtained by using the free stream hub height wind speed 
% and the manufacturers supplied turbine power curve (with or without air density corrections)
% It is assumed that there are no loss factors such as wake interactions,
% turbine availability, electrical transmission efficiency or different
% curtailments (when the system operator cuts the amount of power generation 
% for a specified amount of time due to for example grid restrictions,
% noise, visual or environmental related cuts.
%
%
% INPUT
%
% wndspd_hub   -  Windspeed in hub height (m/s)     - wndspd_hub(no_gridpnts,no_times)
% rho_hub      -  Air density in hub height (kg/m3) - rho_hub(no_gridpnts,no_times)
%                                               NOTE: rho_hub only used if method='density_correction'
% turbine_name - Name of the turbine. Must be one of the turbines listed in WIND_TurbineInfo.m    
%               'SWT-6.0-154'; 
%                             Siemens turbines used in Hywind Scotland
%                             Nominal power 6 MW 
%                             Serial production year: 2014
%                             https://en.wind-turbine-models.com/turbines/657-siemens-swt-6.0-154
%                'DTU-10.0-Reference';  
%                             DTU Reference turbine
%                             Nominal power 10 MW 
%                             https://backend.orbit.dtu.dk/ws/portalfiles/portal/55645274/The_DTU_10MW_Reference_Turbine_Christian_Bak.pdf
%                'IEA-15-240-RWT'
%                             IEA Wind 15-Megawatt Offshore Reference Wind Turbine
%                             Nominal power 15 MW
%                             https://www.nrel.gov/docs/fy20osti/75698.pdf
%                   
%                 The turbine_name is used to retrive info from WIND_TurbineInfo.m about:
%                 u_ci: cut-in wind speed
%                 u_co: cut-out wind speed
%                 u_r: Rated wind speed 
%                 P_rated: Rated power
%                 rho_ref: Reference air density for turbine design 
%                   
%  method   - method for calculation
%             'no_density_correction' - Calculates wind power based on the power curves 
%                                       available from the wind turbine manufacturers which are only valid for 
%                                       the standard reference density given by rho_ref.
%                                        |
%                                        |
%                                        |
%                                        |       /--------|
%                                        |      /         |
%                                        |     /          |
%                                        |____/           |  
%                                        |----|-----------|----------
%                                           u_ci       u_ci   
%
%             'density_correction' -    Calculates wind power with density corrections of the manufacturers power curves.
%                                       The method used for wind turbine power curve adjustment was
%                                       introduced by Svenningsen (2010) Power curve air density correction and other power curve
%                                       options in WindPRO. 2010. http://www.emd.dk/files/windpro/WindPRO_Power_Curve_Options.pdf.
%                                       Se also Jung and Schindler (2019): The role of air density in wind energy 
%                                       assessment e A case study from Germany.Energy 171 (2019) 385-392
%                                       The method has two steps: 
%                                       1: Scaling of the wind speeds of the standard power curve 
%                                       2: Linearly interpolate the new corrected power values to the original wind speeds
%
%            'smooth_shut_down_start'   -   Calculates wind power without air density corrections on the power curve, but a 
%                                      smooth shutdown and startup from cut-off windspeed to cut-off+wnd_increment_smooth
%
%                                        |
%                                        |
%                                        |
%                                        |       /--------\
%                                        |      /          \
%                                        |     /            \
%                                        |____/              \____
%                                        |----|-----------|-->|--------
%                                           u_ci       u_co   u_co+wnd_increment_smooth
%

%            'startup_hysteresis' -   Calculates wind power without air density corrections on the power curve, but
%                                      with a shutdown hysteresis were the wind turbine will shut down when the 
%                                      wind speed reaches cut-off wind speed but will not start up again before the
%                                      wind speed is reduced to cut-off-wnd_increment_hyst
%
%                                        |
%                                        |
%                                        |
%                                        |       /---------|
%                                        |      /          |
%                                        |     /           |
%                                        |____/            |____
%                                        |----|--------|<--|----------
%                                           u_ci       |  u_co
%                                                      u_co-wnd_increment_hyst
%  
%
% OUTPUT
% P_turbine      - Wind power extracted from the wind for a selected turbine - P_turbine(no_gridpnts,no_times)
% P_turbine_unit - Unit (Watt)
%
%
% USES: WIND_TurbineInfo.m  
%       WIND_OperationInfo.m (only used for methods: 'smooth_shut_start' and 'shutdown_hysteresis')
%
%  Author: Asgeir Sorteberg, modified by Ida M. Solbrekke
%          Geophysical Institute, University of Bergen.
%          email: asgeir.sorteberg@uib.no
%
%          Feb 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call some global variables
global u_ci u_r u_co wnd_increment_smooth wnd_increment_hyst rho_ref P_rated

if strcmp(method,'no_density_correction')
    disp(['WIND_calc_TurbinePowerProd: Calculate wind turbine power production based on theoretical power curve'])
elseif strcmp(method,'density_correction')
    disp(['WIND_calc_TurbinePowerProd: Calculate wind turbine power curve production based on theoretical power curve + adjustment based on air density'])
elseif strcmp(method,'smooth_shut_down_start')
    disp(['WIND_calc_TurbinePowerProd: Calculate wind turbine power curve production based on theoretical power curve + smooth shutdown and startup'])
elseif strcmp(method,'startup_hysteresis')
    disp(['WIND_calc_TurbinePowerProd: Calculate wind turbine power curve production based on theoretical power curve + startup hysteresis'])
else
    disp(['WIND_calc_TurbinePowerProd: ERROR: Method: ' method ' not recognized'])
    return
end

% dimensions
no_pnts=size(wndspd_hub,1);
no_times=size(wndspd_hub,2);
  

% ----------------
% Turbine information
% ----------------
% we need:
% u_ci: cut-in wind speed (m/s)  - minimum wind speed at which the 
%       turbine blades overcome friction and begin to rotate.
% u_co: cut-out wind speed. (m/s) - the speed at which the turbine blades 
%        are brought to rest to avoid damage from high winds. 
% u_r: Rated wind speed (m/s) - The wind speed where the turbine starts to 
%      produce at maximum capacity
% P_rate: Rated power (W)
% rho_ref: Reference air density for turbine design (kg/m3)
%[u_ci,u_co,u_r,d_rot,A_sweep,P_rate,rho_ref,height_hub]=WIND_TurbineInfo(turbine_name);

    
% ----------------
% Calculate wind power that can be extracted from the wind for the selected turbine (W)
% using windspeed at hub height and no air density correction
% This is the first step for all methods
% ----------------

% init
P_turbine=ones(no_pnts,no_times)*NaN;
% wind speed < u_ci
indx=find(wndspd_hub<u_ci);
P_turbine(indx)=0;
% wind speed >= u_ci and < u_r
indx=find(wndspd_hub>=u_ci & wndspd_hub<u_r);
P_turbine(indx)=P_rated*(wndspd_hub(indx).^3-u_ci^3)./(u_r^3-u_ci^3);
% wind speed >= u_r and < u_co
indx=find(wndspd_hub>=u_r & wndspd_hub<u_co);
P_turbine(indx)=P_rated;
% wind speed >= u_co
indx=find(wndspd_hub>=u_co);
P_turbine(indx)=0;
   
 
 if strcmp(method,'density_correction')
     % ----------------
% Doing wind turbine power curve adjustment based on air density
% Method: Svenningsen (2010) Power curve air density correction and other power curve
% options in WindPRO. 2010. http://www.emd.dk/files/windpro/WindPRO_Power_Curve_Options.pdf.
% ----------------

% init
wndspd_hub_corr=wndspd_hub*NaN;
   
% 1: Scaling of the wind speeds of the standard power curve based on air density

% wind speed <= 8 m/s
   indx=find(wndspd_hub<=8);
   wndspd_hub_corr(indx)=wndspd_hub(indx).*((rho_ref./rho_hub(indx)).^(1/3));
% wind speed > 8 m/s and < 13 m/s
   indx=find(wndspd_hub>8 & wndspd_hub<13);
   wndspd_hub_corr(indx)=wndspd_hub(indx).*((rho_ref./rho_hub(indx)).^(1/3+(1/3*((wndspd_hub(indx)-8)./5))));
% wind speed >= 13 m/s
   indx=find(wndspd_hub>=13);
   wndspd_hub_corr(indx)=wndspd_hub(indx).*((rho_ref./rho_hub(indx)).^(2/3));

 % 2. interpolate wind power back to the original wind speeds
   disp(['WIND_calc_TurbinePowerProd: Do interpolation of power back to the original wind speeds'])
   P_turbine_density_corr=P_turbine*NaN;
   k=0;
   for i=1:no_pnts
       [~,w] = unique(wndspd_hub_corr(i,:), 'stable' );
        if size(w,1)<size(wndspd_hub_corr,2)
            k = k+1;
            dupl_ind = setdiff(1:numel(wndspd_hub_corr(i,:)),w);
            wndspd_hub_corr(i,dupl_ind)=wndspd_hub_corr(i,dupl_ind)+0.0001;
        end
       P_turbine_density_corr(i,:)=interp1(wndspd_hub_corr(i,:),P_turbine(i,:),wndspd_hub(i,:),'linear','extrap');
   end
 % rename
   P_turbine=P_turbine_density_corr;
 end

%  A = [1 2 3 2 5 3]
% [v, w] = unique( wndspd_hub_corr(164,:), 'stable' );
% duplicate_indices = setdiff( 1:numel(wndspd_hub_corr(164,:)), w )
%  
%  close all
%  figure(1)
%  plot(wndspd_hub_corr(164,:))
%  hold on
%  plot(wndspd_hub(164,:))
%  
%  d = wndspd_hub_corr(164,:)-wndspd_hub(164,:);
%  figure(2)
%  plot(P_turbine(164,:),'.')
 
 
if strcmp(method,'smooth_shut_down_start')
% ----------------
% Calculates wind power without air density corrections on the power curve, 
% but a smooth linear shutdown and startup from cut-off windspeed to 
% cut-off+wnd_increment_smooth
% ----------------

% Redo the the power calculation for high wind speeds  
% wind speed >= u_co & < u_co+wnd_increment_smooth
   indx = find(wndspd_hub>=u_co & wndspd_hub<(u_co+wnd_increment_smooth));
   P_turbine(indx)=P_rated*(1-(wndspd_hub(indx))./(u_co+wnd_increment_smooth));
 % wind speed >= u_co+wnd_increment_smooth
   indx=find(wndspd_hub>=(u_co+wnd_increment_smooth));
   P_turbine(indx)=0;
end
  
 
if strcmp(method,'startup_hysteresis')
% ----------------
% Calculates wind power without air density corrections on the power curve, but
% with a shutdown hysteresis were the wind turbine will shut down when the 
% wind speed reaches cut-off wind speed but will not start up again before the
% wind speed is reduced to cut-off-wnd_increment_hyst
% ----------------

% loop through all points to find the hysteris values
   for m=1:size(wndspd_hub,1)
       wnd=wndspd_hub(m,:);
% find all values between cutoff-wnd_increment_hyst and cutoff
       indx1=find(wnd>=(u_co-wnd_increment_hyst) & wnd<u_co);
       if ~isempty(indx1)
% skip first index to avoid crash on indx1-1 if indx1(1) is 1
       if indx1(1)==1
           indx1=indx1(2:end);
       end
% find the values comming before the ones selected by indx1
       if max(wnd(indx1-1))>u_co
          indx2=find(wnd(indx1-1)>=u_co);
% find all elements between cutoff-wnd_increment_hyst and cutoff where the element before is larger than cutoff
          for k=1:length(indx2)
              if k<length(indx2)
                  indx3=find(wnd(indx1(indx2(k)):indx1(indx2(k+1)))>=(u_co-wnd_increment_hyst) & wnd(indx1(indx2(k)):indx1(indx2(k+1)))<u_co);
              else
                  indx3=find(wnd(indx1(indx2(k)):end)>=(u_co-wnd_increment_hyst) & wnd(indx1(indx2(k)):end)<u_co);
              end   
% find the first sequence of values between cutoff-wnd_increment_hyst and cutoff where the element before is larger than cutoff
              indx3_diff=diff(indx3);
              if ~isempty(indx3_diff) 
                  indx4=find(indx3_diff>1);
                 if ~isempty(indx4)
                     indx4=indx4(1)-1;
% save the indexes for this sequence 
                     if k==1
                         indx_final(1:indx4+1)=indx1(indx2(k):indx2(k)+indx4);
                         indx4_old=indx4+1;
                     else
                         indx_final(indx4_old+1:indx4_old+indx4+1)=indx1(indx2(k):indx2(k)+indx4);
                         indx4_old=indx4_old+indx4+1;
                     end
                 end
              end
          end
       end
      end
% set power production to zero for the values between cutoff-wnd_increment_hyst and cutoff
% where the element before is larger than cutoff
      if exist('indx_final','var')
          P_turbine(m,indx_final)=0;
      end
% clear    
      clear indx4_old clear indx_final
   end
end 
 % make sure production not below zero and over Rated power 
 indx=find(P_turbine<0);
 P_turbine(indx)=0;
 
 indx=find(P_turbine>P_rated);
 P_turbine(indx)=P_rated;
 
 
% unit
P_turbine_unit='W';

disp(['WIND_calc_TurbinePowerProd: Finished'])
   
 


