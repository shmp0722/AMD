function FS_autosegment(subID)

%
% To run FS auto segmention with ACH dMRI subjects.
%
% SO @ACH 2015
%
%   Example:
%   subID  = 'AMD-YA-20150426';
%   FS_autosegment(subID)

%%
if notDefined('subID')
    [~, subID] = fileparts(pwd);
end

%% set t1 and subject ID 
t1 = fullfile('/home/ganka/dMRI_data',subID,'t1.nii.gz');
% T1 = niftiRead(t1);
% subID = 'AMD-YA-20150426';

% run freesurfer auto segmentation
fs_autosegmentToITK(subID, t1);