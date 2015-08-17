function DeleteFgs



%% Identify the directories and subject types in the study
% The full call can be
[homeDir,subDir, AMD, AMD_Ctl, RP, Ctl] = SubJect;

%%

%% load fiber groups (fg) and ROI files% select the subject{i}

% This selects a specific
for ii =[42,43]
    % These directories are where we keep the data at Stanford.
    % The pointers must be directed to any site.
    SubDir=fullfile(homeDir,subDir{ii});
    OTdir = fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K');
    ORdir= fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_100K');
    
    cd(OTdir)
    delete('*Cerebral-White-Matter*.pdb')
    
    ACH_CleanUpTract_OT5K(ii)
end
    