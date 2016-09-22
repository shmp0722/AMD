function GetReadytoAFQ

% Get ready to run AFQ_AddNewFibers

[dMRI, List, AMD, AMD_Ctl, RP, Ctl,LHON,JMD] = SubJect;

Done = zeros(length(List),2);
%% Optic tract
for ii = 1:length(List)
    s1 = dir(fullfile(dMRI,List{ii},'dwi_1st/fibers/OT_MD32/LOT*'));
    s2 = dir(fullfile(dMRI,List{ii},'dwi_1st/fibers/OT_MD32/ROT*'));
    
    if ~isempty(s1);
        OT1 = fgRead(fullfile(dMRI,List{ii},'dwi_1st/fibers/OT_MD32',s1.name));
        OT1.name = 'LOT_MD32';
        OT1.pathwayInfo =[];
        
        % duplicate fibers to be more than 6 fibers
        NumFibers = length(OT1.fibers);
        while length(OT1.fibers)<6;
            for jj = 1:NumFibers
                OT1.fibers{length(OT2.fibers)+1} = OT1.fibers{jj};
            end
        end
        Done(ii,1) = 1;
        fgWrite(OT1,fullfile(dMRI,List{ii},'dwi_1st/fibers', [OT1.name,'.mat']))
    else
        sprintf('%s should be checked %d',List{ii},ii)
    end
    
    
    if ~isempty(s2);
        OT2 = fgRead(fullfile(dMRI,List{ii},'dwi_1st/fibers/OT_MD32',s2.name));
        OT2.name = 'ROT_MD32';
        OT2.pathwayInfo =[];
        
        % duplicate fibers to be more than 6 fibers
        NumFibers = length(OT2.fibers);
        while length(OT2.fibers)<6;
            for jj = 1:NumFibers
                OT2.fibers{length(OT2.fibers)+1} = OT2.fibers{jj};
            end
        end
        fgWrite(OT2,fullfile(dMRI,List{ii},'dwi_1st/fibers', [OT2.name,'.mat']))
        
    end
    clear s1 s2
end

%% Optic radiation
for ii = 1:length(List)
    
    l1 = dir(fullfile(dMRI,List{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc0to3*MD4.pdb'));
    l2 = dir(fullfile(dMRI,List{ii},'dwi_1st/fibers/conTrack/OR_divided/*lh_Ecc30to90*MD4.pdb'));
    
    r1 = dir(fullfile(dMRI,List{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc0to3*MD4.pdb'));
    r2 = dir(fullfile(dMRI,List{ii},'dwi_1st/fibers/conTrack/OR_divided/*rh_Ecc30to90*MD4.pdb'));
    
    if ~isempty(l1);
        LORC = fgRead(fullfile(dMRI,List{ii},'dwi_1st/fibers/conTrack/OR_divided',l1.name));
        LORC.name = 'LORC_MD4';
        LORC.pathwayInfo =[];
        
        fgWrite(LORC,fullfile(dMRI,List{ii},'dwi_1st/fibers', [LORC.name,'.mat']))
    end
    
    if ~isempty(l2);
        LORP = fgRead(fullfile(dMRI,List{ii},'dwi_1st/fibers/conTrack/OR_divided',l2.name));
        LORP.name = 'LORP_MD4';
        LORP.pathwayInfo =[];
        fgWrite(LORP,fullfile(dMRI,List{ii},'dwi_1st/fibers', [LORP.name,'.mat']))
    end
    
    if ~isempty(r1);
        
        RORC = fgRead(fullfile(dMRI,List{ii},'dwi_1st/fibers/conTrack/OR_divided',r1.name));
        RORC.name = 'RORC_MD4';
        RORC.pathwayInfo =[];
        fgWrite(RORC,fullfile(dMRI,List{ii},'dwi_1st/fibers', [RORC.name,'.mat']))
    end
    
    if ~isempty(r2)
        RORP = fgRead(fullfile(dMRI,List{ii},'dwi_1st/fibers/conTrack/OR_divided',r2.name));
        RORP.name = 'RORP_MD4';
        RORP.pathwayInfo =[];
        fgWrite(RORP,fullfile(dMRI,List{ii},'dwi_1st/fibers', [RORP.name,'.mat']))
    end
   
end

%% Copying ROI to "ROIs" under dt6 directory 
for ii = 1:length(List)
ROIS  = fullfile(dMRI,List{ii},'fs_Retinotopy2/');
dest  = fullfile(dMRI,List{ii},'dwi_1st/ROIs');
copyfile(ROIS,dest)
end

    
