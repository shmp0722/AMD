function [dMRI, List, AMD, AMD_Ctl, RP, Ctl,LHON,JMD,HI] = SubJect20160128

% Return all subjects in dMRI directory

%% 
% Amd
dMRI='/media/HDPC-UT/dMRI_data';
All_List = dir(fullfile(dMRI,'*-*'));

for ii = 1:length(All_List)
    List{ii} = All_List(ii).name;
end

%%
RP      = [68,70:76];
AMD     = [1:8];
AMD_Ctl = [9:21];
Ctl     = [23:25,27,36:45];
HI = [34,35];

JMD = [47:58];
LHON = [59:65,67];
return

Ctl_follow = [26,28:33];
AO      = 21;
CSC     = 22;

return
%% Who is ctl?
%
%  Ctl     = [23:25,27,36:43];
% 
%     'Ctl-12-SA-20140307'
%     'Ctl-13-MW-20140313-dMRI-Anatomy'
%     'Ctl-14-YM-20140314-dMRI-Anatomy'
%     'Ctl-RT-20150426'
%     'JMD-Ctl-09-RN-20130909'
%     'JMD-Ctl-10-JN-20140205'
%     'JMD-Ctl-11-MT-20140217'
%     'JMD-Ctl-AM-20130726-DWI'
%     'JMD-Ctl-FN-20130621-DWI'
%     'JMD-Ctl-HH-20120907DWI'
%     'JMD-Ctl-MT-20121025-DWI'
%     'JMD-Ctl-SO-20130726-DWI'

%     'JMD-Ctl-SY-20130222DWI'
%     'JMD-Ctl-YM-20121025-DWI' 

