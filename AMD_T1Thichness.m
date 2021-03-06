function AMD_T1Thichness


% SO@ACH 2017/07/07



%% Label names
%  These should be located in your subject directory/fsaverage/label folder.
%  Be sure you copy and pasted the fsaverage folder to your subject
%  directory and it is not just the symbolic link
[home, list] = SubJect;

%%
for i =1:9
    labelslh{i} = sprintf('%d_LH_V1.label',i);
    labelsrh{i} = sprintf('%d_RH_V1.label',i);
end

%%
labelslh = {'1_W_LH_V1.label' '3_W_LH_V1.label' '5_W_LH_V1.label' '7_W_LH_V1.label'...
    '2_W_LH_V1.label' '4_W_LH_V1.label' '6_W_LH_V1.label' '8_W_LH_V1.label' '9_W_LH_V1.label' ...
    '1_S_LH_V1.label' '3_S_LH_V1.label' '5_S_LH_V1.label' '7_S_LH_V1.label'...
    '2_S_LH_V1.label' '4_S_LH_V1.label' '6_S_LH_V1.label' '8_S_LH_V1.label' '9_S_LH_V1.label'...
    '1_P_LH_V1.label' '3_P_LH_V1.label' '5_P_LH_V1.label' '7_P_LH_V1.label'...
    '2_P_LH_V1.label' '4_P_LH_V1.label' '6_P_LH_V1.label' '8_P_LH_V1.label' '9_P_LH_V1.label' };

labelsrh = {'1_W_RH_V1.label' '3_W_RH_V1.label' '5_W_RH_V1.label' '7_W_RH_V1.label'...
    '2_W_RH_V1.label' '4_W_RH_V1.label' '6_W_RH_V1.label' '8_W_RH_V1.label' '9_W_RH_V1.label' ...
    '1_S_RH_V1.label' '3_S_RH_V1.label' '5_S_RH_V1.label' '7_S_RH_V1.label'...
    '2_S_RH_V1.label' '4_S_RH_V1.label' '6_S_RH_V1.label' '8_S_RH_V1.label' '9_S_RH_V1.label'...
    '1_P_RH_V1.label' '3_P_RH_V1.label' '5_P_RH_V1.label' '7_P_RH_V1.label'...
    '2_P_RH_V1.label' '4_P_RH_V1.label' '6_P_RH_V1.label' '8_P_RH_V1.label' '9_P_RH_V1.label' };



%% load
load('Stats.mat')
celldisp(lh.SubName)
%%
AMD =1:8;
AMD_C = 9:12;
Ctl   = [34:43, 49, 60];
Glc   = [44, 46];
JMD   = [61:75];
LHON  = [76:95,97];
RP    = [98:101,103:111];

%% Surf Area
figure;hold on;
%Surf Area
SF = nanmean(lh.SurfArea(AMD,:));
SF_std = nanstd(lh.SurfArea(AMD,:));
errorbar(1:9, SF, SF_std)

% SF = nanmean(lh.SurfArea(LHON,:));
% SF_std = nanstd(lh.SurfArea(LHON,:));
% errorbar(1:9, SF, SF_std)
% 
% SF = nanmean(lh.SurfArea(RP,:));
% SF_std = nanstd(lh.SurfArea(RP,:));
% errorbar(1:9, SF, SF_std)

% SF = nanmean(lh.SurfArea(Glc,:));
% SF_std = nanstd(lh.SurfArea(Glc,:));
% errorbar(1:9, SF, SF_std)


SF = nanmean(lh.SurfArea([Ctl,AMD_C],:));
SF_std = nanstd(lh.SurfArea([Ctl,AMD_C],:));
errorbar(1:9, SF, SF_std,'k')

% SF = nanmean(lh.SurfArea(AMD_C,:));
% SF_std = nanstd(lh.SurfArea(AMD_C,:));
% errorbar(1:9, SF, SF_std)

% legend({'AMD','LHON','RP','Glc','Ctl','AMD_C'})
% legend({'AMD','LHON','RP','Ctl'})
legend({'AMD','Ctl'})


