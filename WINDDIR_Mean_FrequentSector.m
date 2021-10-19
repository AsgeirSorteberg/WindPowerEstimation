function [WDIR_mean_dom_sec] = WINDDIR_Mean_FrequentSector(nora_x_wind_100,nora_y_wind_100)
% PURPOSE
% A routine that finds the most frequent wind sector at 100 m for each grid cell.
% The routine calculates the mean wind direction in the most frequent
% wind-direction sector using nora_x_wind_100 and nora_y_wind_100
% 45deg sectors = 8 sectors.
%
% uses: WIND_calc_uv2wnddir_rotangle_N3.m
%       RotAngle_Matrix.mat 

 
rot_angle = load('/Data/gfi/share/ModData/NORA3-WP/RotAngle_Matrix.mat');
[~,NORA_wdir]=WIND_calc_uv2wnddir_rotangle_N3(nora_x_wind_100,nora_y_wind_100,rot_angle.angle_matrix);

N_NE = sum(NORA_wdir>=0 & NORA_wdir<45,2);
NE_E = sum(NORA_wdir>=45 & NORA_wdir<90,2);
E_SE = sum(NORA_wdir>=90 & NORA_wdir<135,2);
SE_S = sum(NORA_wdir>=135 & NORA_wdir<180,2);
S_SW = sum(NORA_wdir>=180 & NORA_wdir<225,2);
SW_W = sum(NORA_wdir>=225 & NORA_wdir<270,2);
W_NW = sum(NORA_wdir>=270 & NORA_wdir<315,2);
NW_N = sum(NORA_wdir>=315 & NORA_wdir<360,2);

WDIR_tot = [N_NE,NE_E,E_SE,SE_S,S_SW,SW_W,W_NW,NW_N];
WDIR_name = {'N_NE';'NE_E';'E_SE';'SE_S';'S_SW';'SW_W';'W_NW';'NW_N'};
[WDIR_dom_sec,WDIR_dom_sec_ind] = max(WDIR_tot,[],2);
WDIR_dom_sec = WDIR_name(WDIR_dom_sec_ind);

WDIR_mean_dom_sec = NaN*ones(size(WDIR_dom_sec,1),1);
for i = 1:length(WDIR_dom_sec)
    if strcmp(WDIR_dom_sec(i),'N_NE')
        WDIR_mean_dom_sec(i) = nanmean(NORA_wdir(NORA_wdir(i,:)>=0 & NORA_wdir(i,:)<45));
    elseif strcmp(WDIR_dom_sec(i),'NE_E')
        WDIR_mean_dom_sec(i) = nanmean(NORA_wdir(NORA_wdir(i,:)>=45 & NORA_wdir(i,:)<90));
    elseif strcmp(WDIR_dom_sec(i),'E_SE')
        WDIR_mean_dom_sec(i) = nanmean(NORA_wdir(NORA_wdir(i,:)>=90 & NORA_wdir(i,:)<135));
    elseif strcmp(WDIR_dom_sec(i),'SE_S')
        WDIR_mean_dom_sec(i) = nanmean(NORA_wdir(NORA_wdir(i,:)>=135 & NORA_wdir(i,:)<180));
    elseif strcmp(WDIR_dom_sec(i),'S_SW')
        WDIR_mean_dom_sec(i) = nanmean(NORA_wdir(NORA_wdir(i,:)>=180 & NORA_wdir(i,:)<225));
    elseif strcmp(WDIR_dom_sec(i),'SW_W')
        WDIR_mean_dom_sec(i) = nanmean(NORA_wdir(NORA_wdir(i,:)>=225 & NORA_wdir(i,:)<270));
    elseif strcmp(WDIR_dom_sec(i),'W_NW')
        WDIR_mean_dom_sec(i) = nanmean(NORA_wdir(NORA_wdir(i,:)>=270 & NORA_wdir(i,:)<315));
    elseif strcmp(WDIR_dom_sec(i),'NW_N')
        WDIR_mean_dom_sec(i) = nanmean(NORA_wdir(NORA_wdir(i,:)>=315 & NORA_wdir(i,:)<360));
    end
end






