function CutV1Roi(SubFullID)

%
% Lets cut anterior half of V1 ROI off. Our interest is with in central 15
% degree in VF... tentative idea.
%
% Examlple
% SubFullID = FullPath to your subject
% CutV1Roi(SubFullID)
%
% SO@ ACH 2015

%%
if notDefined('SubFullID')
    [SubFullID] = pwd;
end

%% read ROI
% lh and rh
ROIS = {'lh_V1_smooth3mm.mat','rh_V1_smooth3mm.mat'};


% Load V1ROI.mat
ROI_dir = fullfile(SubFullID,'ROIs');
for ii = 1:length(ROIS)
    V1 = fullfile(ROI_dir,ROIS{ii});
    if ~exist(V1)
        sprintf('check if the ROI exist in %s',ROI_dir)
    else
        V1roi = dtiReadRoi(fullfile(ROI_dir,ROIS{ii}));
        
        % select spesific coords by half where is close to central 15do VF ...
        
        CutPoint_Y =  floor(mean([min(V1roi.coords(:,2)), max(V1roi.coords(:,2))]));
        
        % pick the posterior half
        [~, roiNot] = dtiRoiClip(V1roi, [], [-120,CutPoint_Y], []);
        
        
        % change the ROI name
        roiNot.name = [V1roi.name, '_Half'];
        
        % save the ROI        
        dtiWriteRoi(roiNot,fullfile(ROI_dir,roiNot.name))
    end
end
