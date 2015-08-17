function [Rerun,NotYet] = Run_FS_autosegment(rerun)

% Checking all subject in dMRI directory if they have freesurfer
% segmentation files. If not, make it up.


%% Dir and List
[homeDir , List] = SubJect;
NotYet = zeros(size(List));

% run fs if its not done.
for ii = 1:length(List)
    subID = List{ii};
    fsDir   = getenv('SUBJECTS_DIR');
    
    MGZ = dir(fullfile(fsDir,subID,'/mri/*.mgz'));
    
    % checking if fs_segmentation correctly finished
    if length(MGZ)<20
        fsSubDir =  fullfile(fsDir,subID);
        Rerun{ii} = subID;
        NotYet(ii)= 1;
        % check rerun function
        if notDefined('rerun'); rerun = 0; end ;
        if rerun,
            cmd = sprintf('!mv %s %s',fsSubDir,fullfile(fsDir,['weird_',subID]));
            try
                eval(cmd);
                FS_autosegment(homeDir,subID);
            catch 
                FS_autosegment(homeDir,subID);
            end

        end
    end
end