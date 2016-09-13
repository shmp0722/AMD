function GetReadytoAFQ

% Get ready to run AFQ_AddNewFibers


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
for ii = 1:20
    s1 = dir(fullfile(AFQdata,subs{ii},'dwi_1st/fibers/OT_MD32/LOT*'));
    s2 = dir(fullfile(AFQdata,subs{ii},'dwi_1st/fibers/OT_MD32/ROT*'));
    
    OT1 = fgRead(fullfile(AFQdata,subs{ii},'dwi_1st/fibers/OT_MD32',s1.name));
    OT1.name = 'LOT_MD32';
    OT1.pathwayInfo =[];
    
    NumFibers = length(OT1.fibers);
    while length(OT1.fibers)<6;
        for jj = 1:NumFibers
            OT1.fibers{length(OT2.fibers)+1} = OT1.fibers{jj};
        end
    end
    
    OT2 = fgRead(fullfile(AFQdata,subs{ii},'dwi_1st/fibers/OT_MD32',s2.name));
    OT2.name = 'ROT_MD32';
    OT2.pathwayInfo =[];
    
    NumFibers = length(OT2.fibers);
    while length(OT2.fibers)<6;
        for jj = 1:NumFibers
            OT2.fibers{length(OT2.fibers)+1} = OT2.fibers{jj};
        end
    end
    
    fgWrite(OT1,fullfile(AFQdata,subs{ii},'dwi_1st/fibers', [OT1.name,'.mat']))
    fgWrite(OT2,fullfile(AFQdata,subs{ii},'dwi_1st/fibers', [OT2.name,'.mat']))
end


