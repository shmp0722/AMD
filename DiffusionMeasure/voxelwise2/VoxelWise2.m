function VoxelWise2

%%
cd('/home/ganka/git/AMD/DiffusionMeasure/voxelwise2')
load Central
load Peripheral
load Intsct

%% Convert zero to nan
%
% Replace all zeros (voxels not in OR) with nan to exclude those voxels from
% the statistical tests.
% Remove voxels from Central portion
FN = fieldnames(Central);
for ii = 1:length(FN)
    for i = 1:size(Central.FA,1);
        Central.(FN{ii})(i,Central.(FN{ii})(i,:)==0)=nan;
    end
end
% Remove voxels from peripheral portion
FN = fieldnames(Peripheral);
for ii = 1:length(FN)
    for i = 1:size(Peripheral.FA,1);
        Peripheral.(FN{ii})(i,Peripheral.(FN{ii})(i,:)==0)=nan;
    end
end

%% Try a statisitcal test (t-test)
FA.patients = Central.FA(1:8,:);
FA.patients = FA.patients(~isnan(FA.patients));
FA.controls = Central.FA(9:20,:);
FA.controls = FA.controls(~isnan(FA.controls));
[h,p] = ttest2(FA.patients,FA.controls,'Vartype','unequal');

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
