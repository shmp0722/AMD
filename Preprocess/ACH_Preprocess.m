function ACH_Preprocess(subDir, option, acpc)

% Preprocessing the diffusion MRI data obtained by SIEMENS 3T scanner in
% Tamagawa University, Machida, JAPAN
%
%  INPUTS:
%   subDir: subject directory name
%   (ex. 'LHON1-TK-20121130-DWI')
%   option:  0: default (single masurement. analyzing 'dwi.nii.gz')
%            1: analyzing first diffusion measure 'dwi1st.nii.gz'
%            2: analyzing second diffusion measure 'dwi2nd.nii.gz'
%
%   acpc;    Generate a ac-pc aligned nifti image using Talairach coordinates
% converted to MNI space. default  = false;
%
% SO @ACH
% SO 20150512 fixed small bugs

%% basedir = '/media/USB_HDD1/dMRI_data';

if notDefined('subDir')
    [basedir, subDir] = fileparts(pwd);
end

if notDefined('option')
    option = 1; %
end

if notDefined('acpc')
    acpc = 0; %
end

%% Set the optimal parameter for SIEMENS scan at Tamagawa
dwParams = dtiInitParams;
dwParams.clobber=1;
% This flipping is specifically important for SIEMENS scans
dwParams.rotateBvecsWithCanXform = 1;
dwParams.rotateBvecsWithRx = 0;
% Phase encoding direction is A/P
dwParams.phaseEncodeDir = 2; %default 2
dwParams.flipLrApFlag=0; % default = 0

%% Define folder name for 1st and 2nd scans
dt6_base_names = {'dwi', 'dwi_1st', 'dwi_2nd', 'dwi32ch_AP','dwi32ch_PA'};

subjectpath = fullfile(basedir, subDir);
cd(subjectpath);
t1File = fullfile(subjectpath, 't1.nii.gz');

%%  mrAnatAutoAlignAcpcNifti or mrAnatAverageAcpcNifti


if acpc==1;
    aligned = mrAnatAutoAlignAcpcNifti(t1File);
    copyfile(t1File,fullfile(subjectpath, 't1_orig.nii.gz'));
    delete(t1File)
    copyfile(fullfile(subjectpath, 't1_acpc.nii.gz'),fullfile(subjectpath, 't1.nii.gz'));
end;
% Make sure if Acpc alighnment was done
%
% if you do not finish it, mrAnatAverageAcpcNifti.m
%
% This mrAnatAverageAcpcNifti requires spm8 (is not latest ver.)
%
%% Set xform to raw t1 File
ni = readFileNifti(t1File);
ni1 = niftiSetQto(ni,ni.sto_xyz);
writeFileNifti(ni1);

%% Select file names
switch option
    case 0,
        rawdtiFile = fullfile(subjectpath, 'raw', 'dwi.nii.gz');
        dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'dwi.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'dwi.bval');
        %         dwParams.fitMethod = 'both';
        dwParams.fitMethod = 'ls';
        
        dwParams.dt6BaseName= dt6_base_names{1};
        dwParams.outDir = fullfile(subjectpath, 'raw');
    case 1,
        rawdtiFile = fullfile(subjectpath, 'raw', 'dwi1st.nii.gz');
        dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'dwi1st.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'dwi1st.bval');
        %         dwParams.fitMethod = 'both';
        dwParams.fitMethod = 'ls';
        dwParams.dt6BaseName= dt6_base_names{2};
        dwParams.outDir = fullfile(subjectpath);
    case 2,
        rawdtiFile = fullfile(subjectpath, 'raw', 'dwi2nd.nii.gz');
        dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'dwi2nd.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'dwi2nd.bval');
        %         dwParams.fitMethod = 'both';
        dwParams.fitMethod = 'ls';
        dwParams.dt6BaseName= dt6_base_names{3};
        dwParams.outDir = fullfile(subjectpath);
        %                 dwParams.outDir = fullfile(subjectpath, 'raw');
        
    case 3,
        rawdtiFile = fullfile(subjectpath, 'dwi32ch_AP', 'DWI_AP_dir107.nii.gz');
        dwParams.bvecsFile = fullfile(subjectpath, 'dwi32ch_AP', 'DWI_AP_dir107.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'dwi32ch_AP', 'DWI_AP_dir107.bval');
        dwParams.fitMethod = 'ls';
        dwParams.dt6BaseName= dt6_base_names{4};
        dwParams.outDir = fullfile(subjectpath);
    case 4,
        rawdtiFile = fullfile(subjectpath, 'dwi32ch_PA', 'DWI_PA_dir107.nii.gz');
        dwParams.bvecsFile = fullfile(subjectpath, 'dwi32ch_PA', 'DWI_PA_dir107.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'dwi32ch_PA', 'DWI_PA_dir107.bval');
        dwParams.fitMethod = 'ls';
        dwParams.dt6BaseName= dt6_base_names{5};
        dwParams.outDir = fullfile(subjectpath);
    case 5,
        rawdtiFile = fullfile(subjectpath, 'raw', 'DWI_AP_dir107.nii.gz');
        dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'DWI_AP_dir107.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'DWI_AP_dir107.bval');
        dwParams.fitMethod = 'ls';
        dwParams.dt6BaseName= dt6_base_names{4};
        dwParams.outDir = fullfile(subjectpath);
    case 6,
        rawdtiFile = fullfile(subjectpath, 'raw', 'DWI_PA_dir107.nii.gz');
        dwParams.bvecsFile = fullfile(subjectpath, 'raw', 'DWI_PA_dir107.bvec');
        dwParams.bvalsFile = fullfile(subjectpath, 'raw', 'DWI_PA_dir107.bval');
        dwParams.fitMethod = 'ls';
        dwParams.dt6BaseName= dt6_base_names{5};
        dwParams.outDir = fullfile(subjectpath);
end

%% Set rawdtiFile xform
ni = readFileNifti(rawdtiFile);
ni = niftiSetQto(ni,ni.sto_xyz);
writeFileNifti(ni);

%% Run dtiInit
switch option
    case {0,1,2}
        [dt6FileName, outBaseDir] = dtiInit(rawdtiFile, t1File, dwParams);
    case {3,4,5,6}
        [dt6FileName, outBaseDir] = ACH_dtiInit(rawdtiFile, t1File, dwParams);
end
