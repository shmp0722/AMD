function FS_autosegment(homeDir,subID)

%
% To run FS auto segmention with ACH dMRI subjects.
%
% SO @ACH 2015
%
%   Example:
%   subID  = 'AMD-YA-20150426';
%   FS_autosegment(subID)

%% pick up current subject
if or(notDefined('homeDir'),notDefined('subID'))
    [homeDir, subID] = fileparts(pwd);
end

%% set t1 and subject ID 
t1 = fullfile(homeDir,subID,'t1.nii.gz');
% subID = 'AMD-YA-20150426';

% run freesurfer auto segmentation
fs_autosegmentToITK(subID, t1);

%% memo to solve a minor bag
    % if you will still have any problem above and you can find automatic
    % segmented  file in freesurfer folder
    % (i.e. /[tamagawadatapath]/freesurfer/[subject]/mri/ribon.mgz)
    %
    % please run a script below
    % if you will still have any problem above and you can find automatic segmented
    outfile     = fullfile(fileparts(t1),...
        sprintf('t1_class_fs_%s.nii.gz',  datestr(now, 'yyyy-mm-dd-HH-MM-SS')));
    fillWithCSF = 0;
    alignTo     = t1;
    
    fs_ribbon2itk(subID, outfile, fillWithCSF, alignTo);
% end