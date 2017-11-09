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
    [HOME, subjID] = fileparts(pwd);
end

% if notDefined('HOME')
%     [, ~] = fileparts(pwd);
% end

% for individual subject
fsDir          = getenv('SUBJECTS_DIR');
fsMriDir   = fullfile(fsDir,subjID,'/mri');
% segFile = {'aparc+aseg.mgz','aparc.a2009s+aseg.mgz','aseg.mgz'};
segFile = {'aparc.a2009s+aseg.mgz'};

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
Subj_DIR = fullfile(fsDir,subjID);


cmd = sprintf('!recon-all -s %s -ba-labels', subjID);
eval(cmd)

cmd = sprintf('!recon-all -s %s -label_v1', subjID);
eval(cmd)

% %% label files
% % notice if you are using freesurfer 5.3.0 or higher, need one more step.
% % EXAMPLE USAGE:
% fsDir          = getenv('SUBJECTS_DIR');
% subject        = subjID;
% hemisphere     = {'lh','rh'};
% annotation_file     = 'aparc';
% outDir = fullfile(fsDir,subject,'label');
%
% % Now create all labels in the parcellation
%
% try
%     for icmd = 1:length(hemisphere)
%         cmd{icmd} = sprintf('!mri_annotation2label --subject %s  --hemi %s --annotation %s --outdir %s ', ...
%             subject,hemisphere{icmd},annotation_file,outDir);
%         eval(cmd{icmd});
%     end
%
%     annotation_file     = 'aparc.a2009s';
%
%     % Now create all labels in the parcellation
%     for icmd = 1:length(hemisphere)
%         cmd{icmd} = sprintf('!mri_annotation2label --subject %s  --hemi %s --annotation %s --outdir %s ', ...
%             subject,hemisphere{icmd},annotation_file,outDir);
%         eval(cmd{icmd});
%     end
%
%     annotation_file     = 'aparc.DKTatlas40';
%
%     % Now create all labels in the parcellation
%     for icmd = 1:length(hemisphere)
%         cmd{icmd} = sprintf('!mri_annotation2label --subject %s  --hemi %s --annotation %s --outdir %s ', ...
%             subject,hemisphere{icmd},annotation_file,outDir);
%         eval(cmd{icmd});
%     end
% catch
% end
%
%

%% Grab the label file
labelFileDir =  fullfile(Subj_DIR,'label');
labelFileNames = {'lh.V1.label','rh.V1.label','lh.V2.label','rh.V2.label',...
    'lh.MT.label','rh.MT.label','lh.v1.predict.label','rh.v1.predict.label',...
    'lh.v1.prob.label','rh.v1.prob.label'};

niftiRoiNames  = {'lh_V1','rh_V1','lh_V2','rh_V2','lh_MT','rh_MT',...
        'lh_v1_predict','rh_v1_predict','lh_v1_prob','rh_v1_prob'};

% Create nifti and mat ROI
for ii = 1:length(labelFileNames)
    labelFileName = fullfile(labelFileDir,labelFileNames{ii});
    
    % define save file and path
    MatRoiDir = fullfile(HOME,subjID,'ROIs');   
    
    % run fs_labelFileToNiftiRoi to make nifti roi
    [~, niftiRoi] = fs_labelFileToNiftiRoi(subjID,labelFileName,...
        fullfile(MatRoiDir, niftiRoiNames{ii}));
    
    % make mat roi from nifti
    nifti       = [niftiRoi.fname,'.nii.gz'];
    niftiWrite(niftiRoi,[niftiRoi.fname,'.nii.gz'])
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

%% run fs_retinotopicTemplate
out_path = fullfile(HOME,subjID,'fs_Retinotopy2');

if ~exist(out_path);
    mkdir(out_path);
end

% run main function fs_retinotopicTemplate
fs_retinotopicTemplate(subjID, out_path)

%%
MinDegree = [0 15 30];
MaxDegree = [3 30 90];
for jj = 1:3
    ACH_V1RoiCutEccentricity(subjID, MinDegree(jj), MaxDegree(jj))
end

%% 
Hiromasa_Noah_retinotopicTemplate_SingleSubj
%% label file to nifti ROI

fsDir = getenv('SUBJECTS_DIR');
Subj_DIR = fullfile(fsDir,subjID);

labelFileDir =  fullfile(Subj_DIR,'label');
labelFileNames = dir(fullfile(labelFileDir,'*.label'));

% Create nifti and mat ROI
for ii = 1:length(labelFileNames)
    labelFileName = fullfile(labelFileDir,labelFileNames(ii).name);
    
    % define save file and path
    MatRoiDir = fullfile(HOME,subjID,'ROIs');
    
    niftiRoiName  = labelFileNames(ii).name;
    dot = strfind(niftiRoiName,'.');
    if length(dot)==1;
        niftiRoiName = niftiRoiName(1:dot-1);
    elseif length(dot)>1;
        niftiRoiName(dot)='_';
         niftiRoiName = niftiRoiName(1:dot(end)-1);
    end
    
     
    % run fs_labelFileToNiftiRoi to make nifti roi
    [~, niftiRoi] = fs_labelFileToNiftiRoi(subjID,labelFileName,...
        fullfile(MatRoiDir, niftiRoiName));
    
    % make mat roi from nifti
    nifti       = [niftiRoi.fname,'.nii.gz'];
    niftiWrite(niftiRoi,[niftiRoi.fname,'.nii.gz'])
    maskValue   =  0;       % All nonZero values are used for the mask
    
    outName     = [niftiRoi.fname,'.mat'];
    outType     = 'mat';
    binary      = true;
    save        = true;
    roi = dtiRoiFromNifti(nifti,maskValue,outName,outType,binary,save);
    dtiWriteRoi(roi,fullfile(outDir,roi.name))
end
