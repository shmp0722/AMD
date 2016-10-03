function Figure6
%
% Make Figure6b
%  
%
%
% SO@ACH 2016.9.30

%% Make sure you are under OphthalmicParameter
% /home/ganka/git/AMD/DiffusionMeasure/OphthalmicParameter

load R


%% reead t1, fg and dt6
fgDir = '/media/HDPC-UT/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/fibers';

LORC = fgRead(fullfile(fgDir,'LORC_MD4.mat'));
LORP = fgRead(fullfile(fgDir,'LORP_MD4.mat'));

t1 = niftiRead('/media/HDPC-UT/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/t1.nii.gz');
dt6 = dtiLoadDt6('/media/HDPC-UT/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/dt6.mat');

%%
figure; hold on;
% get r as rgb
vals = R.OR03;
rgb = vals2colormap(vals);

%% Render the tract profile


    % compute tract profile
    [~,~,~,~,~,fgCore]=dtiComputeDiffusionPropertiesAlongFG(LORC, dt6, [], [], 50);
    % Create Tract Profile structure
    TP = AFQ_CreateTractProfile;
    % Set the desired values to the structure
    TP = AFQ_TractProfileSet(TP,'vals','OR03',R.OR03);
    % Set the tract profile coordinates
    TP = AFQ_TractProfileSet(TP,'coordsacpc',fgCore.fibers{1});

    % Get the coordinates
    coords = AFQ_TractProfileGet(TP,'coordsacpc');
    % Get the values
    vals = AFQ_TractProfileGet(TP,'vals','OR03');
    % Render the tract Profile
    AFQ_RenderTractProfile(coords,5,vals,30);

    
     % purple r 160 g 32 b 240
    % blue   rgb [0 0 255]
    color_b = [0 0 1];
%     color_p = [160/255 32/255 240/255];
    
    AFQ_RenderFibers(LORC,'numfibers',100,'color',color_b,'newfig',0);
    AFQ_RenderTractProfile(coords,5,vals,30);

    
    AFQ_AddImageTo3dPlot(t1,[0 0 -20])
    AFQ_AddImageTo3dPlot(t1,[-2 0 0])

    view([-62 31])
    
   axis off
   title('r value along with OR')
   axis equal 
    
   %%
   saveas(gca,'Figure6b.eps','epsc')
   saveas(gca,'Figure6b.png')
    
%%

fg  = fgRead('LORC_MD4_SuperFiber.mat');
% AFQ_RenderFibers(LORC,'numfibers',100,'newfig',0,'color',rgb);


AFQ_RenderFibers(LORP,'numfibers',100, 'dt', dt6, 'radius', [.7 5], 'jittercolor', .1);

% AFQ_RenderFibers(fg,'color',rgb);
% To color each point on each fiber based on values from any nifti image:
% im = readFileNifti('pathToImage.nii.gz');
% vals = dtiGetValFromFibers(im.data,fg,im.qto_ijk)
% rgb = vals2colormap(vals);
% AFQ_RenderFibers(fg,'color',rgb)


% AFQ_RenderFibers(fg,'alpha',alpha) - Set the transparency of the fibers.
% Alpha should be a value between 0 (transparent) and 1 (opaque).