function VoxelWise2

%%
cd('/home/ganka/git/AMD/DiffusionMeasure/voxelwise2')
load Central
load Peripheral
load Intsct

%% Convert zero to nan

Central.FA(Central.FA ==0)=nan;
Central.MD(Central.MD ==0)=nan;
Central.AD(Central.AD ==0)=nan;
Central.RD(Central.RD ==0)=nan;

Intsct.FA(Intsct.FA ==0)=nan;
Intsct.MD(Intsct.MD ==0)=nan;
Intsct.AD(Intsct.AD ==0)=nan;
Intsct.RD(Intsct.RD ==0)=nan;

Peripheral.FA(Peripheral.FA ==0)=nan;
Peripheral.MD(Peripheral.MD ==0)=nan;
Peripheral.AD(Peripheral.AD ==0)=nan;
Peripheral.RD(Peripheral.RD ==0)=nan;

%%

[h,p] = ttest2(Central.FA(1:8,:),Central.FA(9:20,:),'Vartype','unequal');

%% Cental
mrvNewGraphWin
hold on;
x = [1,2];
y = nanmean(Central.FA,2);

h =bar(x,[mean(y(1:8)),mean(y(9:20))],0.3);
% [h,p] = ttest2(Central.FA(1:8),Central.FA(9:end),'Vartype','unequal');

title('Central wo intersecting voxels')
ylabel('FA')
set(gca,'xtick',[1,2],'xtickLabel',{'Patient','Healthy'})
set(gca,'ytick',[0:0.1:0.3]);
hold off;

saveas(gca,'CentralwoIntersectingVoxels.eps','psc2')

%% Intersect
mrvNewGraphWin
hold on;
x = [1,2];
y = nanmean(Intsct.FA,2);

h =bar(x,[mean(y(1:8)),mean(y(9:20))],0.3);

title('Intersecting voxels')
ylabel('FA')
set(gca,'xtick',[1,2],'xtickLabel',{'Patient','Healthy'})
set(gca,'ytick',[0:0.1:0.3]);
hold off;

saveas(gca,'IntersectingVoxels.eps','psc2')
%% Peripheral
mrvNewGraphWin
hold on;
x = [1,2];
y = nanmean(Peripheral.FA,2);

h =bar(x,[mean(y(1:8)),mean(y(9:20))],0.3);

title('Peripheral wo intersecting voxels')
ylabel('FA')
set(gca,'xtick',[1,2],'xtickLabel',{'Patient','Healthy'})
set(gca,'ytick',[0:0.1:0.3]);
hold off;

saveas(gca,'PeripheralwoIntersectingVoxels.eps','psc2')




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
