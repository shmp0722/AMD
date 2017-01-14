function ACH_RoiFromFS(subjID)
%
%   EXAMPLE USAGE:
%   subjID = 'Yoshimine';
%   ACH_RoiFromFS(subjID)
%
%
%   REQUIREMENT
%   Freesurfer segmentation files
%   See fs_autosegmentatinToITK
%
%   SO @ACH 2015

%% Get slmost all rois from FS segmentation file

if notDefined('subjID')
    [~, subjID] = fileparts(pwd);
end

if notDefined('HOME')
    [HOME, ~] = fileparts(pwd);
end

% for individual subject
fsDir          = getenv('SUBJECTS_DIR');
fsMriDir   = fullfile(fsDir,subjID,'/mri');
segFile = {'aparc+aseg.mgz','aparc.a2009s+aseg.mgz','aseg.mgz'};

% confirm save directory existance
outDir = fullfile(HOME,subjID,'ROIs');
%%
if ~exist(outDir);
    mkdir(outDir)
end

type   = 'mat';
refT1  = fullfile(HOME,subjID,'t1.nii.gz');

for ii = 1:length(segFile)
    fsIn  = fullfile(fsMriDir,segFile{ii});
    fs_roisFromAllLabels(fsIn,outDir,type,refT1);
end

%% Get V1, V2 and MT ROIs
fsDir          = getenv('SUBJECTS_DIR');
SUBJECTS_DIR = fullfile(fsDir,subjID);

% Grab the label file
labelFileDir =  fullfile(SUBJECTS_DIR,'label');
labelFileNames = {'lh.V1.label','rh.V1.label','lh.V2.label','rh.V2.label','lh.MT.label','rh.MT.label'};

% Create nifti and mat ROI
for ii = 1:length(labelFileNames)
    labelFileName = fullfile(labelFileDir,labelFileNames{ii});
    
    % define save file and path
    MatRoiDir = fullfile(HOME,subjID,'ROIs');
    niftiRoiNames  = {'lh_V1','rh_V1','lh_MT','rh_MT','lh_V2','rh_V2'};
    
    % run fs_labelFileToNiftiRoi to make nifti roi
    [~, niftiRoi] = fs_labelFileToNiftiRoi(subjID,labelFileName,niftiRoiNames{ii});
    
    % make mat roi from nifti
    nifti       = [niftiRoi.fname,'.nii.gz'];
    maskValue   =  0;       % All nonZero values are used for the mask
    
    outName     = [niftiRoi.fname,'.mat'];
    outType     = 'mat';
    binary      = true;
    save        = true;
    roi = dtiRoiFromNifti(nifti,maskValue,outName,outType,binary,save);
    dtiWriteRoi(roi,fullfile(outDir,roi.name))
end

% make V1 roi half
CutV1Roi(fullfile(HOME,subjID))

return
