function Run_DivideORin3_2(subID)

%
% both L and R optic radiation will be cut in 4 portions, such as MeyersLoop ,fgA, fgM, fgP.
% A fgM is maybe what we want to see.
%
% SO @ACH 2015.10
%



%%
[homeDir, subDir, AMD, AMD_Ctl, RP, Ctl,LHON,JMD] = SubJect;

if notDefined('subID')
    subID = [AMD, AMD_Ctl, RP, Ctl,LHON,JMD];
end

% if notDefined('ACH')
%     ACH = cell(length(subDir),10);
% end

% Load ACH data
TPdata = '/media/HDPC-UT/dMRI_data/Results/ACH_0827.mat';
load(TPdata);


%%
for ii = subID
    SubDir=fullfile(homeDir,subDir{ii});
    ORdir= fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_100K');
    
    ORdirDivided= fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_Portions');
   
%     if ~exist(ORdirDivided); mkdir(ORdirDivided) ;end;
    
    % dt6
    dt6 = dtiLoadDt6(fullfile(SubDir,'/dwi_1st/dt6.mat'));
    
    % load L-ORs
    L_MeyersLoop = fgRead(fullfile(ORdirDivided, 'LOR-MeyersLoop.mat'));
    L_Anterior = fgRead(fullfile(ORdirDivided, 'LOR-Anterior.mat'));
    L_Middle = fgRead(fullfile(ORdirDivided, 'LOR-Middle.mat'));
    L_Posterior = fgRead(fullfile(ORdirDivided, 'LOR-Posterior.mat'));    
    
    L_MeyersLoop.fibers = L_MeyersLoop.fibers';
    L_Anterior.fibers = L_Anterior.fibers';
    L_Middle.fibers = L_Middle.fibers';
    L_Posterior.fibers = L_Posterior.fibers';
    
    % Tract profile
    TPMeyersLoop = SO_FiberValsInTractProfiles(L_MeyersLoop,dt6,'AP',50,1);
    TPMeyersLoop.subjectName= subDir{ii};
    TPMeyersLoop.ID   = ii;
    
    TPfgA = SO_FiberValsInTractProfiles(L_Anterior,dt6,'AP',50,1);
    TPfgA.subjectName= subDir{ii};
    TPfgA.ID   = ii;
    
    TPfgM = SO_FiberValsInTractProfiles(L_Middle,dt6,'AP',50,1);
    TPfgM.subjectName= subDir{ii};
    TPfgM.ID   = ii;
    
    TPfgP = SO_FiberValsInTractProfiles(L_Posterior,dt6,'AP',50,1);
    TPfgP.subjectName= subDir{ii};
    TPfgP.ID   = ii;
    
    % Keep TP in ACH structure
    ACH{ii,11}= TPMeyersLoop;
    ACH{ii,12}= TPfgA;
    ACH{ii,13}= TPfgM;
    ACH{ii,14}= TPfgP;
  
 % load R-ORs
    R_MeyersLoop = fgRead(fullfile(ORdirDivided, 'ROR-MeyersLoop.mat'));
    R_Anterior = fgRead(fullfile(ORdirDivided, 'ROR-Anterior.mat'));
    R_Middle = fgRead(fullfile(ORdirDivided, 'ROR-Middle.mat'));
    R_Posterior = fgRead(fullfile(ORdirDivided, 'ROR-Posterior.mat'));    
    
    R_MeyersLoop.fibers = R_MeyersLoop.fibers';
    R_Anterior.fibers = R_Anterior.fibers';
    R_Middle.fibers = R_Middle.fibers';
    R_Posterior.fibers = R_Posterior.fibers';
    
    % Tract profile
    TPMeyersLoop = SO_FiberValsInTractProfiles(R_MeyersLoop,dt6,'AP',50,1);
    TPMeyersLoop.subjectName= subDir{ii};
    TPMeyersLoop.ID   = ii;
    
    TPfgA = SO_FiberValsInTractProfiles(R_Anterior,dt6,'AP',50,1);
    TPfgA.subjectName= subDir{ii};
    TPfgA.ID   = ii;
    
    TPfgM = SO_FiberValsInTractProfiles(R_Middle,dt6,'AP',50,1);
    TPfgM.subjectName= subDir{ii};
    TPfgM.ID   = ii;
    
    TPfgP = SO_FiberValsInTractProfiles(R_Posterior,dt6,'AP',50,1);
    TPfgP.subjectName= subDir{ii};
    TPfgP.ID   = ii;
        
        % Keep TP in ACH structure
        ACH{ii,15}= TPMeyersLoop; 
        ACH{ii,16}= TPfgA;
        ACH{ii,17}= TPfgM;
        ACH{ii,18}= TPfgP;
%         clear MeyersLoop fgA fgM fgP;
%     end
%     catch
%     end
end

%%
Results;
save ACH_1008 ACH
% save('ACH_1005.mat','ACH','-v7.3')


