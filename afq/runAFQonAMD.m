function runAFQonAMD
%
% run AFQ pipeline on AMD and AMD controls
%
% SO@ACH 

AFQdata = '/media/USB_HDD1/dMRI_data';

subs = {...
    'AMD-01-dMRI-Anatomy-dMRI'
    'AMD-02-YM-dMRI-Anatomy'
    'AMD-03-CK-68yo-dMRI-Anatomy'
    'AMD-04-KM-72yo-dMRI-Anatomy'
    'AMD-05-YH-84yo-dMRI-Anatomy'
    'AMD-06-KS-79yo-dMRI-Anatomy'
    'AMD-07-KT-dMRI-Anatomy'
    'AMD-08-YA-20150426'
    'AMD-Ctl01-HM-dMRI-Anatomy-2014-09-09'
    'AMD-Ctl02-YM-dMRI-Anatomy-2014-09-09'
    'AMD-Ctl03-TS-dMRI-Anatomy-2014-10-28'
    'AMD-Ctl04-AO-61yo-dMRI-Anatomy'
    'AMD-Ctl05-TM-71yo-dMRI-Anatomy'
    'AMD-Ctl06-YM-66yo-dMRI-Anatomy'
    'AMD-Ctl07-MS-61yo-dMRI-Anatomy'
    'AMD-Ctl08-HO-62yo-dMRI-Anatomy'
    'AMD-Ctl09-KH-70yo-dMRI-Anatomy-dMRI'
    'AMD-Ctl10-TH-65yo-dMRI-Anatomy-dMRI'
    'AMD-Ctl11-YMS-64yo-dMRI-Anatomy'
    'AMD-Ctl12-YT-f59yo-20150222'};   
    


%% Make directory structure for each subject
for ii = 1:length(subs)
    sub_dirs{ii} = fullfile(AFQdata, subs{ii},'dwi_1st');
end

% Subject grouping is a little bit funny because afq only takes two groups
% but we have 3. For now we will divide it up this way but we can do more
% later
Pa  = ones(1,8);
Ct = zeros(1,12);
sub_group = [Pa, Ct];

% Now create and afq structure
afq = AFQ_Create('sub_dirs', sub_dirs, 'sub_group', sub_group, 'clip2rois', 1,'normalization','ants');

% afq.params.cutoff=[5 95];
afq.params.outdir = ...
fullfile('/home/ganka/git/AMD/afq');
% afq.params.outname = 'afq.mat';
% afq.params.computeCSD = 1;
% afq.params.track.faMaskThresh = 0.09;
%% Run AFQ on these subjects
afq = AFQ_run(sub_dirs, sub_group, afq);

% Add callosal fibers
afq = AFQ_SegmentCallosum(afq);

%%%%%%%%%%%%%%%%%%%%%%%%%





%% Add NODDI maps
% create a cell array of paths to each subjects image.
imgDir ='/media/USB_HDD1/AMICO/AMICO';

% subs
for jj = 1:length(subs)
    OD{jj}  = fullfile(imgDir, subs{jj},'AMICO/NODDI' ,'FIT_OD.nii.gz');
    DIR{jj}  = fullfile(imgDir, subs{jj},'AMICO/NODDI' , 'FIT_dir.nii.gz');
    ICVF{jj} = fullfile(imgDir, subs{jj},'AMICO/NODDI' , 'FIT_ICVF.nii.gz');
    ISOVF{jj} = fullfile(imgDir, subs{jj},'AMICO/NODDI' , 'FIT_ISOVF.nii.gz');
end
  
afq = AFQ_set(afq, 'images', OD);
afq = AFQ_set(afq, 'images', DIR);
afq = AFQ_set(afq, 'images', ICVF);
afq = AFQ_set(afq, 'images', ISOVF);


%%
afq = AFQ_set(afq,'overwritevals',1:length(subs));
afq = AFQ_run(sub_dirs, sub_group,afq);



