%
% 30-90 degree OR should be cleaned. 
% Cleaning fibers using AFQ Max Dist 4 is too loose to define peripheral OR.   
% may requires manual cleaning.
%
% SO@ACH 2016/8/31

%%
AFQdata = '/media/HDPC-UT/dMRI_data';

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



%%

for ii=  1:length(subs)
    SubDir = fullfile(AFQdata,subs{ii});
    fgDir  = fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_divided');
    FG     = dir(fullfile(fgDir,'*MD2*.pdb'));
    if isempty(FG)
        ACH_CleanUpTract_ORdivided(subs{ii})
    elseif length(FG)>=6
        sprintf('%s is already done',subs{ii})
    else
    end

end