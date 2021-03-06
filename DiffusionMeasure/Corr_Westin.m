function Corr_Westin(fibID)
% individual FA value along the core of OR and optic tract.
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    shmp0722/AMD
% 
% Basic theory
% 
% 'Processing and visualization for diffusion tensor MRI'
% Westin CF, Maier SE, Mamata H, Nabavi A, Jolesz FA, Kikinis R
% Med Image Anal, 2002 
%
% Shumpei Ogawa 2017@ ACH

%% load raw data and subjects
load ACH_0210.mat
AMD = 1:8;
AMD_Ctl = 9:20;
%% argument check
fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
    'LOR30-90','ROR30-90'};
if notDefined('fibID')
    fibID = 1;
end

if notDefined('SavePath')
    SavePath = pwd;
end

%% Figure
% indivisual FA value along optic tract

% container
nodes =  length(ACH{10,fibID}.vals.fa);
fa = nan(length(ACH), nodes);
md = fa;
ad = fa;
rd = fa;
cl = fa;
pl = fa;
sp = fa;
% get values and merge both hemisphere
for subID = 1:length(ACH);
    if isempty(ACH{subID,fibID});
        fa(subID,:) =nan(1,nodes);
    else
        fa(subID,:) =  nanmean([ACH{subID,fibID}.vals.fa;...
            ACH{subID,fibID+1}.vals.fa]);
    end;
    
    if isempty(ACH{subID,fibID});
        md(subID,:) =nan(1,nodes);
    else
        md(subID,:) = nanmean([ ACH{subID,fibID}.vals.md;...
            ACH{subID,fibID+1}.vals.md]);
    end;
    
    if isempty(ACH{subID,fibID});
        rd(subID,:) =nan(1,nodes);
    else
        rd(subID,:) = nanmean([ ACH{subID,fibID}.vals.rd;...
            ACH{subID,fibID+1}.vals.rd]);
    end;
    
    if isempty(ACH{subID,fibID});
        ad(subID,:) =nan(1,nodes);
    else
        ad(subID,:) = nanmean([ ACH{subID,fibID}.vals.ad;...
            ACH{subID,fibID+1}.vals.ad]);
    end;
    
    if isempty(ACH{subID,fibID});
        cl(subID,:) =nan(1,nodes);
    else
        cl(subID,:) = nanmean([ ACH{subID,fibID}.vals.cl;...
            ACH{subID,fibID+1}.vals.cl]);
    end;
    
    if isempty(ACH{subID,fibID});
        sp(subID,:) =nan(1,nodes);
    else
        sp(subID,:) = nanmean([ ACH{subID,fibID}.vals.sphericity;...
            ACH{subID,fibID+1}.vals.sphericity]);
    end;
    
    if isempty(ACH{subID,fibID});
        pl(subID,:) =nan(1,nodes);
    else
        pl(subID,:) = nanmean([ ACH{subID,fibID}.vals.planarity;...
            ACH{subID,fibID+1}.vals.planarity]);
    end;
end

%% check 

[h p ] = corrcoef(fa(1:8,:), cl(1:8,:) ,'rows','pairwise')

[h p ] = corrcoef(fa(1:8,:), pl(1:8,:) ,'rows','pairwise')

[h p ] = corrcoef(fa(1:8,:), sp(1:8,:) ,'rows','pairwise')

%%
[h p ] = corrcoef(fa(1:20,:), cl(1:20,:) ,'rows','pairwise')

[h p ] = corrcoef(fa(1:20,:), pl(1:20,:) ,'rows','pairwise')

[h p ] = corrcoef(fa(1:20,:), sp(1:20,:) ,'rows','pairwise')


%% figure
figure;hold on;
subplot(1,3,1)
plot(fa(1:20,:), cl(1:20,:) ,'ob')
xlabel FA
ylabel ln

subplot(1,3,2)
plot(fa(1:20,:), pl(1:20,:) ,'o')
xlabel FA
ylabel pl

subplot(1,3,3)
plot(fa(1:20,:), sp(1:20,:) ,'o')
xlabel FA
ylabel sp

%% figure
figure;hold on;
subplot(1,3,1)
plot(md(1:20,:), cl(1:20,:) ,'o')
xlabel MD
ylabel ln

subplot(1,3,2)
plot(md(1:20,:), pl(1:20,:) ,'o')
xlabel MD
ylabel pl

subplot(1,3,3)
plot(md(1:20,:), sp(1:20,:) ,'o')
xlabel MD
ylabel sp

%% figure
figure;hold on;
subplot(1,3,1)
plot(ad(1:20,:), cl(1:20,:) ,'o')
xlabel AD
ylabel ln

subplot(1,3,2)
plot(ad(1:20,:), pl(1:20,:) ,'o')
xlabel AD
ylabel pl

subplot(1,3,3)
plot(ad(1:20,:), sp(1:20,:) ,'o')
xlabel AD
ylabel sp

%% figure
figure;hold on;
subplot(1,3,1)
plot(rd(1:20,:), cl(1:20,:) ,'o')
xlabel RD
ylabel ln

subplot(1,3,2)
plot(rd(1:20,:), pl(1:20,:) ,'o')
xlabel RD
ylabel pl

subplot(1,3,3)
plot(rd(1:20,:), sp(1:20,:) ,'o')
xlabel RD
ylabel sp


