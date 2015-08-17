function Run_fs_retinotopicTemplate

%
% Make a retinotopic template based on anatomical information
% 
% SO@ACH 2015

%% pick all subjects 
[Home,subj] = SubJect; 

%%
% parpool(4)
%% fullpath to save dir
parfor ii = 5:length(subj)
    out_path = fullfile(Home,subj{ii},'/RetinoTemplate');
    if ~exist(out_path)
        mkdir(out_path)
    end
    
    % run main function
    fs_retinotopicTemplate(subj{ii}, out_path)
end