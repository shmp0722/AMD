function run_ACH_V1RoiCutEccentricity

[dMRI, List, AMD, AMD_Ctl, RP, Ctl] = SubJect;


%% 0-3
for ii=21
    ACH_V1RoiCutEccentricity(ii,0,3)
    % 15-30
    ACH_V1RoiCutEccentricity(ii,15,30)
    % 30-
    ACH_V1RoiCutEccentricity(ii,30,90)
end