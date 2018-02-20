function runfs_retinotopicTemplateforACH
% create retiontopic map based on anatomical information. This function
% returns 'eccentricitymap.nii.gz' and 'polaranglemap.nii.gz'.
%
% See; fs_retinotopicTemplate
%

%% define this subject
% [homeDir,~] = SubJect;

% if notDefined('subID')
   [homeDir, subID] = fileparts(pwd);
   fsDir = fullfile('/media/USB_HDD1/dMRI_data/freesurfer');
% end

% check freesurfer files existance
if ~exist(fullfile(fsDir,subID));
    print('Check fs folder existance')
    return
end

%% run fs_retinotopicTemplate

out_path = fullfile(homeDir,subID,'fs_Retinotopy2');

if ~exist(out_path);
    mkdir(out_path);
end

%% run main function fs_retinotopicTemplate
fs_retinotopicTemplate(subID, out_path)

end
% matlabpool close