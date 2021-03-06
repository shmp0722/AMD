function [Intsct,Central,Peripheral]=AMD_OverLapRate(saveROI,showfig)



%%
AFQdata = '/media/HDPC-UT/dMRI_data';

subs = {...
    'AMD-01-dMRI-Anatomy-dMRI'
    'AMD-02-YM-dMRI-Anatomy'
    'AMD-03-CK-68yo-dMRI-Anatomy'
    'AMD-04-KM-72yo-dMRI-Anatomy'
    'AMD-05-YH-84yo-dMRI-Anatomy'
    'AMD-06-KS-79yo-dMRI-Anatomy'
    'AMD-07-KT-dMRI-Anatomy'
    'AMD-08-YA-20150426'
    'AMD-Ctl01-HM-dMRI-Anatomy-2014-09-09'
    'AMD-Ctl02-YM-dMRI-Anatomy-2014-09-09'
    'AMD-Ctl03-TS-dMRI-Anatomy-2014-10-28'
    'AMD-Ctl04-AO-61yo-dMRI-Anatomy'
    'AMD-Ctl05-TM-71yo-dMRI-Anatomy'
    'AMD-Ctl06-YM-66yo-dMRI-Anatomy'
    'AMD-Ctl07-MS-61yo-dMRI-Anatomy'
    'AMD-Ctl08-HO-62yo-dMRI-Anatomy'
    'AMD-Ctl09-KH-70yo-dMRI-Anatomy-dMRI'
    'AMD-Ctl10-TH-65yo-dMRI-Anatomy-dMRI'
    'AMD-Ctl11-YMS-64yo-dMRI-Anatomy'
    'AMD-Ctl12-YT-f59yo-20150222'};

%% would you like to see a figure?
if notDefined('showfig')
    showfig = 0;
end

%% boxes

T = table;
ID =1:20;
T.ID = ID';
% 
% FA = nan(length(subs),1);
% MD = FA;
% AD = FA;
% RD = FA;
% S = struct;

%% Make OR roi and save all rois
parfor ii = 1:length(subs)
    SubDir = fullfile(AFQdata,subs{ii});
    OTdir  = fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K');
    ORdir  = fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_divided');
    
    % dirROI = fullfile(SubDir,'/dwi_2nd/ROIs');
    dt6 =dtiLoadDt6( fullfile(SubDir,'/dwi_1st/dt6.mat'));
    
    or=dir(fullfile(ORdir,'*_MD4.pdb'));
    
    WrongOR = dir(fullfile(ORdir,'*MD*MD*'));
    for Wr = 1:length(WrongOR)
        delete(fullfile(ORdir,WrongOR(Wr).name))
    end
    
    
%     if length(or) ==6
        % Load fiber groups
        ROR03 = dir(fullfile(ORdir, '*Ecc0to3*-Lh_NOT_MD4.pdb'));
        LOR03= dir(fullfile(ORdir, '*Ecc0to3*-Rh_NOT_MD4.pdb'));
        
        if ii==19
            ROR1530 = dir(fullfile(ORdir, '*15to30*-Lh_NOT_MD3.pdb'));
            LOR1530= dir(fullfile(ORdir, '*15to30*-Rh_NOT_MD3.pdb'));
        else
            ROR1530 = dir(fullfile(ORdir, '*15to30*-Lh_NOT_MD4.pdb'));
            LOR1530= dir(fullfile(ORdir, '*15to30*-Rh_NOT_MD4.pdb'));
        end
        
        ROR3090 = dir(fullfile(ORdir, '*30to90*-Lh_NOT_MD4.pdb'));
        LOR3090 = dir(fullfile(ORdir, '*30to90*-Rh_NOT_MD4.pdb'));
        
