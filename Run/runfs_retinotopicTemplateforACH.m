function runfs_retinotopicTemplateforACH(subID)
% create retiontopic map based on anatomical information. This function
% returns 'eccentricitymap.nii.gz' and 'polaranglemap.nii.gz'.
%
% See; fs_retinotopicTemplate
%

%%
[homeDir,~] = SubJect;

if notDefined('subID')
   [~, subID] = fileparts(pwd);
end

%% run fs_retinotopicTemplate

out_path = fullfile(homeDir,subID,'fs_Retinotopy2');

if ~exist(out_path);
    mkdir(out_path);
end

%% run main function fs_retinotopicTemplate
fs_retinotopicTemplate(Cur_subject, out_path)

end
% matlabpool close