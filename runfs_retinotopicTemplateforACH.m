function runfs_retinotopicTemplateforACH(subID)
% create retiontopic map based on anatomical information. This function
% returns 'eccentricitymap.nii.gz' and 'polaranglemap.nii.gz'.
%
% See; fs_retinotopicTemplate
%

%%
[homeDir,subDir] = SubJect;

if notDefined('subID')
    [~,SubName]= fileparts(pwd);
    subID =find(ismember(subDir,SubName));
end

%% run fs_retinotopicTemplate

Cur_subject = subDir{subID};
out_path = fullfile(homeDir,subDir{subID},'fs_Retinotopy2');

if ~exist(out_path);
    mkdir(out_path);
end

%% run main function fs_retinotopicTemplate
fs_retinotopicTemplate(Cur_subject, out_path)

end
% matlabpool close