title('Surf Area lh')
ylabel('[mm^2]')
xlabel('V1 eccentricity')
%% %% Surf Area
figure;hold on;
%Surf Area
SF = nanmean(rh.SurfArea(AMD,:));
SF_std = nanstd(rh.SurfArea(AMD,:));
errorbar(1:9, SF, SF_std)

% SF = nanmean(lh.SurfArea(LHON,:));
% SF_std = nanstd(lh.SurfArea(LHON,:));
% errorbar(1:9, SF, SF_std)
% 
% SF = nanmean(lh.SurfArea(RP,:));
% SF_std = nanstd(lh.SurfArea(RP,:));
% errorbar(1:9, SF, SF_std)

% SF = nanmean(lh.SurfArea(Glc,:));
% SF_std = nanstd(lh.SurfArea(Glc,:));
% errorbar(1:9, SF, SF_std)


SF = nanmean(rh.SurfArea([Ctl,AMD_C],:));
SF_std = nanstd(rh.SurfArea([Ctl,AMD_C],:));
errorbar(1:9, SF, SF_std,'k')

% SF = nanmean(lh.SurfArea(AMD_C,:));
% SF_std = nanstd(lh.SurfArea(AMD_C,:));
% errorbar(1:9, SF, SF_std)

% legend({'AMD','LHON','RP','Glc','Ctl','AMD_C'})
% legend({'AMD','LHON','RP','Ctl'})
legend({'AMD','Ctl'})


title('Surf Area rh')
ylabel('[mm^2]')
xlabel('V1 eccentricity')
 %% merged Surf Area
figure;hold on;
%Surf Area
SF = nanmean([rh.SurfArea(AMD,:);lh.SurfArea(AMD,:)]);
SF_std = nanstd([rh.SurfArea(AMD,:);lh.SurfArea(AMD,:)]);
errorbar(1:9, SF, SF_std)

SF = nanmean([lh.SurfArea([Ctl,AMD_C],:); rh.SurfArea([Ctl,AMD_C],:)]);
SF_std = nanstd([lh.SurfArea([Ctl,AMD_C],:); rh.SurfArea([Ctl,AMD_C],:)]);
errorbar(1:9, SF, SF_std,'k')

legend({'AMD','Ctl'})

title('Surf Area bh')
ylabel('[mm^2]')
xlabel('V1 eccentricity')



%% ThickAvg
figure;hold on;
%Surf Area
SF = nanmean(lh.ThickAvg(AMD,:));
SF_std = nanstd(lh.ThickAvg(AMD,:));
errorbar(1:9, SF, SF_std)


SF = nanmean(lh.ThickAvg([Ctl,AMD_C],:));
SF_std = nanstd(lh.ThickAvg([Ctl,AMD_C],:));
errorbar(1:9, SF, SF_std,'k')

% legend({'AMD','LHON','RP','Glc','Ctl','AMD_C'})
% legend({'AMD','LHON','RP','Ctl'})
legend({'AMD','Ctl'})


title('ThickAvg lh')
ylabel('[mm]')
xlabel('V1 eccentricity')

%% ThickAvg
figure;hold on;
%Surf Area
SF = nanmean([lh.ThickAvg(AMD,:);rh.ThickAvg(AMD,:)]);
SF_std = nanstd([lh.ThickAvg(AMD,:);rh.ThickAvg(AMD,:)]);
errorbar(1:9, SF, SF_std)


SF = nanmean([lh.ThickAvg([Ctl,AMD_C],:);rh.ThickAvg([Ctl,AMD_C],:)]);
SF_std = nanstd([lh.ThickAvg([Ctl,AMD_C],:);rh.ThickAvg([Ctl,AMD_C],:)]);
errorbar(1:9, SF, SF_std,'k')

% legend({'AMD','LHON','RP','Glc','Ctl','AMD_C'})
% legend({'AMD','LHON','RP','Ctl'})
legend({'AMD','Ctl'})


title('ThickAvg bh')
ylabel('[mm]')
xlabel('V1 eccentricity')

%% GrayVol

figure;hold on;
%Surf Area
SF = nanmean([lh.GrayVol(AMD,:); rh.GrayVol(AMD,:)]);
SF_std = nanstd([lh.GrayVol(AMD,:); rh.GrayVol(AMD,:)]);
errorbar(1:9, SF, SF_std)

