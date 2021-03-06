function AnatomyFigure

%
% The figure shows segmented OR organization.
%
%
%
% SO@ACH 2016.09.06

%%
home = '/media/USB_HDD1/dMRI_data/AMD-01-dMRI-Anatomy-dMRI';

%% load dt6

dt6 = dtiLoadDt6(fullfile(home,'dwi_1st/dt6.mat'));

t1 = niftiRead(dt6.files.t1);
b0 = niftiRead(dt6.files.b0);
%% Render fiber ROIs 

fiberDir = fullfile(home,'dwi_1st/fibers/conTrack/OR_divided');
roiDIR = fullfile(home,'dwi_1st/fgROIs');
ROIdir =  fullfile(home,'ROIs');

rois  = dir(fullfile(roiDIR,'*.mat'));
C = lines(5);%length(ROIs));
mrvNewGraphWin; hold on;

% ROIs loop
for i= 1:3%length(rois)
    ROI = dtiReadRoi(fullfile(roiDIR,rois(i).name));
    AFQ_RenderRoi(ROI,C(i,:));
end

% % adding ROIs for gfiber generation
% roi1 = dtiReadRoi(fullfile(ROIdir,'Lt-LGN4.mat'));
% roi2 = dtiReadRoi(...
%     '/media/USB_HDD1/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/fs_Retinotopy2/lh_Ecc0to3_smooth3mm.mat');
% roi3 = dtiReadRoi(...
%     '/media/USB_HDD1/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/fs_Retinotopy2/lh_Ecc30to90_smooth3mm.mat');
% 
% AFQ_RenderRoi(roi1)
% AFQ_RenderRoi(roi2)
% AFQ_RenderRoi(roi3)

AFQ_AddImageTo3dPlot(t1,[0,0,-25])
AFQ_AddImageTo3dPlot(t1,[-3,0,0])

line([-75,-65],[-100 -100],[-25 -25],'Color',[1 1 1],'Linewidth',1)
line([-70, -70],[-95 -105],[-25 -25],'Color',[1 1 1],'Linewidth',1)

view([-116 30])
view([-116 0])

% view([0 90])
title('OR')
camlight left
axis image
axis off

hold off;

%%  difine and read ORs
% FullfbDir = '/media/USB_HDD1/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/fibers/conTrack/OR_100K';
% FullfbName = 'fg_OR_100K_Lt-LGN4_lh_V1_smooth3mm_Half_2015-06-24_19.34.09-Rh_NOT_MD4.pdb';
OT = '/media/USB_HDD1/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/fibers/conTrack/OT_5K';      
OTfb = 'fg_OT_5K_85_Optic-Chiasm_Lt-LGN4_2015-07-13_18.48.12-41_Right-Cerebral-White-Matter_Ctrk100_AFQ_51.mat';

DivfbDir = '/media/USB_HDD1/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/fibers/conTrack/OR_divided';
fbPeri = 'fg_OR_divided_Lt-LGN4_lh_Ecc30to90_2015-09-02_14.55.17-Rh_NOT_MD4.pdb';
fbCenter = 'fg_OR_divided_Lt-LGN4_lh_Ecc0to3_2015-09-02_14.55.17-Rh_NOT_MD4.pdb';

% FgFull = fgRead(fullfile(FullfbDir,FullfbName));
fb3  = fgRead(fullfile(DivfbDir,fbPeri));
fb2    = fgRead(fullfile(DivfbDir,fbCenter));
OTfb = fgRead(fullfile(OT,OTfb));

%%
mrvNewGraphWin; hold on;

% AFQ_RenderFibers(OTfb,'numfibers',100,'newfig',0,'color',C(5,:))
AFQ_RenderFibers(fb2,'numfibers',100,'newfig',0,'color',C(2,:))
AFQ_RenderFibers(fb3,'numfibers',100,'newfig',0,'color',C(3,:))


AFQ_AddImageTo3dPlot(t1,[0,0,-25])
AFQ_AddImageTo3dPlot(t1,[-3,0,0])

% scale
line([-75,-65],[-100 -100],[-25 -25],'Color',[1 1 1],'Linewidth',1)
line([-70, -70],[-95 -105],[-25 -25],'Color',[1 1 1],'Linewidth',1)

% 
view([-116 30])

% view([0 90])
title('OR')
camlight left
axis image
axis off

hold off;



