function Merged_AMD_plot_DiffuisonProperty_wAmdCtl(fibID,SavePath)
% Plot figure 5 showing individual FA value along the core of OR and optic tract.
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    LHON2
%
% SO Vista lab, 2014
%
% Shumpei Ogawa 2014

%% Identify the directories and subject types in the study
% The full call can be
% [~, ~, AMD, AMD_Ctl, ~, Ctl] = SubJect;

% Load ACH data
% TPdata = '/media/HDPC-UT/dMRI_data/Results/ACH_0210.mat';
% load(TPdata);

load ACH_0210.mat
AMD= 1:8;
AMD_Ctl = 9:20;
%% argument check
if notDefined('fibID')
    fibID = 1;
end

if notDefined('SavePath')
    SavePath = pwd;
end

%% Figure
% indivisual FA value along optic tract
% if fibID< 5,
% take values
fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
    'LOR30-90','ROR30-90'};
% package to cnotain
nodes =  length(ACH{10,fibID}.vals.fa);
fa = nan(length(ACH), nodes);
md = fa;
ad = fa;
rd = fa;

%%
% make one sheet diffusivity
% merge both hemisphere
for subID = 1:length(ACH);
    if isempty(ACH{subID,fibID});
        fa(subID,:) =nan(1,nodes);
    else
        fa(subID,:) =  mean([ACH{subID,fibID}.vals.fa;...
            ACH{subID,fibID+1}.vals.fa]);
    end;
    
    if isempty(ACH{subID,fibID});
        md(subID,:) =nan(1,nodes);
    else
        md(subID,:) = mean([ ACH{subID,fibID}.vals.md;...
            ACH{subID,fibID+1}.vals.md]);
    end;
    
    if isempty(ACH{subID,fibID});
        rd(subID,:) =nan(1,nodes);
    else
        rd(subID,:) = mean([ ACH{subID,fibID}.vals.rd;...
            ACH{subID,fibID+1}.vals.rd]);
    end;
    
    if isempty(ACH{subID,fibID});
        ad(subID,:) =nan(1,nodes);
    else
        ad(subID,:) = mean([ ACH{subID,fibID}.vals.ad;...
            ACH{subID,fibID+1}.vals.ad]);
    end;
end

%% FA
val_AC = fa(AMD_Ctl,:);
val_AMD = fa(AMD,:);
AMD_data  = val_AMD;
vals ='fa';

% Wilcoxon Single rank test
group =2;
M = length(AMD_Ctl);
pac = nan(M,group);

for jj= 1: nodes
    
    pac(:,1)= val_AC(:,jj);
    pac(1:8,2)= val_AMD(:,jj);
    
    [p(jj),h(jj),~] = signrank(pac(:,1),pac(:,2));
            [P(jj),H(jj),~] =          ttest(pac(:,1),pac(:,2));
    %     co = multcompare(stats(jj),'display','off');
    %     C{jj}=co;
end

% logical 2 double
h = h+0;

%% OT FA
G = figure; hold on;
X = 1:nodes;
c = lines(length(AMD));

% Control
st = nanstd(val_AC);
m   = nanmean(val_AC,1);

% render control subjects range
A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

% set color and style
set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

plot(m,'color',[0 0 0], 'linewidth',3 )

% add individual FA plot
for k = 1:length(AMD) %1:length(subDir)
    plot(X,AMD_data(k,:),'Color',c(k,:),...
        'linewidth',1);
end
m   = nanmean(AMD_data,1);
plot(X,m,'Color',c(3,:) ,'linewidth',3)

T = title(sprintf('%s comparing to AMD_C', fbName{fibID}(3:end)));
ylabel(upper(vals))
xlabel('Location')

% axis
% if b(1)<0;b(1)=0;end;
% switch vals
%     case {}
switch fibID
    case {1}
        b=[0.1,0.8];
        % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {3}
        b=[0,0.8];
        set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {5,7,9}
          b=[0,0.8];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;        
end
clear h
% Save current figure
if ~isempty(SavePath)
    saveas(G,fullfile(SavePath, [vals,'_',T.String,'.eps']),'psc2')
    %     saveas(G,fullfile(SavePath, [vals,'_',T.String]),'bmp')
