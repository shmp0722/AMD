function Figure5b(savefig)
%
% Make Figure5b
%
%

% SO@ACH 2016.9.30

%% Make sure you are under OphthalmicParameter
% /home/ganka/git/AMD/DiffusionMeasure/OphthalmicParameter

load R
load AUC03

if notDefined('savefig')
    savefig = 0;
end

%% reead t1, fg and dt6
fgDir = '/media/USB_HDD1/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/fibers';

LORC = fgRead(fullfile(fgDir,'LORC_MD4.mat'));
RORC = fgRead(fullfile(fgDir,'RORC_MD4.mat'));

t1 = niftiRead('/media/USB_HDD1/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/t1.nii.gz');
dt6 = dtiLoadDt6('/media/USB_HDD1/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/dt6.mat');

%%
figure; hold on;

%% Render the tract profile


% compute core fiber
%     [~,~,~,~,~,fgCoreL]=dtiComputeDiffusionPropertiesAlongFG(LORC, dt6, [], [], 50);
%     [~,~,~,~,~,fgCoreR]=dtiComputeDiffusionPropertiesAlongFG(RORC, dt6, [], [], 50);

[fgCoreL, ~] = dtiComputeSuperFiberRepresentation(LORC, [], 50);
[fgCoreR, ~] = dtiComputeSuperFiberRepresentation(RORC, [], 50);

%% render both OR in each


% color should be identical to other figs
% purple r 160 g 32 b 240
% blue   rgb [0 0 255]
%     color_p = [160/255 32/255 240/255];
color_b = [0 0 1];
AFQ_RenderFibers(fgCoreL,'color',color_b,'newfig',1)
% AFQ_RenderFibers(fgCoreR,'color',color_b,'newfig',0)

% Render the tract Profile
AFQ_RenderTractProfile(fgCoreL.fibers{1},5,R.OR03,30,[],[],0);
% AFQ_RenderTractProfile(fgCoreR.fibers{1},5,AUC03,30,[],[.5 1],0);

AFQ_AddImageTo3dPlot(t1,[0 0 -20])
% AFQ_AddImageTo3dPlot(t1,[-2 0 0])

view([0 90])

axis off
title('r value along LOR')
axis equal
axis auto

%
if savefig ==1;
    saveas(gca,'Figure5c(1).eps','epsc')
    saveas(gca,'Figure5c(1).png')
end

%% render both OR in each


% color should be identical to other figs
% purple r 160 g 32 b 240
% blue   rgb [0 0 255]
%     color_p = [160/255 32/255 240/255];
color_b = [0 0 1];
% AFQ_RenderFibers(fgCoreL,'color',color_b,'newfig',1)
AFQ_RenderFibers(fgCoreR,'color',color_b,'newfig',1)

% Render the tract Profile
% AFQ_RenderTractProfile(fgCoreL.fibers{1},5,R.OR03,30,[],[],0);
AFQ_RenderTractProfile(fgCoreR.fibers{1},5,AUC03,30,[],[.5 1],0);

AFQ_AddImageTo3dPlot(t1,[0 0 -20])
% AFQ_AddImageTo3dPlot(t1,[-2 0 0])

view([0 90])

axis off
title('AUC value along ROR')
axis equal
axis auto

%
if savefig ==1;
    saveas(gca,'Figure5c(2).eps','epsc')
    saveas(gca,'Figure5c(2).png')
end

%%
color_b = [0 0 1];
% AFQ_RenderFibers(fgCoreL,'color',color_b,'newfig',1)
AFQ_RenderFibers(fgCoreL,'color',color_b,'newfig',1)

% Render the tract Profile
% AFQ_RenderTractProfile(fgCoreL.fibers{1},5,R.OR03,30,[],[],0);
AFQ_RenderTractProfile(fgCoreL.fibers{1},5,AUC03,30,[],[.5 1],0);

AFQ_AddImageTo3dPlot(t1,[0 0 -20])
% AFQ_AddImageTo3dPlot(t1,[-2 0 0])

view([0 90])

axis off
title('AUC value along LOR')
axis equal
axis auto

%
if savefig ==1;
    saveas(gca,'Figure5c(3).eps','epsc')
    saveas(gca,'Figure5c(3).png')
end