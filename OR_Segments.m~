function OR_Segments

% Basic Ideda
%
%
%
%


%%  difine and read ORs

[homeDir, List] = SubJect;

for ii = fliplr(1:20)
    
    Full_fbDir =fullfile(homeDir, List{ii}, '/dwi_1st/fibers/conTrack/OR_100K');
    
        
    L_FullfbName = dir(fullfile(Full_fbDir, '*Lt-LGN4_lh_V1_smooth3mm_Half*Rh_NOT_MD4.pdb'));
    R_FullfgName = dir(fullfile(Full_fbDir,'*Rt-LGN4_rh_V1_smooth3mm_Half*Lh_NOT_MD4.pdb'));
    
    F_fgL = fgRead(fullfile(Full_fbDir,L_FullfbName.name));
    F_fgR = fgRead(fullfile(Full_fbDir,R_FullfgName.name));
    
    DivfbDir = fullfile(homeDir,List{ii},'dwi_1st/fibers/conTrack/OR_divided');
    L_PerifbName = dir(fullfile(DivfbDir,'*Lt-LGN4_lh_Ecc30to90*Rh_NOT_MD4.pdb'));
    L_CorefbName = dir(fullfile(DivfbDir,'*Lt-LGN4_lh_Ecc0to3*Rh_NOT_MD4.pdb'));
    
    R_PerifbName = dir(fullfile(DivfbDir,'*Rt-LGN4_rh_Ecc30to90*Lh_NOT_MD4.pdb'));
    R_CorefbName = dir(fullfile(DivfbDir,'*Rt-LGN4_rh_Ecc0to3*Lh_NOT_MD4.pdb'));
    
    L_FgFull = fgRead(fullfile(Full_fbDir,L_FullfbName.name));
    L_FgDiv3090  = fgRead(fullfile(DivfbDir,L_PerifbName.name));
    L_FgDiv03  = fgRead(fullfile(DivfbDir,L_CorefbName.name));
    
    R_FgFull = fgRead(fullfile(Full_fbDir,R_FullfgName.name));
    R_FgDiv3090  = fgRead(fullfile(DivfbDir,R_PerifbName.name));
    R_FgDiv03  = fgRead(fullfile(DivfbDir,R_CorefbName.name));
    
    
    %% Create ROIs
    
    % get the unique coordinates
    L_FullRoi = dtiCreateRoiFromFibers(L_FgFull);
    L_FullRoi.coords = unique(L_FullRoi.coords,'rows');
    
    R_FullRoi = dtiCreateRoiFromFibers(R_FgFull);
    R_FullRoi.coords = unique(R_FullRoi.coords,'rows');
    
    L_DivRoi03    = dtiCreateRoiFromFibers(L_FgDiv03);
    L_DivRoi03.coords = unique(L_DivRoi03.coords,'rows');
    
    R_DivRoi03    = dtiCreateRoiFromFibers(R_FgDiv03);
    R_DivRoi03.coords = unique(R_DivRoi03.coords,'rows');
    
    L_DivRoi3090 = dtiCreateRoiFromFibers(L_FgDiv3090);
    L_DivRoi3090.coords = unique(L_DivRoi3090.coords,'rows');
    
    R_DivRoi3090 = dtiCreateRoiFromFibers(R_FgDiv3090);
    R_DivRoi3090.coords = unique(R_DivRoi3090.coords,'rows');
    
    % Check the intersect
    L_Full_w03   = dtiNewRoi('Full_w03',[], intersect(L_FullRoi.coords,L_DivRoi03.coords,'rows')) ;
    L_Full_w3090 = dtiNewRoi('Full_w3090',[], intersect(L_FullRoi.coords,L_DivRoi3090.coords,'rows')) ;
    
    R_Full_w03   = dtiNewRoi('Full_w03',[], intersect(R_FullRoi.coords,R_DivRoi03.coords,'rows')) ;
    R_Full_w3090 = dtiNewRoi('Full_w3090',[], intersect(R_FullRoi.coords,R_DivRoi3090.coords,'rows')) ;
    
    
    L_Roi03w3090   = dtiNewRoi('033090',[], intersect(L_DivRoi03.coords,L_DivRoi3090.coords,'rows')) ;
    L_Roi03wo3090  = dtiNewRoi('03wo3090',[], setdiff(L_DivRoi03.coords,L_DivRoi3090.coords,'rows')) ;
    L_Roi3090wo03  = dtiNewRoi('03wo3090',[], setdiff(L_DivRoi3090.coords,L_DivRoi03.coords,'rows')) ;
    
    R_Roi03w3090   = dtiNewRoi('033090',[], intersect(R_DivRoi03.coords,R_DivRoi3090.coords,'rows')) ;
    R_Roi03wo3090  = dtiNewRoi('03wo3090',[], setdiff(R_DivRoi03.coords,R_DivRoi3090.coords,'rows')) ;
    R_Roi3090wo03  = dtiNewRoi('03wo3090',[], setdiff(R_DivRoi3090.coords,R_DivRoi03.coords,'rows')) ;
    