%     else
%         sprintf('- few or too much fiber groups, check OR directory \n \n- %s',ORdir)
%         return
%     end
    
    
    R_OR03 = fgRead(fullfile(ORdir,ROR03.name));
    L_OR03 = fgRead(fullfile(ORdir,LOR03.name));
    
    R_OR1530 = fgRead(fullfile(ORdir,ROR1530.name));
    L_OR1530 = fgRead(fullfile(ORdir,LOR1530.name));
    
    R_OR3090 = fgRead(fullfile(ORdir,ROR3090.name));
    L_OR3090 = fgRead(fullfile(ORdir,LOR3090.name));
    
    % make fiber roi and unite coordinates
    R_OR03_roi = dtiCreateRoiFromFibers(R_OR03);
    R_OR03_roi.coords = unique(R_OR03_roi.coords,'rows');
    
    L_OR03_roi = dtiCreateRoiFromFibers(L_OR03);
    L_OR03_roi.coords = unique(L_OR03_roi.coords,'rows');
    
    R_OR1530_roi = dtiCreateRoiFromFibers(R_OR1530);
    R_OR1530_roi.coords = unique(R_OR1530_roi.coords,'rows');
    
    L_OR1530_roi = dtiCreateRoiFromFibers(L_OR1530);
    L_OR1530_roi.coords = unique(L_OR1530_roi.coords,'rows');
    
    R_OR3090_roi = dtiCreateRoiFromFibers(R_OR3090);
    R_OR3090_roi.coords = unique(R_OR3090_roi.coords,'rows');
    
    L_OR3090_roi = dtiCreateRoiFromFibers(L_OR3090);
    L_OR3090_roi.coords = unique(L_OR3090_roi.coords,'rows');
    
    % merge both hemispheres
    OR_03 =    [L_OR03_roi.coords;R_OR03_roi.coords];
    OR_1530 =  [L_OR1530_roi.coords;R_OR1530_roi.coords];
    OR_3090 =  [L_OR3090_roi.coords;R_OR3090_roi.coords];

    %
%     AFQ_RenderRoi(dtiNewRoi([],[],intersect(OR_03,OR_1530,'rows')),[1 0 0])
%     AFQ_RenderRoi(dtiNewRoi([],[],setdiff(OR_03,OR_1530,'rows')),[0 0 1])

    
    % overlapping rate
%     OR03vs1530_stdf(ii)   =  length(setdiff(OR_03,OR_1530,'rows'))/length(OR_03)*100;
    OR03vs1530_int(ii)   =  length(intersect(OR_03,OR_1530,'rows'))...
        /length(unique([OR_03;OR_1530],'rows'))*100;
    
%     OR03vs3090_stdf(ii)   = length(setdiff(OR_03,OR_3090,'rows'))/length(OR_03)*100;
    OR03vs3090_int(ii)   =   length(intersect(OR_03,OR_3090,'rows'))...
        /length(unique([OR_03;OR_3090],'rows'))*100;
    
%     OR1530vs3090_stdf(ii) = length(setdiff(OR_1530,OR_3090,'rows'))/length(OR_1530)*100;
    OR1530vs3090_int(ii) = length(intersect(OR_1530,OR_3090,'rows'))...
        /length(unique([OR_1530;OR_3090],'rows'))*100;

    
end

% edit a tabel
% T.OR03vs1530_stdf = OR03vs1530_stdf';
T.OR03vs1530_int  = OR03vs1530_int';
% T.OR03vs3090_stdf = OR03vs3090_stdf';
T.OR03vs3090_int  = OR03vs3090_int';
% T.OR1530vs3090_stdf = OR1530vs3090_stdf';
T.OR1530vs3090_int  = OR1530vs3090_int';

%% diiferenciate
T.dif_03vs1530    = (100-OR03vs1530_int)';
T.dif_03vs3090    = (100-OR03vs3090_int)';
T.dif_1530vs3090  = (100-OR1530vs3090_int)';

%%
cd /home/ganka/git/AMD/DiffusionMeasure/voxelwise2
save T3 T

