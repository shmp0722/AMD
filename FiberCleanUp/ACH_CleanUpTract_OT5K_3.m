function ACH_CleanUpTract_OT5K_3(subject)
% To get the Optic Tract is able to analyse.

%%
[homeDir ,subDir, AMD, AMD_Ctl, RP, Ctl] = SubJect;

% %%
% if ischar(subject); end 
% 
% if isnumeric(subject);
%     subject = [64:67,75,76,82,83]

if notDefined('subject'),
    subject = 1:length(subDir);
end

%% dtiIntersectFibers
% exclude fibers using waypoint ROI
for ii = subject
    % INPUTS
    SubDir=fullfile(homeDir,subDir{ii});
    fgDir = (fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K'));    
    
    %% AFQ_removeoutlier
    switch ii
        case {7,17}
            fgfiles = {...
                '*fg_OT_5K*Lt*_Ctrk100_cleaned.pdb'
                '*fg_OT_5K*Rt*_Ctrk100.pdb'};
        otherwise
            fgfiles = {...
                '*fg_OT_5K*Lt*_Ctrk100.pdb'
                '*fg_OT_5K*Rt*_Ctrk100.pdb'};
    end
    
    for j= 1:2
        fgF = dir(fullfile(fgDir,fgfiles{j}));
        sprintf( subDir{ii})
        fg  = fgRead(fullfile(fgDir,fgF.name));
        
        if ~isempty(fg.fibers)
            % remove outlier
            [fgclean, ~] = AFQ_removeFiberOutliers(fg,3,2,25,'mean',1, 5,[]);
            fgclean = SO_AlignFiberDirection(fgclean,'AP');
            
            P = {'LOT', 'ROT'};
            fgclean.name = sprintf('%s_MD32_%d',P{j},length(fgclean.fibers));
            
            % save final fg
            NewfgDir = (fullfile(SubDir,'/dwi_1st/fibers/OT_MD32'));
            if ~exist(NewfgDir,'dir');mkdir(NewfgDir);end
            
            fgWrite(fgclean,fullfile(NewfgDir,[fgclean.name,'.mat']),'mat')
        end
        clear fg fgclean;
    end
end

