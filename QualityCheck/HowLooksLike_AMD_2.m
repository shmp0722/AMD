function HowLooksLike_AMD_2(subID)
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
    subID = [AMD,AMD_Ctl];
end
%% load fiber groups (fg) and ROI files% select the subject{i}

% This selects a specific
for ii = subID; % 7 , 17
    % These directories are where we keep the data at Stanford.
    % The pointers must be directed to any site.
    SubDir=fullfile(homeDir,subDir{ii});
    OTdir = fullfile(SubDir,'/dwi_1st/fibers/OT_MD22');
    ORdir= fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_divided');
    
    % dirROI = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt6 =fullfile(SubDir,'/dwi_1st/dt6.mat');
    
    %% OT check
    % Optic tract
    ROT_Name = fullfile(OTdir,'*R*.mat');
    ROT = dir(ROT_Name);
    
    LOT_Name = fullfile(OTdir,'*L*.mat');
    LOT = dir(LOT_Name);
    
    if length(LOT)==1
        L_OT = fgRead(fullfile(OTdir,LOT.name));
    elseif length(LOT)>=2
        L_OT = fgRead(fullfile(OTdir,LOT(1).name));
    end
    
    if length(ROT)==1 
            R_OT = fgRead(fullfile(OTdir,ROT.name));
    elseif length(ROT)>=2
            R_OT = fgRead(fullfile(OTdir,ROT(1).name));
    end
    
    %% OR check
    ROR = dir(fullfile(ORdir, '*Rt*MD4.pdb'));
    LOR = dir(fullfile(ORdir, '*Lt*MD4.pdb'));
    
    if ~isempty(ROR)
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
%     light
    
    title(sprintf('%s', subDir{ii}));
%     view(-184,40)
end
return