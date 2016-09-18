function VoxelWise3

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

%%
Central.mFA = nanmean(Central.FA,2);
Central.mMD = nanmean(Central.MD,2);
Central.mAD = nanmean(Central.AD,2);
Central.mRD = nanmean(Central.RD,2);

Peripheral.mFA = nanmean(Peripheral.FA,2);
Peripheral.mMD = nanmean(Peripheral.MD,2);
Peripheral.mAD = nanmean(Peripheral.AD,2);
Peripheral.mRD = nanmean(Peripheral.RD,2);

%% describe stats 
% hist
Pa =1:8;
Ctl = 9:20;

%% Central portion mean by patient 
 [h,p,ci,stats] =ttest2( Central.mFA(Pa),Central.mFA(Ctl))
 [h,p,ci,stats] =ttest2( Central.mAD(Pa),Central.mAD(Pa))
 [h,p,ci,stats] =ttest2( Central.mRD(Pa),Central.mRD(Pa))

 % Central AD is significantly different

%% Peripheral portion
[h,p,ci,stats] =ttest2( Peripheral.mFA(Pa),Peripheral.mFA(Ctl))
[h,p,ci,stats] =ttest2( Peripheral.mAD(Pa),Peripheral.mAD(Pa))
[h,p,ci,stats] =ttest2( Peripheral.mRD(Pa),Peripheral.mRD(Pa))

 % Peripheral RD is sginificantly different
 
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
 
%% central portion
figure; hold on;
y(1) =  nanmean(Central.patients.FA); 
y(2) =  nanmean(Central.controls.FA);

sd(1) = nanstd(Central.patients.FA);
sd(2) = nanstd(Central.controls.FA);

errorbar([1,2],y,sd)

title('Voxel base comparison')
set(gca,'YLim',[0 0.6],'YTick',[0 0.6],...
    'XTickLabel',{'Pa','Ctl'})
ylabel('FA')

%% Peripheral portion



%% 
 [h,p,ci,stats] =ttest2( Central.patients.FA,Central.controls.FA);
 [h,p,ci,stats] =ttest2( Peripheral.patients.FA,Peripheral.controls.FA);

%%
% FIX FIX FIX Shumpei we need to make sure what comes after here is consistent with the new code above. %
%% controls vs AMD
valname = fieldnames(Central);

for v = 1:4
    mrvNewGraphWin
    % FA
    % subplot(1,3,1)
    hold on;
    
    % Errorbars
    Err1 = [std(Central.controls.(valname{v})),std(Central.patients.(valname{v}))];
    eb1 = errorbar([.9,1.9],[mean(Central.controls.(valname{v}));...
        mean(Central.patients.(valname{v}))],Err1,'ro','markerfacecolor','r','markersize',15);
    
    Err2 = [std(Peripheral.controls.(valname{v})),std(Peripheral.patients.(valname{v}))];
    eb2 = errorbar([1.1, 2.1],[mean(Peripheral.controls.(valname{v}));...
        mean(Peripheral.patients.(valname{v}))],Err2,'bo','markerfacecolor','b','markersize',15);
    
    % title('Central wo intersecting voxels')
    ylabel(sprintf(valname{v}))
    set(gca,'xtick',[1,2],'xtickLabel',{'Control','Patient'}, 'xlim', [.5 2.5],...
        'tickdir','out');
    YLIM =  get(gca,'ylim');
    set(gca,'YLim',YLIM,'YTick',YLIM )
    
    % legend
   lg1 = legend([eb1,eb2],'Central','Peripheral','Posi');
   set(lg1,'Position',[0.78 0.83 0.2 0.1],'Box','off')
   hold off;
end
% 
% % AD
% % subplot(1,3,2)
% hold on;
% Err1 = [std(Central.controls.AD),std(Central.patients.AD)];
% eb1 = errorbar([.9,1.9],[mean(Central.controls.AD);mean(Central.patients.AD)],Err1,'ro','markerfacecolor','r','markersize',15);
% 
% Err2 = [std(Peripheral.controls.AD),std(Peripheral.patients.AD)];
% eb2 = errorbar([1.1, 2.1],[mean(Peripheral.controls.AD);mean(Peripheral.patients.AD)],Err2,'bo','markerfacecolor','b','markersize',15);
% 
% % title('Central wo intersecting voxels')
% ylabel('AD')
% set(gca,'xtick',[1,2],'xtickLabel',{'Control','Patient'}, 'xlim', [.5 2.5],... 
% 'tickdir','out');
% YLIM =  get(gca,'ylim');
% set(gca,'YLim',YLIM,'YTick',YLIM )
% end
% 
% % RD
% subplot(1,3,3)
% hold on;
% Err1 = [std(Central.controls.RD),std(Central.patients.RD)];
% eb1 = errorbar([.9,1.9],[mean(Central.controls.RD);mean(Central.patients.RD)],Err1,'ro','markerfacecolor','r','markersize',15);
% 
% Err2 = [std(Peripheral.controls.RD),std(Peripheral.patients.RD)];
% eb2 = errorbar([1.1, 2.1],[mean(Peripheral.controls.RD);mean(Peripheral.patients.RD)],Err2,'bo','markerfacecolor','b','markersize',15);
% 
% % title('Central wo intersecting voxels')
% ylabel('RD')
% set(gca,'xtick',[1,2],'xtickLabel',{'Control','Patient'}, 'xlim', [.5 2.5],... 
% 'tickdir','out');
% YLIM =  get(gca,'ylim');
% set(gca,'YLim',YLIM,'YTick',YLIM )
% end



lg1 = legend([eb1,eb2],'Central','Peripheral','Posi');
set(lg1,'Position',[0.78 0.83 0.2 0.1],'Box','off')
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
