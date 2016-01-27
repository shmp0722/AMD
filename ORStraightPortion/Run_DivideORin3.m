function Run_DivideORin3(subID)

%
% both L and R optic radiation will be cut in 4 portions, such as MeyersLoop ,fgA, fgM, fgP.
% A fgM is maybe what we want to see.
%
% SO @ACH 2015.10
%



%%
[homeDir, subDir, AMD, AMD_Ctl, RP, Ctl,LHON,JMD] = SubJect;

if notDefined('subID')
    subID = 1:length(subDir);
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
    if ~exist(ORdirDivided); mkdir(ORdirDivided) ;end;
    
    % dt6
    dt6 =dtiLoadDt6(fullfile(SubDir,'/dwi_1st/dt6.mat'));
    
    % OR
%     try
    ROR = dir(fullfile(ORdir, '*Rt*MD4.pdb'));
    LOR = dir(fullfile(ORdir, '*Lt*MD4.pdb'));
    
    R_OR = fgRead(fullfile(ORdir,ROR.name));
    L_OR = fgRead(fullfile(ORdir,LOR.name));
    
    % R-OR
    if ~isempty(R_OR)|| length(R_OR.fibers)>1
        [MeyersLoop ,fgA, fgM, fgP] = DivideORin3(R_OR);
        
        MeyersLoop.name = 'ROR-MeyersLoop';
        fgA.name = 'ROR-Anterior';
        fgM.name = 'ROR-Middle';
        fgP.name = 'ROR-Posterior';
        
        % save files
%         fgWrite(MeyersLoop,fullfile(ORdirDivided,MeyersLoop.name),'mat')
%         fgWrite(fgA,fullfile(ORdirDivided,fgA.name),'mat')
%         fgWrite(fgM,fullfile(ORdirDivided,fgM.name),'mat')
%         fgWrite(fgP,fullfile(ORdirDivided,fgP.name),'mat')
        
        % Tract profile 
        MeyersLoop.fibers = MeyersLoop.fibers';
        TPMeyersLoop = SO_FiberValsInTractProfiles(MeyersLoop,dt6,'AP',50,1);
        TPMeyersLoop.subjectName= subDir{ii};
        TPMeyersLoop.ID   = ii;
%         TPMeyersLoop.fiberCurvature = dtiComputeFiberCurvature(MeyersLoop);
        
        fgA.fibers = fgA.fibers';
        TPfgA = SO_FiberValsInTractProfiles(fgA,dt6,'AP',50,1);
        TPfgA.subjectName= subDir{ii};
        TPfgA.ID   = ii;
%         TPfgA.fiberCurvature = dtiComputeFiberCurvature(fgA);

        
        fgM.fibers = fgM.fibers';
        TPfgM = SO_FiberValsInTractProfiles(fgM,dt6,'AP',50,1);
        TPfgM.subjectName= subDir{ii};
        TPfgM.ID   = ii;
%         TPfgM.fiberCurvature = dtiComputeFiberCurvature(fgM);

        
        fgP.fibers = fgP.fibers';
        TPfgP = SO_FiberValsInTractProfiles(fgP,dt6,'AP',50,1);
        TPfgP.subjectName= subDir{ii};
        TPfgP.ID   = ii;
%         TPfgP.fiberCurvature = dtiComputeFiberCurvature(fgP);

        
        % Keep TP in ACH structure
        ACH{ii,11}= TPMeyersLoop;
        ACH{ii,12}= TPfgA;
        ACH{ii,13}= TPfgM;
        ACH{ii,14}= TPfgP;
       
%         clear MeyersLoop fgA fgM fgP;
    end
    % L-OR
    if ~isempty(L_OR) || length(L_OR.fibers)>1
        [MeyersLoop ,fgA, fgM, fgP] = DivideORin3(L_OR);
        
        MeyersLoop.name = 'LOR-MeyersLoop';
        fgA.name = 'LOR-Anterior';
        fgM.name = 'LOR-Middle';
        fgP.name = 'LOR-Posterior';
        
        % save files
%         fgWrite(MeyersLoop,fullfile(ORdirDivided,MeyersLoop.name),'mat')
%         fgWrite(fgA,fullfile(ORdirDivided,fgA.name),'mat')
%         fgWrite(fgM,fullfile(ORdirDivided,fgM.name),'mat')
%         fgWrite(fgP,fullfile(ORdirDivided,fgP.name),'mat')
        
        % Tract profile
        MeyersLoop.fibers = MeyersLoop.fibers';
        TPMeyersLoop = SO_FiberValsInTractProfiles(MeyersLoop,dt6,'AP',50,1);
        TPMeyersLoop.subjectName= subDir{ii};
        TPMeyersLoop.ID   = ii;
%         TPMeyersLoop.fiberCurvature = dtiComputeFiberCurvature(MeyersLoop);

        
        fgA.fibers = fgA.fibers';
        TPfgA = SO_FiberValsInTractProfiles(fgA,dt6,'AP',50,1);
        TPfgA.subjectName= subDir{ii};
        TPfgA.ID   = ii;
%         TPfgA.fiberCurvature = dtiComputeFiberCurvature(fgA);

        
        fgM.fibers = fgM.fibers';
        TPfgM = SO_FiberValsInTractProfiles(fgM,dt6,'AP',50,1);
        TPfgM.subjectName= subDir{ii};
        TPfgM.ID   = ii;
%         TPfgM.fiberCurvature = dtiComputeFiberCurvature(fgM);

        
        fgP.fibers = fgP.fibers';
        TPfgP = SO_FiberValsInTractProfiles(fgP,dt6,'AP',50,1);
        TPfgP.subjectName= subDir{ii};
        TPfgP.ID   = ii;
%         TPfgP.fiberCurvature = dtiComputeFiberCurvature(fgP);

        
        % Keep TP in ACH structure
        ACH{ii,15}= MeyersLoop; 
        ACH{ii,16}= TPfgA;
        ACH{ii,17}= TPfgM;
        ACH{ii,18}= TPfgP;
%         clear MeyersLoop fgA fgM fgP;
    end
%     catch
%     end
end

%%
Results;
save ACH_1006 ACH
% save('ACH_1005.mat','ACH','-v7.3')