SF = nanmean([lh.GrayVol(LHON,:); rh.GrayVol(LHON,:)]);
SF_std = nanstd([lh.GrayVol(LHON,:);rh.GrayVol(LHON,:)]);
errorbar(1:9, SF, SF_std)

SF = nanmean([lh.GrayVol(RP,:);rh.GrayVol(RP,:)]);
SF_std = nanstd([lh.GrayVol(RP,:);rh.GrayVol(RP,:)]);
errorbar(1:9, SF, SF_std)

SF = nanmean([lh.GrayVol(Glc,:);rh.GrayVol(Glc,:)]);
SF_std = nanstd([lh.GrayVol(Glc,:);rh.GrayVol(Glc,:)]);
errorbar(1:9, SF, SF_std)


SF = nanmean([lh.GrayVol(Ctl,:);rh.GrayVol(Ctl,:)]);
SF_std = nanstd([lh.GrayVol(Ctl,:);rh.GrayVol(Ctl,:)]);
errorbar(1:9, SF, SF_std)

SF = nanmean([lh.GrayVol(AMD_C,:);rh.GrayVol(AMD_C,:)]);
SF_std = nanstd([lh.GrayVol(AMD_C,:);rh.GrayVol(AMD_C,:)]);
errorbar(1:9, SF, SF_std)

SF = nanmean([lh.GrayVol([Ctl, AMD_C],:); rh.GrayVol([Ctl, AMD_C],:)]);
SF_std = nanstd([lh.GrayVol([Ctl, AMD_C],:); rh.GrayVol([Ctl, AMD_C],:)]);
errorbar(1:9, SF, SF_std,'k')

legend({'AMD','LHON','RP','Glc','Ctl','AMD_C'})
title('GrayVol')
ylabel('')
xlabel('V1 GrayVol')

%% AMD GrayVol

figure;hold on;
%Surf Area
SF = nanmean([lh.GrayVol(AMD,:); rh.GrayVol(AMD,:)]);
SF_std = nanstd([lh.GrayVol(AMD,:); rh.GrayVol(AMD,:)]);
errorbar(1:9, SF, SF_std)
% 
% SF = nanmean([lh.GrayVol(LHON,:); rh.GrayVol(LHON,:)]);
% SF_std = nanstd([lh.GrayVol(LHON,:);rh.GrayVol(LHON,:)]);
% errorbar(1:9, SF, SF_std)
% 
% SF = nanmean([lh.GrayVol(RP,:);rh.GrayVol(RP,:)]);
% SF_std = nanstd([lh.GrayVol(RP,:);rh.GrayVol(RP,:)]);
% errorbar(1:9, SF, SF_std)
% 
% SF = nanmean([lh.GrayVol(Glc,:);rh.GrayVol(Glc,:)]);
% SF_std = nanstd([lh.GrayVol(Glc,:);rh.GrayVol(Glc,:)]);
% errorbar(1:9, SF, SF_std)
% 
% 
% SF = nanmean([lh.GrayVol(Ctl,:);rh.GrayVol(Ctl,:)]);
% SF_std = nanstd([lh.GrayVol(Ctl,:);rh.GrayVol(Ctl,:)]);
% errorbar(1:9, SF, SF_std)
% 
% SF = nanmean([lh.GrayVol(AMD_C,:);rh.GrayVol(AMD_C,:)]);
% SF_std = nanstd([lh.GrayVol(AMD_C,:);rh.GrayVol(AMD_C,:)]);
% errorbar(1:9, SF, SF_std)
% 
SF = nanmean([lh.GrayVol([Ctl, AMD_C],:); rh.GrayVol([Ctl, AMD_C],:)]);
SF_std = nanstd([lh.GrayVol([Ctl, AMD_C],:); rh.GrayVol([Ctl, AMD_C],:)]);
errorbar(1:9, SF, SF_std,'k')

% legend({'AMD','LHON','RP','Glc','Ctl','AMD_C'})
legend({'AMD','Ctl'})

title('GrayVol')
ylabel('')
xlabel('V1 GrayVol')



%% LHON
figure; hold on;
plot(lh.GrayVol(LHON, :))
