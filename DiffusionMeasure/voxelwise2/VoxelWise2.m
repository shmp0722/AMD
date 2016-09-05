function VoxelWise2

%%
% cd('/home/ganka/git/AMD/DiffusionMeasure/voxelwise2')
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
for ii = 1:length(FN)
    Central.patients.(FN{ii}) = Central.(FN{ii})(1:8,:);
    Central.patients.(FN{ii}) = Central.patients.(FN{ii})(~isnan(Central.patients.(FN{ii})));
    Central.controls.(FN{ii}) = Central.(FN{ii})(9:20,:);
    Central.controls.(FN{ii}) = Central.controls.(FN{ii})(~isnan(Central.controls.(FN{ii})));
    [Central.tests.(FN{ii}).h, ...
     Central.tests.(FN{ii}).p] = ttest2(Central.patients.(FN{ii}),Central.controls.(FN{ii}),'Vartype','unequal');
end

for ii = 1:length(FN)
    Peripheral.patients.(FN{ii}) = Peripheral.(FN{ii})(1:8,:);
    Peripheral.patients.(FN{ii}) = Peripheral.patients.(FN{ii})(~isnan(Peripheral.patients.(FN{ii})));
    Peripheral.controls.(FN{ii}) = Peripheral.(FN{ii})(9:20,:);
    Peripheral.controls.(FN{ii}) = Peripheral.controls.(FN{ii})(~isnan(Peripheral.controls.(FN{ii})));
    [Peripheral.tests.(FN{ii}).h, ...
     Peripheral.tests.(FN{ii}).p] = ttest2(Peripheral.patients.(FN{ii}),Peripheral.controls.(FN{ii}),'Vartype','unequal');
end
%% ttest(2groups)
 
 hist(Central.patients.FA)
 hist(Central.controls.FA)
 [h,p,ci,stats] =ttest2( Central.patients.FA,Central.controls.FA)

 
 [h,p,ci,stats] =ttest2( Peripheral.patients.FA,Peripheral.controls.FA)

%%
% FIX FIX FIX Shumpei we need to make sure what comes after here is consistent with the new code above. %
%% controls vs AMD
mrvNewGraphWin
hold on;

% Errorbars
Err = [std(Central.controls.FA),std(Central.patients.FA)];
eb1 = errorbar([.9,1.9],[mean(Central.controls.FA);mean(Central.patients.FA)],Err,'ro','markerfacecolor','r','markersize',15);

Err = [std(Peripheral.controls.FA),std(Peripheral.patients.FA)];
eb2 = errorbar([1.1, 2.1],[mean(Peripheral.controls.FA);mean(Peripheral.patients.FA)],'bo','markerfacecolor','b','markersize',15);

% title('Central wo intersecting voxels')
ylabel('FA')
set(gca,'xtick',[1,2],'xtickLabel',{'Control','Patient'}, 'xlim', [.5 2.5],... 
'ytick',[0 2.5], 'ylim',[0 2.5],'tickdir','out');

lg1 = legend([eb1,eb2],'Central','Peripheral','Posi');
set(lg1,'Position',[0.78 0.83 0.2 0.1])
hold off;

%%
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


%%
% plot([.9,1.9],[mean(Central.controls.FA);mean(Central.patients.FA)],'ro','markerfacecolor','r','markersize',15);
% Errorbars
% plot([[.9,1.9],[.9, 1.9]], ...
%     [[mean(Central.controls.FA);mean(Central.patients.FA)]-[std(Central.controls.FA);std(Central.patients.FA)], ...
%     [[mean(Central.controls.FA);mean(Central.patients.FA)]+[std(Central.controls.FA);std(Central.patients.FA)]]], ...
%     'ro','markerfacecolor','r','markersize',15);
