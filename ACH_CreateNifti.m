function ACH_CreateNifti(SUBJECT)

% Transforming dicom files to nii.gz file obtained by SIEMENS 3T scanner in
% Tamagawa University, Machida, JAPAN
%
%  INPUTS:
%   subDir: subject directory name
%   (ex. 'Ctl-SO-20150426')
%   option:  0: default (single masurement. analyzing 'dwi.nii.gz')
%            1: analyzing first diffusion measure 'dwi1st.nii.gz'
%            2: analyzing second diffusion measure 'dwi2nd.nii.gz'
%
%
% (c) SO 2015 @ACH

%% change file format 

if notDefined('SUBJECT')
 [~, subDir] = fileparts(pwd);
 SUBJECT = fullfile('/home/ganka/dMRI_data/',subDir);
 T1 = fullfile(SUBJECT,'T1');
 dwi1st = fullfile(SUBJECT,'dwi1st');
 dwi2nd = fullfile(SUBJECT,'dwi2nd');
 niiFolder = pwd;
end

outFormat = 'nii.gz';

% create nii.gz files 
dicm2nii(T1, niiFolder, outFormat)
dicm2nii(dwi1st, dwi1st, outFormat)
dicm2nii(dwi2nd, dwi2nd, outFormat)

%% make raw foldef under SUBJECT folder

RawFolder = fullfile(pwd,'raw');
if ~exist(RawFolder)
 mkdir(fullfile(SUBJECT,'raw'))
end

%% change file names 

% dwi1st
Bvec = dir(fullfile(dwi1st,'*.bvec')); 
Bval = dir(fullfile(dwi1st,'*.bval'));
Dwi1st = dir(fullfile(dwi1st,'*iso.nii.gz'));
copyfile(fullfile(dwi1st,Bvec.name),fullfile(RawFolder,'dwi1st.bvec'));
copyfile(fullfile(dwi1st,Bval.name),fullfile(RawFolder,'dwi1st.bval'));
copyfile(fullfile(dwi1st,Dwi1st.name),fullfile(RawFolder,'dwi1st.nii.gz'));

% dwi2nd
Bvec = dir(fullfile(dwi2nd,'*.bvec')); 
Bval = dir(fullfile(dwi2nd,'*.bval'));
Dwi2nd = dir(fullfile(dwi2nd,'*iso.nii.gz'));
copyfile(fullfile(dwi2nd,Bvec.name),fullfile(RawFolder,'dwi2nd.bvec'));
copyfile(fullfile(dwi2nd,Bval.name),fullfile(RawFolder,'dwi2nd.bval'));
copyfile(fullfile(dwi2nd,Dwi2nd.name),fullfile(RawFolder,'dwi2nd.nii.gz'));

% T1
T1 = dir(fullfile(SUBJECT,'t1*iso.nii.gz'));
copyfile(T1.name,'t1.nii.gz');

% See also ACH_Preprocess

