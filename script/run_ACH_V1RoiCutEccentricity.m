function run_ACH_V1RoiCutEccentricity

[dMRI, List, AMD, AMD_Ctl, RP, Ctl] = SubJect;

Ctl =[38    39    40    41    42    43]

% 0-3
ACH_V1RoiCutEccentricity(Ctl,0,3)
% 15-30
ACH_V1RoiCutEccentricity(Ctl,15,30)
% 30-
ACH_V1RoiCutEccentricity(Ctl,30,90)