end

%% AD
%
vals ='ad';
val_AC = ad(AMD_Ctl,:);
val_AMD = ad(AMD,:);

AMD_data  = val_AMD;

%% Wilcoxon Single rank test
% container
group =2;
M = length(AMD_Ctl);
pac = nan(M,group);

clear h

for jj= 1: nodes
    
    pac(:,1)= val_AC(:,jj);
    pac(1:8,2)= val_AMD(:,jj);
    
    [p(jj),h(jj),~] = signrank(pac(:,1),pac(:,2));
    %     co = multcompare(stats(jj),'display','off');
    %     C{jj}=co;
end

% logical 2 double
h = h+0;

%%
G = figure; hold on;
X = 1:nodes;
c = lines(length(AMD));

% Control
st = nanstd(val_AC);
m   = nanmean(val_AC,1);

% render control subjects range
A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

% set color and style
set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

plot(m,'color',[0 0 0], 'linewidth',3 )

% add individual FA plot
for k = 1:length(AMD) %1:length(subDir)
    plot(X,AMD_data(k,:),'Color',c(k,:),...
        'linewidth',1);
end
m   = nanmean(AMD_data,1);
plot(X,m,'Color',c(3,:) ,'linewidth',3)

T = title(sprintf('%s comparing to AMD_C', fbName{fibID}(3:end)));
ylabel(upper(vals))
xlabel('Location')

% axis
% if b(1)<0;b(1)=0;end;
% switch vals
%     case {}
switch fibID
    case {1}
        b=[0.8, 1.8];
        % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {3}
        b=[0.8,1.8];
        set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {5,7,9}
        b=[0.8, 1.8];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;        
end
clear h
% Save current figure
if ~isempty(SavePath)
    saveas(G,fullfile(SavePath, [vals,'_',T.String,'.eps']),'psc2')
    %     saveas(G,fullfile(SavePath, [vals,'_',T.String]),'bmp')
end

%% RD
%
vals ='rd';
val_AC = rd(AMD_Ctl,:);
val_AMD = rd(AMD,:);

AMD_data  = val_AMD;

%% Wilcoxon Single rank test
% container
group =2;
M = length(AMD_Ctl);
pac = nan(M,group);

clear h

for jj= 1: nodes
    
    pac(:,1)= val_AC(:,jj);
    pac(1:8,2)= val_AMD(:,jj);
    
    [p(jj),h(jj),~] = signrank(pac(:,1),pac(:,2));
    %     co = multcompare(stats(jj),'display','off');
    %     C{jj}=co;
end

% logical 2 double
h = h+0;

%%
G = figure; hold on;
X = 1:nodes;
c = lines(length(AMD));

% Control
st = nanstd(val_AC);
m   = nanmean(val_AC,1);

% render control subjects range
A3 = area(m+2*st);
A1 = area(m+st);
A2 = area(m-st);
A4 = area(m-2*st);

% set color and style
set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
set(A4,'FaceColor',[1 1 1],'linestyle','none')

plot(m,'color',[0 0 0], 'linewidth',3 )

% add individual FA plot
for k = 1:length(AMD) %1:length(subDir)
    plot(X,AMD_data(k,:),'Color',c(k,:),...
        'linewidth',1);
end
m   = nanmean(AMD_data,1);
plot(X,m,'Color',c(3,:) ,'linewidth',3)

T = title(sprintf('%s comparing to AMD_C', fbName{fibID}(3:end)));
ylabel(upper(vals))
xlabel('Location')

% axis
% if b(1)<0;b(1)=0;end;
% switch vals
%     case {}
switch fibID
    case {1}
        b=[0.8, 1.8];
        % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {3}
        b=[0.2,1.1];
        set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {5,7,9}
        b=[0.2,1.1];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;        
end
clear h
% Save current figure
if ~isempty(SavePath)
    saveas(G,fullfile(SavePath, [vals,'_',T.String,'.eps']),'psc2')
    %     saveas(G,fullfile(SavePath, [vals,'_',T.String]),'bmp')
end



return


