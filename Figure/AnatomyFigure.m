function AnatomyFigure

%
% The figure shows segmented OR organization.
%
%
%
% SO@ACH 2016.09.06

%%
home = '/media/HDPC-UT/dMRI_data/AMD-01-dMRI-Anatomy-dMRI';

%% load dt6

dt6 = dtiLoadDt6(fullfile(home,'dwi_1st/dt6.mat'));

t1 = niftiRead(dt6.files.t1);
b0 = niftiRead(dt6.files.b0);
%% load fiber ROIs 

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
%     '/media/HDPC-UT/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/fs_Retinotopy2/lh_Ecc0to3_smooth3mm.mat');
% roi3 = dtiReadRoi(...
%     '/media/HDPC-UT/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/fs_Retinotopy2/lh_Ecc30to90_smooth3mm.mat');
% 
% AFQ_RenderRoi(roi1)
% AFQ_RenderRoi(roi2)
% AFQ_RenderRoi(roi3)

AFQ_AddImageTo3dPlot(t1,[0,0,-25])
AFQ_AddImageTo3dPlot(t1,[-3,0,0])

line([-75,-65],[-100 -100],[-25 -25],'Color',[1 1 1],'Linewidth',2)
line([-70, -70],[-95 -105],[-25 -25],'Color',[1 1 1],'Linewidth',2)


view([-116 30])

% view([0 90])
title('OR')
camlight left
axis image
axis off

legend
hold off;

%%
% Central 0-3 substracted 
figure; hold on;

AFQ_RenderRoi(Roi03wo3090,C(2,:));
AFQ_RenderRoi(Roi3090wo03);
AFQ_RenderRoi(Roi03w3090,C(3,:))

camlight left
% axis auto
view([-36,68])

hold off

% Peripheral 30-90 
figure; hold on;
AFQ_RenderRoi(Roi3090wo03);
view([0 90])
camlight 
title('peripheral 30-90 wo 0-3')
% camlight headlight
hold off

% Take a look whole OR
figure;hold on;
AFQ_RenderRoi(FullRoi)
AFQ_RenderRoi(Full_w03,C(2,:))

camlight
hold off;


AFQ_RenderRoi(DivRoi03,C(2,:))
AFQ_RenderRoi(DivRoi3090,C(1,:))

%% Next we7re gonna check this

dt6File = dtiLoadDt6('/media/HDPC-UT/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_2nd/dt6.mat');
RoiFileName = Roi3090wo03;

dt6File=dtiLoadDt6(dt6File); 
%2. Compute FA, MD, RD properties for ROI
[val1,val2,val3,val4,val5,val6] = dtiGetValFromTensors(dt6File.dt6, roi.coords, inv(dt6File.xformToAcpc),'dt6','nearest');
dt6 = [val1,val2,val3,val4,val5,val6];
[vec,val] = dtiEig(dt6);

[fa,md,rd,ad] = dtiComputeFA(val);

%3Return mean (across nonnan) values
FA(1)=min(fa(~isnan(fa))); FA(2)=mean(fa(~isnan(fa))); FA(3)=max(fa(~isnan(fa))); %isnan is needed  because sometimes if all the three eigenvalues are negative, the FA becomes NaN. These voxels are noisy. 
MD(1)=min(md); MD(2)=mean(md); MD(3)=max(md); 
radialADC(1)=min(rd); radialADC(2)=mean(rd); radialADC(3)=max(rd); 
axialADC(1)=min(ad); axialADC(2)=mean(ad); axialADC(3)=max(ad); 


[FA,MD,radialADC,axialADC] = dtiROIProperties(dt6File, RoiFileName);

%%
% Load up the dt6
dt = dtiLoadDt6('/media/HDPC-UT/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/dt6.mat');

% These coordsinates are in ac-pc (millimeter) space. We want to transform
% them to image indices.
img_coordsFull = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), Full.coords)), 'rows');
img_coordsw03 = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), Full_w03.coords)), 'rows');
img_coordsw3090 = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), Full_w3090.coords)), 'rows');

% Now we can calculate FA
fa = dtiComputeFA(dt.dt6);

% Now lets take these coordinates and turn them into an image. First we
% will create an image of zeros
OR_img = zeros(size(fa));
% Convert these coordinates to image indices
ind = sub2ind(size(fa), img_coords(:,1), img_coords(:,2),img_coords(:,3));
% Now replace every coordinate that has the optic radiations with a 1
OR_img(ind) = 1;

% Now you have an image. Just for your own interest if you want to make a
% 3d rendering
isosurface(OR_img,.5);

% For each voxel that does not contain the optic radiations we will zero
% out its value
fa(~OR_img) = 0;

% Now we want to save this as a nifti image; The easiest way to do this is
% just to steal all the information from another image. For example the b0
% image
dtiWriteNiftiWrapper(fa, dt.xformToAcpc, 'L-OR-MD3-FA.nii.gz');
end







