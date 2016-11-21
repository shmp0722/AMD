function [dMRI, List, AMD, AMD_C, JMD_C, RP, Ctl,LHON,JMD_all] = SubJect2

% Return all subjects in dMRI directory

%% 
% Amd
dMRI='/media/HDPC-UT/dMRI_data';
All_List = dir(fullfile(dMRI,'*-*'));

for ii = 1:length(All_List)
    List{ii} = All_List(ii).name;
end

%%
AMD   = dir('/media/HDPC-UT/dMRI_data/AMD-0*');
AMD_C = dir('/media/HDPC-UT/dMRI_data/AMD-C*');
LHON  = dir('/media/HDPC-UT/dMRI_data/LHON*');
JMD_all   = dir('/media/HDPC-UT/dMRI_data/JMD*');
JMD_C     = dir('/media/HDPC-UT/dMRI_data/JMD-C*');
Ctl   = dir('/media/HDPC-UT/dMRI_data/Ct*');
RP    = dir('/media/HDPC-UT/dMRI_data/RP*');