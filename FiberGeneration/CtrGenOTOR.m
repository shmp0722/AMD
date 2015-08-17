function CtrGenOTOR(nums)

% Generate optic radiation and optic tract with conTrack
%
% SO@ACH 2015

%% Take subject names
[dMRI, List] = SubJect;

% pick up your interesting subject
if notDefined('nums'),
    nums = [1:8];
end

for ii = 1:length(nums)
    Subs{ii} = List{nums(ii)};
end

%% Optic Radiation
% Set Params for contrack fiber generation

% Create params structure
ctrParams = ctrInitBatchParams;

% params
ctrParams.projectName = 'OR_100K';
ctrParams.logName = 'myConTrackLog';
ctrParams.baseDir = dMRI;
ctrParams.dtDir = 'dwi_1st';
ctrParams.roiDir = '/ROIs';

% pick up subjects
ctrParams.subs = Subs;

% set parameter
ctrParams.roi1 = {'Lt-LGN4','Rt-LGN4'};
ctrParams.roi2 = {'lh_V1_smooth3mm_Half','rh_V1_smooth3mm_Half'};
ctrParams.nSamples = 100000;
ctrParams.maxNodes = 240;
ctrParams.minNodes = 100; % defalt: 10
ctrParams.stepSize = 1;
ctrParams.pddpdfFlag = 0;
ctrParams.wmFlag = 0;
ctrParams.oi1SeedFlag = 'true';
ctrParams.oi2SeedFlag = 'true';
ctrParams.multiThread = 0;
ctrParams.xecuteSh = 0;


%% Generate OR usinig Sherbondy's contrack
[cmd, ~] = ctrInitBatchTrack(ctrParams);
system(cmd);
clear ctrParams
%% Optic Tract
% Create params structure
ctrParams = ctrInitBatchParams;

% set params
ctrParams.projectName = 'OT_5K';
ctrParams.logName = 'myConTrackLog';
ctrParams.baseDir = dMRI;
ctrParams.dtDir = 'dwi_1st';
ctrParams.roiDir = 'ROIs';
ctrParams.subs = Subs;

% set parameter
ctrParams.roi1 = {'85_Optic-Chiasm','85_Optic-Chiasm'};
ctrParams.roi2 = {'Rt-LGN4','Lt-LGN4'};
ctrParams.nSamples = 5000;  % number of fibers 
ctrParams.maxNodes = 100;   % longest fiber length(mm) 
ctrParams.minNodes = 20;    % shortest fiber length(mm) 
ctrParams.stepSize = 1;
ctrParams.pddpdfFlag = 0;
ctrParams.wmFlag = 0;
ctrParams.oi1SeedFlag = 'true';
ctrParams.oi2SeedFlag = 'true';
ctrParams.multiThread = 0;
ctrParams.xecuteSh = 0;

%% generate optic tract
[cmd, ~] = ctrInitBatchTrack(ctrParams);
system(cmd);
clear ctrParams
% %% OCF from LH to RH
% ctrParams = ctrInitBatchParams;
% 
% ctrParams.projectName = 'OCF_Top50K';
% ctrParams.logName = 'myConTrackLog';
% ctrParams.baseDir = homeDir;
% ctrParams.dtDir = 'dwi_2nd';
% ctrParams.roiDir = '/dwi_2nd/ROIs';
% ctrParams.subs = subDir;
% 
% % set parameter
% ctrParams.roi1 = {'lh_V1_smooth3mm_lh_V2_smooth3mm'};
% ctrParams.roi2 = {'rh_V1_smooth3mm_rh_V2_smooth3mm'};
% ctrParams.nSamples = 50000;
% ctrParams.maxNodes = 240;
% ctrParams.minNodes = 10;
% ctrParams.stepSize = 1;
% ctrParams.pddpdfFlag = 0;
% ctrParams.wmFlag = 0;
% ctrParams.oi1SeedFlag = 'true';
% ctrParams.oi2SeedFlag = 'true';
% ctrParams.multiThread = 0;
% ctrParams.xecuteSh = 0;
% 
% %% Run ctrInitBatchTrack
% [cmd, ~] = ctrInitBatchTrack(ctrParams);
% system(cmd);
% clear ctrParams
% %% OCF CC to bothe V1+V2
% % Set ctrInitBatchParams
% ctrParams = ctrInitBatchParams;
% 
% ctrParams.projectName = 'OCF_Top50K_fsCC_V1V2';
% ctrParams.logName = 'myConTrackLog';
% ctrParams.baseDir = homeDir;
% ctrParams.dtDir = 'dwi_2nd';
% ctrParams.roiDir = '/dwi_2nd/ROIs';
% ctrParams.subs = subDir;
% 
% % set parameter
% ctrParams.roi1 = {'fs_CC','fs_CC'};
% ctrParams.roi2 = {'rh_V1_smooth3mm_rh_V2_smooth3mm','lh_V1_smooth3mm_lh_V2_smooth3mm'};
% ctrParams.nSamples = 50000;
% ctrParams.maxNodes = 240;
% ctrParams.minNodes = 10;
% ctrParams.stepSize = 1;
% ctrParams.pddpdfFlag = 0;
% ctrParams.wmFlag = 0;
% ctrParams.oi1SeedFlag = 'true';
% ctrParams.oi2SeedFlag = 'true';
% ctrParams.multiThread = 0;
% ctrParams.xecuteSh = 0;
% 
% 
% %% Run ctrInitBatchTrack
% [cmd, ~] = ctrInitBatchTrack(ctrParams);
% system(cmd);
% clear ctrParams

end