%     %% intersectging voxel percentages
%     L_P(1) = length( L_Full_w03.coords)/ length(L_FullRoi.coords);
%     L_P(2) = length( L_Full_w3090.coords)/ length(L_FullRoi.coords);
%     
%     R_P(1) = length( R_Full_w03.coords)/ length(R_FullRoi.coords);
%     R_P(2) = length( R_Full_w3090.coords)/ length(R_FullRoi.coords);
%     
%     figure;hold on;
%     bar([1,2],L_P,0.2)
%     
%     set(gca, 'yTick',[0:0.1:0.5],'xtick',[0:1:3],'xTicklabel',{'','center3d','Peripheral30-90d',''})
%     title('Overlap voxels')
%     hold off;
%     
%     figure;hold on;
%     bar([1,2],R_P,0.2)
%     
%     set(gca, 'yTick',[0:0.1:0.5],'xtick',[0:1:3],'xTicklabel',{'','center3d','Peripheral30-90d',''})
%     title('Overlap voxels')
%     hold off;
%     
    %%
    % Rendering ROI
    C = jet(3);
    
    % % Central 0-3 substracted
    % figure; hold on;
    % AFQ_RenderRoi(L_Roi03wo3090,C(2,:));
    % view([0 90])
    % title('central 0-3 wo Peripheral 30-90')
    % camlight
    % hold off;
    
    % Central 0-3 substracted
    figure; hold on;
    
    AFQ_RenderRoi(L_Roi03wo3090,C(2,:));
    AFQ_RenderRoi(L_Roi3090wo03);
    AFQ_RenderRoi(L_Roi03w3090,C(3,:))
    
    AFQ_RenderRoi(R_Roi03wo3090,C(2,:));
    AFQ_RenderRoi(R_Roi3090wo03);
    AFQ_RenderRoi(R_Roi03w3090,C(3,:))
    
    camlight left
    axis auto
    axis off
    % view([-36,68])
    title(sprintf('%s', List{ii}))
    hold off
    
end
return
%%
% Peripheral 30-90
figure; hold on;
AFQ_RenderRoi(L_Roi3090wo03);
view([0 90])
camlight
title('peripheral 30-90 wo 0-3')
% camlight headlight
hold off

%% Take a look whole OR
figure;hold on;
AFQ_RenderRoi(L_FullRoi)
AFQ_RenderRoi(L_Full_w03,C(2,:))

camlight
hold off;


AFQ_RenderRoi(L_DivRoi03,C(2,:))
AFQ_RenderRoi(L_DivRoi3090,C(1,:))

%% Next we7re gonna check this

dt6File = dtiLoadDt6('/media/USB_HDD1/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/dt6.mat');
RoiFileName = L_Roi3090wo03;

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
dt = dtiLoadDt6('/media/USB_HDD1/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/dt6.mat');

% These coordsinates are in ac-pc (millimeter) space. We want to transform
% them to image indices.
img_coordsFull = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), Full.coords)), 'rows');
img_coordsw03 = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), L_Full_w03.coords)), 'rows');
img_coordsw3090 = unique(floor(mrAnatXformCoords(inv(dt.xformToAcpc), L_Full_w3090.coords)), 'rows');

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


