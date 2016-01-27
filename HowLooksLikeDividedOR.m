function HowLooksLikeDividedOR(subID)
% Create figures illustrating the OR, optic tract, FA on the these tracts,
% and possibly the LGN position
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    LHON2
%
% SO Vista lab, 2014

%% Identify the directories and subject types in the study
% The full call can be
[homeDir,subDir, AMD, AMD_Ctl, RP, Ctl] = SubJect;

%%
if notDefined('subID')
    subID = 1:length(subDir);
end
%% load fiber groups (fg) and ROI files% select the subject{i}

% This selects a specific
for whichSubject = subID;
    % These directories are where we keep the data at Stanford.
    % The pointers must be directed to any site.
    SubDir=fullfile(homeDir,subDir{whichSubject});
    OTdir = fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K');
    ORdir= fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_divided');
    
    % dirROI = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt6 =fullfile(SubDir,'/dwi_1st/dt6.mat');
    
    %% Load fiber groups
    % Optic tract
    ROT_Name = fullfile(OTdir,'*Rt-LGN4*AFQ*');
    ROT = dir(ROT_Name);
    LOT_Name = fullfile(OTdir,'*Lt-LGN4*AFQ*');
    LOT = dir(LOT_Name);
    
    L_OT = fgRead(fullfile(OTdir,LOT.name));
    %     L_OT = AFQ_removeFiberOutliers(L_OT,4,4,25);
    R_OT = fgRead(fullfile(OTdir,ROT.name));
    %     R_OT = AFQ_removeFiberOutliers(R_OT,4,4,25);
    
    ROR = dir(fullfile(ORdir, '*Rt*MD4.pdb'));
    LOR = dir(fullfile(ORdir, '*Lt*MD4.pdb'));
    
    if length(ROR)>0,
        for ll = 1:length(ROR)
            R_OR{ll} = fgRead(fullfile(ORdir,ROR(ll).name));
            L_OR{ll} = fgRead(fullfile(ORdir,LOR(ll).name));
        end
        
        %% Render fibers
        figure;hold on;
        Dt6 = dtiLoadDt6(dt6);
        C = jet(2+length(ROR)+length(LOR));
        
        AFQ_RenderFibers(R_OT,'numfibers',100,'color',C(1,:),'newfig',0)
        AFQ_RenderFibers(L_OT,'numfibers',100,'color',C(2,:),'newfig',0)
        
        for ll = 1:length(ROR)
            AFQ_RenderFibers(R_OR{ll},'numfibers',100,'color',C(2+ll,:),'newfig',0)
        end
        
        for ll = 1:length(ROR)
            AFQ_RenderFibers(L_OR{ll},'numfibers',100,'color',C(4+ll,:),'newfig',0)
        end
    end
    %%
    t1 = niftiRead(Dt6.files.t1);
    AFQ_AddImageTo3dPlot(t1,[0 0 -15]);
    axis image
    light
    
    title(sprintf('%s', subDir{whichSubject}));
    view(-184,40)
end
return