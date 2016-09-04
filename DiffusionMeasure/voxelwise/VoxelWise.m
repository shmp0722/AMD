function VoxelWise

%%
cd('/home/ganka/git/AMD/DiffusionMeasure/voxelwise')
load Central
load Peripheral
load Intsct

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
mrvNewGraphWin
hold on;
x = [1,2];
y = [mean(Central.FA(1:8)),mean(Central.FA(9:end))];

bar(x,y,0.3)
[h,p] = ttest2(Central.FA(1:8),Central.FA(9:end),'Vartype','unequal');

title('Merged Central 0-3')
hold off;

mrvNewGraphWin
hold on;
bar([1:2],[mean(Intsct.FA(1:8)),mean(Intsct.FA(9:end))],0.3)

title('Intersect')
hold off

mrvNewGraphWin
hold on;
bar([1:2],[mean(Peripheral.FA(1:8)),mean(Peripheral.FA(9:end))],0.3)
title('Peripheral')
hold off

%%


set(gca,'xlim',[0,3],'xtick',{'','Patient','Healthy',''})


