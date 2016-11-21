function AMD_Overlap_OR(savefig)




% %% load raw data and subjects
% load /home/ganka/git/AMD/DiffusionMeasure/ACH_0210.mat
%
% load /home/ganka/git/AMD/afq/afq_21-Sep-2016.mat
%
% AMD = 1:8;
% AMD_Ctl = 9:20;
%
% %% argument check
% fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
%     'LOR30-90','ROR30-90'};
% if notDefined('fibID')
%     fibID = 1;
% end
%
% if notDefined('SavePath')
%     SavePath = pwd;
% end
%
% %%
%
% unique(round([ACH{subID,fibID}.coords.acpc,ACH{subID,fibID+1}.coords.acpc],0),'rows');
%
%
% %%
% % AFQ_RenderFibers(ACH{1,5}.coords.acpc(:))
% figure; hold on;
%
% % purple r 160 g 32 b 240
% % blue   rgb [0 0 255]
% % color_p = [160/255 32/255 240/255];
%
% % AFQ_RenderFibers(ACH{1,5}.coords.acpc)
%
% AFQ_RenderTractProfile(ACH{1,5}.coords.acpc,[],[0 0 1])
% AFQ_RenderTractProfile(ACH{1,7}.coords.acpc,[],[80/255 247.5/255 ])
% AFQ_RenderTractProfile(ACH{1,5}.coords.acpc,[],[160/255 32/255 240/255])
%
% %% get values and merge both hemisphere
%
% OR03 = fgRead(afq.files.fibers.LORC_MD4);

%%
[dMRI, List, AMD, AMD_C, JMD_C, RP, Ctl,LHON,JMD_all] = SubJect2;


%% Make OR roi and save all rois
for ii = 1:length(subs)
    SubDir = fullfile(dMRI,List{ii});
    %     OTdir  = fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K');
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
    LOR3090= dir(fullfile(ORdir, '*30to90*-Rh_NOT_MD4.pdb'));
    
    %
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
    %     if showfig == 1
    
    
   
    
    
    figure; hold on;
    
    % color definition
    C(1,:) = [0, 0, 1];
    C(2,:) = [0, 80/255, 247.5/255 ];
    C(3,:) = [160/255, 32/255, 240/255];
    
    % right
    AFQ_RenderRoi(R_intersect,C(1,:))
    AFQ_RenderRoi(R_03_setdiff,C(2,:))
    AFQ_RenderRoi(R_90_setdiff,C(3,:))
    % left
    AFQ_RenderRoi(L_intersect,C(1,:))
    AFQ_RenderRoi(L_03_setdiff,C(2,:))
    AFQ_RenderRoi(L_90_setdiff,C(3,:))
    
    ni=niftiRead(dt6.files.t1);
    Z = -30;
    AFQ_AddImageTo3dPlot(ni,[0 ,0 ,Z])
    AFQ_AddImageTo3dPlot(ni,[-5 ,0 ,0])
    
    %         AFQ_AddImageTo3dPlot(ni,[0 ,0 ,5])
    
    axis auto
    axis equal

    camlight left
    
    L1 = line([-60,-70],[-110,-110],[Z,Z]);
    set(L1,'Linewidth',2,'color',[1,1,1])
    
    L2 = line([-65,-65],[-105,-115],[Z,Z]);
    set(L2,'Linewidth',2,'color',[1,1,1])
    
    title(sprintf('%s',List{ii}(1:9)));
    axis off
    hold off;
    
    if savefig==1;
        saveas(gca,fullfile('/home/ganka/git/AMD/Figure_OR',[sprintf('%s',List{ii}(1:9)),'_segmentedOR.eps']),'psc2');
    end
end
return
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


