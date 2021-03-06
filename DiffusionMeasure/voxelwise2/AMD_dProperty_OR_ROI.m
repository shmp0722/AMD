function [Intsct,Central,Peripheral]=AMD_dProperty_OR_ROI(saveROI,showfig)



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
Intsct = struct;
Central = struct;
Peripheral = struct;
% 
% FA = nan(length(subs),1);
% MD = FA;
% AD = FA;
% RD = FA;

%% Make OR roi and save all rois
for ii = 1:length(subs)
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
    
    
    % Make new ROI
    R_intersect =  dtiNewRoi('R_intersect',[], intersect(R_OR03_roi.coords,R_OR3090_roi.coords,'rows')) ;
    R_03_setdiff  = dtiNewRoi('R_03_setdiff',[], setdiff(R_OR03_roi.coords,R_OR3090_roi.coords,'rows')) ;
    R_90_setdiff  = dtiNewRoi('R_90_setdiff',[], setdiff(R_OR3090_roi.coords,R_OR03_roi.coords,'rows')) ;
    
    L_intersect =  dtiNewRoi('L_intersect',[], intersect(L_OR03_roi.coords,L_OR3090_roi.coords,'rows')) ;
    L_03_setdiff  = dtiNewRoi('L_03_setdiff',[], setdiff(L_OR03_roi.coords,L_OR3090_roi.coords,'rows')) ;
    L_90_setdiff  = dtiNewRoi('L_90_setdiff',[], setdiff(L_OR3090_roi.coords,L_OR03_roi.coords,'rows')) ;
    
    
    
    % Render a figure
    if showfig == 1
        %            C = lines(6)
        C = hot(6);
        figure; hold on;
        % right
        AFQ_RenderRoi(R_intersect,C(1,:))
        AFQ_RenderRoi(R_03_setdiff,C(2,:))
        AFQ_RenderRoi(R_90_setdiff,C(3,:))
        % left
        AFQ_RenderRoi(L_intersect,C(1,:))
        AFQ_RenderRoi(L_03_setdiff,C(2,:))
        AFQ_RenderRoi(L_90_setdiff,C(3,:))
        
        ni=niftiRead(dt6.files.t1);
        AFQ_AddImageTo3dPlot(ni,[0 ,0 ,-25])
        camlight left
        
        L1 = line([60,70],[-110,-110],[-25,-25]);
        set(L1,'Linewidth',2,'color',[1,1,1])
        
        L2 = line([65,65],[-105,-115],[-25,-25]);
        set(L2,'Linewidth',2,'color',[1,1,1])
        
        title(sprintf('%s',subs{ii}(1:9)));
        axis off
        hold off;
        
        saveas(gca,fullfile('/home/ganka/git/AMD/Figure_OR',[sprintf('%s',subs{ii}(1:9)),'_segmentedOR.eps']),'psc2');
    end
    
    %% save ROIs
    if notDefined('saveROI'); saveROI = 1;end
    
    %%
    if saveROI ==1
        ROIdir = fullfile(SubDir,'dwi_1st/fgROIs');
        
        if ~exist(ROIdir,'dir');mkdir(ROIdir);end
        rois ={...
            R_intersect,R_03_setdiff,R_90_setdiff,...
            L_intersect,L_03_setdiff,L_90_setdiff,...
            };
        
        for  kk = 1:length(rois)
            dtiWriteRoi(rois{kk},[fullfile(ROIdir,rois{kk}.name),'.mat'])
        end
    end
    
    %%
    rois ={...
        R_intersect,R_03_setdiff,R_90_setdiff,...
        L_intersect,L_03_setdiff,L_90_setdiff};
    
    %     for kk = 1:3%length(rois)
    % calc properties
    [faR,mdR,adR,rdR]  = dtiGetValFromTensors(dt6.dt6, rois{1}.coords, inv(dt6.xformToAcpc),'fa md ad rd');
    [faL,mdL,adL,rdL]  = dtiGetValFromTensors(dt6.dt6, rois{4}.coords, inv(dt6.xformToAcpc),'fa md ad rd');
    
    %     Intsct.FA(ii,1)=nanmean([faR;faL]);
    %     Intsct.AD(ii,1)=nanmean([adR;adL]);
    %     Intsct.RD(ii,1)=nanmean([rdR;rdL]);
    %     Intsct.MD(ii,1)=nanmean([mdR;mdL]);
    
    Intsct.FA(ii,1:length([faR;faL]))=[faR;faL];
    Intsct.AD(ii,1:length([adR;adL]))=[adR;adL];
    Intsct.RD(ii,1:length([rdR;rdL]))=[rdR;rdL];
    Intsct.MD(ii,1:length([rdR;rdL]))=[mdR;mdL];
    
    [faR,mdR,adR,rdR]  = dtiGetValFromTensors(dt6.dt6, rois{2}.coords, inv(dt6.xformToAcpc),'fa md ad rd');
    [faL,mdL,adL,rdL]  = dtiGetValFromTensors(dt6.dt6, rois{5}.coords, inv(dt6.xformToAcpc),'fa md ad rd');
    
    %     Central.FA(ii,1)=nanmean([faR;faL]);
    %     Central.AD(ii,1)=nanmean([adR;adL]);
    %     Central.RD(ii,1)=nanmean([rdR;rdL]);
    %     Central.MD(ii,1)=nanmean([mdR;mdL]);
    
    Central.FA(ii,1:length([faR;faL]))=([faR;faL]);
    Central.AD(ii,1:length([faR;faL]))=[adR;adL];
    Central.RD(ii,1:length([faR;faL]))=[rdR;rdL];
    Central.MD(ii,1:length([faR;faL]))=[mdR;mdL];
    
    [faR,mdR,adR,rdR]  = dtiGetValFromTensors(dt6.dt6, rois{3}.coords, inv(dt6.xformToAcpc),'fa md ad rd');
    [faL,mdL,adL,rdL]  = dtiGetValFromTensors(dt6.dt6, rois{6}.coords, inv(dt6.xformToAcpc),'fa md ad rd');
    
    Peripheral.FA(ii,1:length([faR;faL]))=([faR;faL]);
    Peripheral.AD(ii,1:length([faR;faL]))=([adR;adL]);
    Peripheral.RD(ii,1:length([faR;faL]))=([rdR;rdL]);
    Peripheral.MD(ii,1:length([faR;faL]))=([mdR;mdL]);
    
end
%%
% Central.FA(Central.FA==0) = nan;

%%
mkdir /home/ganka/git/AMD/DiffusionMeasure/voxelwise2
cd /home/ganka/git/AMD/DiffusionMeasure/voxelwise2
save Central Central
save Intsct Intsct
save Peripheral Peripheral


