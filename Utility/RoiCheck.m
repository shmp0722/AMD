function [NotYet] = RoiCheck

% Checking all subject in dMRI directory if they have freesurfer
% segmentation files. If not, make it up.


%% Dir and List
[homeDir , List] = SubJect;
NotYet = zeros(4,length(List));

% run fs if its not done.
for ii = 1:length(List)
    subID = List{ii};
    roiDir   = fullfile(homeDir,subID,'ROIs');
    ROIS = {'Lt-LGN4.mat','Rt-LGN4.mat','lh_V1_smooth3mm_Half.mat','rh_V1_smooth3mm_Half.mat'};
           
  
    if ~exist(fullfile(roiDir,ROIS{1}))
        
        NotYet(1,ii)= 1;
    elseif ~exist(fullfile(roiDir,ROIS{2}))
        NotYet(2,ii)= 1;
        
    end
    
    if ~exist(fullfile(roiDir,ROIS{3}))
        
        NotYet(3,ii)= 1;
    elseif ~exist(fullfile(roiDir,ROIS{4}))
        NotYet(4,ii)= 1;
        
    end
end