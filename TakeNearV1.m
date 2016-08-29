function TakeNearV1 

% Basic Ideda  
% 
% 
%
%


%%  difine and read ORs
FullfbDir = '/media/HDPC-UT/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/fibers/conTrack/OR_100K';
FullfbName = 'fg_OR_100K_Lt-LGN4_lh_V1_smooth3mm_Half_2015-06-24_19.34.09-Rh_NOT_MD4.pdb';

DivfbDir = '/media/HDPC-UT/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/fibers/conTrack/OR_divided';
DivfbName = 'fg_OR_divided_Lt-LGN4_lh_Ecc30to90_2015-09-02_14.55.17-Rh_NOT_MD4.pdb';
DivfbName2 = 'fg_OR_divided_Lt-LGN4_lh_Ecc0to3_2015-09-02_14.55.17-Rh_NOT_MD4.pdb';

FgFull = fgRead(fullfile(FullfbDir,FullfbName));
FgDiv3090  = fgRead(fullfile(DivfbDir,DivfbName));
FgDiv03  = fgRead(fullfile(DivfbDir,DivfbName2));

%% Create ROIs

% get the unique coordinates
FullRoi = dtiCreateRoiFromFibers(FgFull);
FullRoi.coords = unique(FullRoi.coords,'rows');

DivRoi03    = dtiCreateRoiFromFibers(FgDiv03);
DivRoi03.coords = unique(DivRoi03.coords,'rows');

DivRoi3090 = dtiCreateRoiFromFibers(FgDiv3090);
DivRoi3090.coords = unique(DivRoi3090.coords,'rows');

% Check the intersect 
Full_w03   = dtiNewRoi('Full_w03',[], intersect(FullRoi.coords,DivRoi03.coords,'rows')) ;
Full_w3090 = dtiNewRoi('Full_w3090',[], intersect(FullRoi.coords,DivRoi3090.coords,'rows')) ;

Roi03w3090   = dtiNewRoi('033090',[], intersect(DivRoi03.coords,DivRoi3090.coords,'rows')) ;
Roi03wo3090  = dtiNewRoi('03wo3090',[], setdiff(DivRoi03.coords,DivRoi3090.coords,'rows')) ;
Roi3090wo03  = dtiNewRoi('03wo3090',[], setdiff(DivRoi3090.coords,DivRoi03.coords,'rows')) ;

%% intersectging voxel percentages 
P(1) = length( Full_w03.coords)/ length(FullRoi.coords);
P(2) = length( Full_w3090.coords)/ length(FullRoi.coords);

figure;hold on;
bar([1,2],P,0.2)

set(gca, 'yTick',[0:0.1:0.5],'xtick',[0:1:3],'xTicklabel',{'','center3d','Peripheral30-90d',''})
title('Overlap voxels')
hold off;

%%
% Rendering ROI
C = jet(3);

% Central 0-3 substracted 
figure; hold on;
AFQ_RenderRoi(Roi03wo3090,C(2,:));
view([0 90])
title('central 0-3 wo Peripheral 30-90')
camlight
hold off;

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


