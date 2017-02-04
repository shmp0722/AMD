function GetReadytoAFQ_2

% Get ready to run AFQ_AddNewFibers


%%
% dMRI = '/media/HDPC-UT/dMRI_data';

[dMRI, List, AMD, AMD_Ctl, RP, Ctl,LHON,JMD] = SubJect;

subs = List;

%% Optic radiation
for ii = 21:length(List)
    fibDir = fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_100K');
    s1 = dir(fullfile(fibDir,'*Lt*MD4*'));
    s2 = dir(fullfile(fibDir,'*Rt*MD4*'));
    
    LOR1 = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_100K',s1.name));
    LOR1.name = 'LOR_MD4';
    LOR1.pathwayInfo =[];
    
    ROR1 = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_100K',s2.name));
    ROR1.name = 'ROR_MD4';
    ROR1.pathwayInfo =[];
    
    fgWrite(LOR1,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LOR1.name,'.mat']))
    fgWrite(ROR1,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [ROR1.name,'.mat']))
end

%% Eccentricity Optic radiation
for ii = 1:20
    if exist(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*NOT*NOT*','file'))
        delete fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*NOT*NOT*'
    end
    l1 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc0to3*MD4.pdb'));
%     l3 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc3to30*MD4.pdb'));
    l2 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc30to90*MD4.pdb'));
    
    r1 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc0to3*MD4.pdb'));
%     r3 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc3to30*MD4.pdb'));
    r2 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc30to90*MD4.pdb'));
    
    LORMP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',l1.name));
    LORMP.name = 'LORC_MD4';
    LORMP.pathwayInfo =[];
    
    LORP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',l2.name));
    LORP.name = 'LORP_MD4';
    LORP.pathwayInfo =[];
    
    RORMP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',r1.name));
    RORMP.name = 'RORC_MD4';
    RORMP.pathwayInfo =[];
    
    RORP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',r2.name));
    RORP.name = 'RORP_MD4';
    RORP.pathwayInfo =[];
    
    
    % wright fiber group to under fiber directory
    fgWrite(LORMP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LORMP.name,'.mat']))
    fgWrite(LORP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LORP.name,'.mat']))
%     fgWrite(LORM,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LORM.name,'.mat']))
    
    fgWrite(RORMP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [RORMP.name,'.mat']))
    fgWrite(RORP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [RORP.name,'.mat']))
%     fgWrite(RORM,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [RORM.name,'.mat']))
    
end

%% Eccentricity Optic radiation
for ii = 1:20
    
   cd(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided'))
   
   delete '*NOT*NOT*'
   
    l1 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc15to30*MD3.pdb'));
%     l3 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc3to30*MD4.pdb'));
%     l2 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc30to90*MD4.pdb'));
    
    r1 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc15to30*MD3.pdb'));
%     r3 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc3to30*MD4.pdb'));
%     r2 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc30to90*MD4.pdb'));
    
    LORMP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',l1.name));
    LORMP.name = 'LORMP_MD3';
    LORMP.pathwayInfo =[];
    
%     LORP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',l2.name));
%     LORP.name = 'LORP_MD4';
%     LORP.pathwayInfo =[];
    
    RORMP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',r1.name));
    RORMP.name = 'RORMP_MD3';
    RORMP.pathwayInfo =[];
    
%     RORP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',r2.name));
%     RORP.name = 'RORP_MD4';
%     RORP.pathwayInfo =[];
%     
    
    % wright fiber group to under fiber directory
    fgWrite(LORMP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LORMP.name,'.mat']))
%     fgWrite(LORP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LORP.name,'.mat']))
%     fgWrite(LORM,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LORM.name,'.mat']))
    
    fgWrite(RORMP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [RORMP.name,'.mat']))
%     fgWrite(RORP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [RORP.name,'.mat']))
%     fgWrite(RORM,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [RORM.name,'.mat']))
    
end

%%
%% Eccentricity Optic radiation
for ii = 1:20
    l1 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc0to3*MD3.pdb'));
%     l3 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc3to30*MD4.pdb'));
    l2 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc30to90*MD3.pdb'));
    
    r1 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc0to3*MD3.pdb'));
%     r3 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc3to30*MD4.pdb'));
    r2 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc30to90*MD3.pdb'));
    
    if length(l1)>1
        LORMP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',l1(1).name));
    else
        LORMP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',l1.name));
    end
    LORMP.name = 'LORC_MD3';
    LORMP.pathwayInfo =[];
    
    if length(l2)>1
    LORP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',l2(1).name));
    else 
            LORP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',l2.name));
    end
    LORP.name = 'LORP_MD3';
    LORP.pathwayInfo =[];
    
    if length(r1)>1
        RORMP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',r1(1).name));
    else
        RORMP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',r1.name));
    end
    RORMP.name = 'RORC_MD3';
    RORMP.pathwayInfo =[];
    
    if length(r2)>1
        RORP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',r2(1).name));
    else
        RORP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',r2.name));
    end
    RORP.name = 'RORP_MD3';
    RORP.pathwayInfo =[];
    
    
    % wright fiber group to under fiber directory
    fgWrite(LORMP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LORMP.name,'.mat']))
    fgWrite(LORP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LORP.name,'.mat']))
%     fgWrite(LORM,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LORM.name,'.mat']))
    
    fgWrite(RORMP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [RORMP.name,'.mat']))
    fgWrite(RORP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [RORP.name,'.mat']))
%     fgWrite(RORM,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [RORM.name,'.mat']))
    
end



