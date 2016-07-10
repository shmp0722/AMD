function ACH = DiffusionMeasure

%　ACH構造の中に、Diffusion　Propertiesを計算して格納。
% 日本語で書けちゃった。
%　
% SO@ACH 2015.8
%

%%
[homeDir, subDir] = SubJect;

if notDefined('subID')
    subID = 1:length(subDir);
end

if notDefined('ACH')
    ACH = cell(length(subDir),10);
end

%%
for ii = subID
    SubDir=fullfile(homeDir,subDir{ii});
    OTdir = fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K');
    ORdir= fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_100K');
%     ORdirDivide= fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_divided');

    
    % dirROI = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt6 =dtiLoadDt6( fullfile(SubDir,'/dwi_1st/dt6.mat'));
    
    %% Load fiber groups
    % Optic tract
    ROT_Name = fullfile(OTdir,'*Rt-LGN4*Ctrk100_AFQ_*');
    ROT = dir(ROT_Name);
    LOT_Name = fullfile(OTdir,'*Lt-LGN4*Ctrk100_AFQ_*');
    LOT = dir(LOT_Name);
    
    % Load OT
    L_OT = fgRead(fullfile(OTdir,LOT(length(LOT)).name));    
    R_OT = fgRead(fullfile(OTdir,ROT(length(ROT)).name));
    
    % OR
    ROR = dir(fullfile(ORdir, '*Rt*MD4.pdb'));
    LOR = dir(fullfile(ORdir, '*Lt*MD4.pdb'));
    
    R_OR = fgRead(fullfile(ORdir,ROR.name));
    L_OR = fgRead(fullfile(ORdir,LOR.name));    
    
    %% 
    % L-OT
    TP = SO_FiberValsInTractProfiles(L_OT,dt6,'AP',50,1);
    TP.subjectName= subDir{ii};
    TP.ID   = ii;
   
    % R-OT
    TP2 = SO_FiberValsInTractProfiles(R_OT,dt6,'AP',50,1);
    TP2.subjectName= subDir{ii};
    TP2.ID   = ii;
    
    % L-OR
    TP3 = SO_FiberValsInTractProfiles(L_OR,dt6,'AP',100,1);
    TP3.subjectName= subDir{ii};
    TP3.ID   = ii;
    
    % L-OR
    TP4 = SO_FiberValsInTractProfiles(R_OR,dt6,'AP',100,1);
    TP4.subjectName= subDir{ii};
    TP4.ID   = ii;
    
    % Keep TP in ACH structure
    ACH{ii,1}= TP; 
    ACH{ii,2}= TP2;
    ACH{ii,3}= TP3;
    ACH{ii,4}= TP4;   
    clear TP TP2 TP3 TP4  
end
Results
save ACH0817 ACH


%%
[homeDir, subDir, AMD, AMD_Ctl, RP, Ctl] = SubJect;
% 
% if notDefined('subID')
%     subID = 1:length(subDir);
% end
% 
% Cell = cell(length(subDir),6);

Results
load ACH_0827

%% add divided fibers
for ii = 25;
    
    SubDir=fullfile(homeDir,subDir{ii});
    if ii == 19;
        ORdirDivide= fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_divided');
    else
        ORdirDivide= fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_divided');
    end

    % dirROI = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt6 =dtiLoadDt6( fullfile(SubDir,'/dwi_1st/dt6.mat'));
    
    % OR
    if exist(ORdirDivide,'dir')
    ROR = dir(fullfile(ORdirDivide, '*Rt*MD4.pdb'));
    LOR = dir(fullfile(ORdirDivide, '*Lt*MD4.pdb'));    
    
        if  length(ROR)==3,
            for kk = 1:3
                RORs{kk} = fgRead(fullfile(ORdirDivide,ROR(kk).name));
                LORs{kk} = fgRead(fullfile(ORdirDivide,LOR(kk).name));
                                
                % LOR
                LTP{kk} = SO_FiberValsInTractProfiles(LORs{kk},dt6,'AP',50,1);
                LTP{kk}.subjectName= subDir{ii};
                LTP{kk}.ID   = ii;
                
                % ROR
                RTP{kk} = SO_FiberValsInTractProfiles(RORs{kk},dt6,'AP',50,1);
                RTP{kk}.subjectName= subDir{ii};
                RTP{kk}.ID   = ii;
                
                %%
                Cell{ii,2*kk-1} = LTP{kk}; 
                Cell{ii,2*kk}   = RTP{kk};
            end
        end
    end

    % 
    for k = 1:6
        ACH{ii,k+4} = Cell{ii,k};
    end
end
%%

%%
save ACH_0210 ACH
