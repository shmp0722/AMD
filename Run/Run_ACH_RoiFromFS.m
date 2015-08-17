function Run_ACH_RoiFromFS

%
%

%% Dir and List
[homeDir , List] = SubJect;
%  NotYet = zeros(size( List));

% run fs if its not done.
for ii =    40:length(List)
    subID = List{ii};
    V1roi = fullfile(homeDir,subID,'ROIs/rh_V1_smooth3mm.mat');
 
    if ~exist(V1roi)
        try
            cd(fullfile(homeDir,subID))
            ACH_RoiFromFS
        catch 
            cd(fullfile(homeDir,subID))
            fsSubDir =  fullfile(homeDir,'freesurfer',subID);
            cmd = sprintf('!mv %s %s',fsSubDir,fullfile(homeDir,'freesurfer',['weird_',subID]));
            eval(cmd);
            FS_autosegment
            ACH_RoiFromFS
        end
    end
end
return