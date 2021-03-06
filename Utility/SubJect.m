function [dMRI, List, AMD, AMD_Ctl, RP, Ctl,LHON,JMD] = SubJect

% Return all subjects in dMRI directory

%% 
% Amd
dMRI='/media/USB_HDD1/dMRI_data';
All_List = dir(fullfile(dMRI,'*-*'));

for ii = 1:length(All_List)
    List{ii} = All_List(ii).name;
end


%%
RP      = [68,70:76];
AMD     = [1:8];
AMD_Ctl = [9:20];
Ctl     = [23:25,27,34:43]; 

JMD = [47:58];
LHON = [59:65,67];
return

Ctl_follow = [26,28:33];
AO      = 21;
CSC     = 22;

return
%%
AMD   = dir('/media/USB_HDD1/dMRI_data/AMD-0*');
AMD_C = dir('/media/USB_HDD1/dMRI_data/AMD-C*');
LHON  = dir('/media/USB_HDD1/dMRI_data/LHON*');
JMD_all   = dir('/media/USB_HDD1/dMRI_data/JMD*');
JMD_C     = dir('/media/USB_HDD1/dMRI_data/JMD-C*');
Ctl   = dir('/media/USB_HDD1/dMRI_data/Ct*');
RP    = dir('/media/USB_HDD1/dMRI_data/RP*');

