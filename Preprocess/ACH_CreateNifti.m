function ACH_CreateNifti

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

[Home, subDir] = fileparts(pwd);
 cur_sub = fullfile(Home,subDir);

!mkdir DICOM DICOM/T1w DICOM/T2w DICOM/dwi1st DICOM/dwi2nd DICOM/dwi32ch_AP DICOM/dwi32ch_PA
!mkdir raw T1w T2w dwi_1st dwi_2nd dwi32ch_AP dwi32ch_PA
%% if notDefined('SUBJECT')
%  [Home, subDir] = fileparts(pwd);
%  cur_sub = fullfile(Home,subDir);
 
 % set directories
 T1 = fullfile(cur_sub,'T1w');if ~exist(T1,'dir');mkdir(T1);end;
 T2 = fullfile(cur_sub,'T2w');if ~exist(T2,'dir');mkdir(T2);end;
 dwi1st = fullfile(cur_sub,'dwi_1st');if ~exist(dwi1st,'dir');mkdir(dwi1st);end;
 dwi2nd = fullfile(cur_sub,'dwi_2nd');if ~exist(dwi2nd,'dir');mkdir(dwi2nd);end;
 dwi32ch_AP = fullfile(cur_sub,'dwi32ch_AP');if ~exist(dwi32ch_AP,'dir');mkdir(dwi32ch_AP);end;
 dwi32ch_PA = fullfile(cur_sub,'dwi32ch_PA');if ~exist(dwi32ch_PA,'dir');mkdir(dwi32ch_PA);end;
 
% end

outFormat = 'nii.gz';

% create nii.gz files 
if ~exist(fullfile(cur_sub,'t1.nii.gz'),'file')
 dicm2nii(T1, cur_sub, outFormat)
 dicm2nii(T2, cur_sub, outFormat)
end

if exist(dwi1st,'dir');
dicm2nii(dwi1st, dwi1st, outFormat);end
if exist(dwi2nd,'dir');
dicm2nii(dwi2nd, dwi2nd, outFormat);end;
if exist(dwi32ch_PA,'dir');
dicm2nii(dwi32ch_PA, dwi32ch_PA, outFormat);end
if exist(dwi32ch_AP,'dir');
dicm2nii(dwi32ch_AP, dwi32ch_AP, outFormat);end


%% make raw foldef under SUBJECT folder

RawFolder = fullfile(cur_sub,'raw');
if ~exist(RawFolder)
 mkdir(fullfile(cur_sub,'raw'))
end

%% change file names 

% dwi1st
if exist(dwi1st,'dir');
Bvec = dir(fullfile(dwi1st,'*.bvec')); 
Bval = dir(fullfile(dwi1st,'*.bval'));
Dwi1st = dir(fullfile(dwi1st,'*iso.nii.gz'));
copyfile(fullfile(dwi1st,Bvec.name),fullfile(RawFolder,'dwi1st.bvec'));
copyfile(fullfile(dwi1st,Bval.name),fullfile(RawFolder,'dwi1st.bval'));
copyfile(fullfile(dwi1st,Dwi1st.name),fullfile(RawFolder,'dwi1st.nii.gz'));
clear Bval Bvec
end
% dwi2nd
if ~exist('Bval') % waiting for finishing previous step completely 
    Bvec = dir(fullfile(dwi2nd,'*.bvec'));
    Bval = dir(fullfile(dwi2nd,'*.bval'));
    Dwi2nd = dir(fullfile(dwi2nd,'*iso.nii.gz'));
    copyfile(fullfile(dwi2nd,Bvec.name),fullfile(RawFolder,'dwi2nd.bvec'));
    copyfile(fullfile(dwi2nd,Bval.name),fullfile(RawFolder,'dwi2nd.bval'));
    copyfile(fullfile(dwi2nd,Dwi2nd.name),fullfile(RawFolder,'dwi2nd.nii.gz'));
    clear Bval Bvec
end

% dwi32ch_AP
if ~exist('Bval') % waiting for finishing previous step completely 
    Bvec = dir(fullfile(dwi32ch_AP,'*.bvec'));
    Bval = dir(fullfile(dwi32ch_AP,'*.bval'));
    Dwi2nd = dir(fullfile(dwi32ch_AP,'*107.nii.gz'));
    copyfile(fullfile(dwi32ch_AP,Bvec.name),fullfile(RawFolder,'dwi32ch_AP.bvec'));
    copyfile(fullfile(dwi32ch_AP,Bval.name),fullfile(RawFolder,'dwi32ch_AP.bval'));
    copyfile(fullfile(dwi32ch_AP,Dwi2nd.name),fullfile(RawFolder,'dwi32ch_AP.nii.gz'));
    clear Bval Bvec
end

% dwi32ch_PA
if ~exist('Bval') % waiting for finishing previous step completely 
    Bvec = dir(fullfile(dwi32ch_PA,'*.bvec'));
    Bval = dir(fullfile(dwi32ch_PA,'*.bval'));
    Dwi2nd = dir(fullfile(dwi32ch_PA,'*107.nii.gz'));
    copyfile(fullfile(dwi32ch_PA,Bvec.name),fullfile(RawFolder,'dwi32ch_PA.bvec'));
    copyfile(fullfile(dwi32ch_PA,Bval.name),fullfile(RawFolder,'dwi32ch_PA.bval'));
    copyfile(fullfile(dwi32ch_PA,Dwi2nd.name),fullfile(RawFolder,'dwi32ch_PA.nii.gz'));
    clear Bval Bvec
end


% T1
if ~exist(fullfile(cur_sub,'t1.nii.gz'))
    try
        T1 = dir(fullfile(cur_sub,'t1*iso.nii.gz'));
        copyfile(T1.name,'t1.nii.gz');
    catch
        T1 = dir(fullfile(cur_sub,'T1w','t1*iso.nii.gz'));
        copyfile(fullfile(cur_sub,'T1w',T1.name),fullfile(pwd,'t1.nii.gz'));
    end
end
% See also ACH_Preprocess

return
