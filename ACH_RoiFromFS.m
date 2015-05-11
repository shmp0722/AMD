function ACH_RoiFromFS

%
% fs_roisFromAllLabels(fsIn,outDir,type,refT1)
% 
%   EXAMPLE USAGE:
%   fsIn   = '/path/to/aparc+aseg.mgz';
%   outDir = '/save/directory/rois';
%   type   = 'mat';
%   refT1  = '/path/to/t1Anatomical.nii.gz';
%   fs_roisFromAllLabels(fsIn,outDir,type,refT1);
%


%% Get slmost all rois from FS segmentation file

% for Ctl-RT
  fsDir   = '/home/ganka/dMRI_data/freesurfer/Ctl-RT-20150426/mri';
  segFile = {'aparc+aseg.mgz','aparc.a2009s+aseg.mgz','aseg.mgz'};
  
  outDir = '/home/ganka/dMRI_data/Ctl-RT-20150426/TestROIs';
  if ~exist(outDir);
      mkdir(outDir)
  end
  
  type   = 'mat';
  refT1  = '/home/ganka/dMRI_data/Ctl-RT-20150426/t1.nii.gz';
  
  for ii = 1:length(segFile)
      fsIn  = fullfile(fsDir,segFile{ii});
      fs_roisFromAllLabels(fsIn,outDir,type,refT1);
  end

  %% Get V1, V2 and MT ROIs
  SUBJECTS_DIR = '/home/ganka/dMRI_data/freesurfer/Ctl-RT-20150426';
  
  fs_subject = 'Ctl-RT-20150426';
  labelFileName = fullfile(SUBJECTS_DIR,'label/lh.V1.label');
  
  niftiRoiName  = '/home/ganka/dMRI_data/Ctl-RT-20150426/TestROIs/lh_V1';
  
  [niftiRoiName, niftiRoi] = fs_labelFileToNiftiRoi(fs_subject,labelFileName,niftiRoiName);

%% V1 R  
  
  labelFileName = fullfile(SUBJECTS_DIR,'label/rh.V1.label');
  niftiRoiName  = '/home/ganka/dMRI_data/Ctl-RT-20150426/TestROIs/rh_V1';


  fs_labelFileToNiftiRoi(fs_subject,labelFileName,niftiRoiName)
%% V2 LR
  labelFileName = fullfile(SUBJECTS_DIR,'label/lh.V2.label');
  niftiRoiName  = '/home/ganka/dMRI_data/Ctl-RT-20150426/TestROIs/lh_V2';
  fs_labelFileToNiftiRoi(fs_subject,labelFileName,niftiRoiName)
  
  labelFileName = fullfile(SUBJECTS_DIR,'label/rh.V2.label');
  niftiRoiName  = '/home/ganka/dMRI_data/Ctl-RT-20150426/TestROIs/rh_V2';
  fs_labelFileToNiftiRoi(fs_subject,labelFileName,niftiRoiName)
%% MT LR
  labelFileName = fullfile(SUBJECTS_DIR,'label/lh.MT.label');
   niftiRoiName  = '/home/ganka/dMRI_data/Ctl-RT-20150426/TestROIs/lh_MT';
  fs_labelFileToNiftiRoi(fs_subject,labelFileName,niftiRoiName)
  
  labelFileName = fullfile(SUBJECTS_DIR,'label/rh.MT.label');
  niftiRoiName  = '/home/ganka/dMRI_data/Ctl-RT-20150426/TestROIs/rh_MT';
  fs_labelFileToNiftiRoi(fs_subject,labelFileName,niftiRoiName)
%% transform nii.gz to .mat 

      nifti       = 'lh_MT.nii.gz';
        maskValue   =  0;       % All nonZero values are used for the mask
        outName     = 'lh_MT.mat';
        outType     = 'mat';
        binary      = true;
        save        = true;
        dtiRoiFromNifti(nifti,maskValue,outName,outType,save);
