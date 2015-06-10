function FS_autosegment(subID)

%
% To run FS auto segmention with ACH dMRI subjects.
%
% SO @ACH 2015
%
%   Example:
%   subID  = 'AMD-YA-20150426';
%   FS_autosegment(subID)

%% pick up current subject
if notDefined('subID')
    [homeDir, subID] = fileparts(pwd);
end

%% set t1 and subject ID 
t1 = fullfile(homeDir,subID,'t1.nii.gz');
% subID = 'AMD-YA-20150426';

% run freesurfer auto segmentation
fs_autosegmentToITK(subID, t1);