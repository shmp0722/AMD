function HowLooksLikeOT(subID)
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
for whichSubject = subID
    % These directories are where we keep the data at Stanford.
    % The pointers must be directed to any site.
    SubDir=fullfile(homeDir,subDir{whichSubject});
    OTdir = fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K');
    ORdir= fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_100K');
    
    % dirROI = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt6 =fullfile(SubDir,'/dwi_1st/dt6.mat');
    
    %% Load fiber groups
    % Optic tract
    ROT_Name = fullfile(OTdir,'*Rt-LGN4*Ctrk100_AFQ_*');
    ROT = dir(ROT_Name);
    LOT_Name = fullfile(OTdir,'*Lt-LGN4*Ctrk100_AFQ_*');
    LOT = dir(LOT_Name);
    
    % Load OT
    L_OT = fgRead(fullfile(OTdir,LOT(length(LOT)).name));    
    R_OT = fgRead(fullfile(OTdir,ROT(length(ROT)).name));
    
    % Load OR
    %     ROR_Name = dir(fullfile(ORdir, '*Rt*MD4.pdb'));
    %     LOR_Name = dir(fullfile(ORdir, '*Lt*MD4.pdb'));
    %
    %     R_OR = fgRead(fullfile(ORdir,ROR_Name.name));
    %     L_OR = fgRead(fullfile(ORdir,LOR_Name.name));
    
    %% Render fibers
    
    figure;hold on;
    Dt6 = dtiLoadDt6(dt6);
    C = jet(4);
    
    % AFQ_RenderFibers(R_OT,'numfibers',100,'color',C(1,:),'newfig',0,'dt',Dt6,'radius',[1 3])
    % AFQ_RenderFibers(L_OT,'numfibers',100,'color',C(2,:),'newfig',0,'dt',Dt6,'radius',[1 3])
    % AFQ_RenderFibers(R_OR,'numfibers',100,'color',C(3,:),'newfig',0,'dt',Dt6,'radius',[1 3])
    % AFQ_RenderFibers(L_OR,'numfibers',100,'color',C(4,:),'newfig',0,'dt',Dt6,'radius',[1 3])
    
    AFQ_RenderFibers(R_OT,'numfibers',100,'color',C(1,:),'newfig',0)
    AFQ_RenderFibers(L_OT,'numfibers',100,'color',C(2,:),'newfig',0)
    %     AFQ_RenderFibers(R_OR,'numfibers',100,'color',C(3,:),'newfig',0)
    %     AFQ_RenderFibers(L_OR,'numfibers',100,'color',C(4,:),'newfig',0)
    
    t1 = niftiRead(Dt6.files.t1);
    AFQ_AddImageTo3dPlot(t1,[0 0 -15])
    axis image
    light
    
    title(sprintf('%s', subDir{whichSubject}))
end
return

%%


% Optic tract
fglOT = fullfile(dirOTfgORdir,'fg_OT_5K_Optic-Chiasm_Lt-LGN4_2013-08-29_22.32.30-Right-Cerebral-White-Matter_Ctrk100_AFQ_92.pdb');
fglOT = fgRead(fglOT);
fgrOT = fullfile(dirOTfgORdir,'fg_OT_5K_Optic-Chiasm_Rt-LGN4_2013-08-29_22.32.30-Left-Cerebral-White-Matter_Ctrk100_AFQ_91.pdb');
fgrOT = fgRead(fgrOT);

FG = {fgrOR , fglOR, fglOT, fgrOT};

% Load dt6
dt = dtiLoadDt6(dt6);
t1 = niftiRead(dt.files.t1);

% load ROIs for Figure 3, but not Figure 4
dirROI = fullfile(SubDir,'dwi_2nd','ROIs');
roiList = {'Optic-Chiasm.mat','Rt-LGN4.mat','Lt-LGN4.mat','lh_V1_smooth3mm_NOT.mat','rh_V1_smooth3mm_NOT.mat'};

%% draw visual pathway figure using AFQ_render
% Fig4 A

% ORs
mrvNewGraphWin;hold on;

AFQ_RenderFibers(fgrOR, 'newfig', [0],'numfibers', 1000 ,'color', [0.854,0.65,0.125],'radius',[0.5,2]); %fg() = fg
AFQ_RenderFibers(fglOR, 'newfig', [0],'numfibers', 1000 ,'color', [0.854,0.65,0.125],'radius',[0.5,2]); %fg() = fg

% Occipital callosal fibers
% AFQ_RenderFibers(fg3, 'newfig', [0],'numfibers', 100 ,'color', [0.4, 0.7, 0.7],'radius',[0.5,2]); %fg() = fg

%Optic Tract
AFQ_RenderFibers(fglOT, 'newfig', [0],'numfibers', 50 ,'color', [0.67,0.27,0.51],'radius',[0.5,2]); %fg() = fg
AFQ_RenderFibers(fgrOT, 'newfig', [0],'numfibers', 50 ,'color', [0.67,0.27,0.51],'radius',[0.5,2]); %fg() = fg

% % add ROIs if you have the LGN
% theseROIS = 1:5;
% for k = theseROIS
%     Roi = dtiReadRoi(fullfile(dirROI, roiList{k}));
%     AFQ_RenderRoi(Roi);
% end

% T1w
AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);

% adjust figure
view(0 ,89);
set(gcf,'Color',[1 1 1])
set(gca,'Color',[1 1 1])
axis image
axis off
camlight('headlight');
title('Optic tract and optic radiation')
hold off;

%% Fig4 B
% Overlay the FA for this subject on the OR and OT

% Set the value for overlay to 'fa'
if(~exist('valName','var') || isempty(valName))
    valName = 'fa'; % 'fa','md','ad', and 'rd' are available. Change value range
end

mrvNewGraphWin;hold on;
for kk = 1:length(FG)
    % Get the FA values from the fiber group
    vals = dtiGetValFromFibers(dt.dt6,FG{kk},inv(dt.xformToAcpc),valName);
    
    rgb = vals2colormap(vals);
    switch kk
        case {1,2}
            AFQ_RenderFibers(FG{kk},'color',rgb,'crange',[0.3 0.7],'newfig',0,'numfibers',1000);
        case {3,4}
            AFQ_RenderFibers(FG{kk},'color',rgb,'crange',[0.3 0.7],'newfig',0);
    end
end

% Put T1w
t1 = niftiRead(dt.files.t1);
AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);

axis image, axis off, view(0,89)
cb = colorbar('location','eastoutside');
caxis([0.3 0.7])
T = get(cb,'Title'); set(T,'string','FA','FontSize',14);


%% Fig4 C
% Fa values averaged along tracts

mrvNewGraphWin; hold on;

for kk = 1:length(FG)
    % TractProfile along current tract
    TractProfile = SO_FiberValsInTractProfiles(FG{kk},dt,'AP',100,1);
    
    % params
    radius = 3;
    subdivs = 20;
    crange = [0.3 0.7];
    cmap    = 'jet';
    newfig = 0;
    
    % render core fiber with averaged FA values
    AFQ_RenderTractProfile(TractProfile.coords.acpc, radius, TractProfile.vals.fa, subdivs, cmap, crange, newfig)
end
% Put T1w
AFQ_AddImageTo3dPlot(t1, [0, 0, -30]);

axis image, axis off, view(0,89)
camlight('headlight');
title('Core fiber with averaged FA value')
% colorbar('off')
colorbar('location','eastoutside');
caxis([0.3 0.7])

%% End

