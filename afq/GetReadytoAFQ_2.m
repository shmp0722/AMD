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
    l1 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc0to3*MD4.pdb'));
%     l3 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc3to30*MD4.pdb'));
    l2 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc30to90*MD4.pdb'));
    
    r1 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc0to3*MD4.pdb'));
%     r3 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc3to30*MD4.pdb'));
    r2 = dir(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc30to90*MD4.pdb'));
    
    LORC = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',l1.name));
    LORC.name = 'LORC_MD4';
    LORC.pathwayInfo =[];
    
    LORP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',l2.name));
    LORP.name = 'LORP_MD4';
    LORP.pathwayInfo =[];
    
    RORC = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',r1.name));
    RORC.name = 'RORC_MD4';
    RORC.pathwayInfo =[];
    
    RORP = fgRead(fullfile(dMRI,subs{ii},'dwi_1st/fibers/conTrack/OR_divided',r2.name));
    RORP.name = 'RORP_MD4';
    RORP.pathwayInfo =[];
    
    
    % wright fiber group to under fiber directory
    fgWrite(LORC,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LORC.name,'.mat']))
    fgWrite(LORP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LORP.name,'.mat']))
%     fgWrite(LORM,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [LORM.name,'.mat']))
    
    fgWrite(RORC,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [RORC.name,'.mat']))
    fgWrite(RORP,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [RORP.name,'.mat']))
%     fgWrite(RORM,fullfile(dMRI,subs{ii},'dwi_1st/fibers', [RORM.name,'.mat']))
    
end



