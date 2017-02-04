function Merged_AMD_plot_Westin(fibID,SavePath)
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
%% cl
%
vals ='cl';
val_AC = cl(AMD_Ctl,:);
val_AMD = cl(AMD,:);

AMD_data  = val_AMD;

% Wilcoxon rank sum test
% container
clear h p;

for jj= 1: nodes
    [p(jj),h(jj),~] = ranksum(val_AC(:,jj),val_AMD(:,jj));
%     [H(jj),P(jj),~] = ttest2(val_AC(:,jj),val_AMD(:,jj));
end

% logical 2 double
h = h+0;

% figure
G = figure; hold on;
X = 1:nodes;
c = lines(length(AMD));

bar(X,h*3,1.0,'EdgeColor','none')


% Control
st = nanstd(val_AC);
m   = nanmean(val_AC,1);

% render control subjects range
A1 = plot(m+st,':','color',[0.6 0.6 0.6]);
A2 = plot(m-st,':','color',[0.6 0.6 0.6]);
A3 = plot(m+2*st,':','color',[0.8 0.8 0.8]);
A4 = plot(m-2*st,':','color',[0.8 0.8 0.8]);

plot(m,'color',[0 0 0], 'linewidth',3 )

% add individual FA plot
for k = 1:length(AMD) %1:length(subDir)
    plot(X,AMD_data(k,:),'--r',...
        'linewidth',1);
end
m   = nanmean(AMD_data,1);
plot(X,m,'r' ,'linewidth',3)

T = title(sprintf('%s comparing to AMD_C', fbName{fibID}(3:end)));
ylabel(upper(vals))
xlabel('Location')

% axis
% if b(1)<0;b(1)=0;end;
% switch vals
%     case {}
switch fibID
    case {1}
        b=[0, .4];
        % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
%         bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        
        hold off;
    case {3}
        b=[0,0.5];
        set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
%         bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {5,7,9}
        b=[0, .5];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        %         bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
end
clear h
% Save current figure
if ~isempty(SavePath)
    saveas(G,fullfile(SavePath, [vals,'_',T.String,'.eps']),'psc2')
    saveas(G,fullfile(SavePath, [vals,'_',T.String]),'png')
    saveas(G,fullfile(SavePath, [vals,'_',T.String]),'fig')
    
%     !mv *eps DiffusivionPropertyPlot/
%     !mv *png DiffusivionPropertyPlot/
end

%% sp
%
vals ='sp';
val_AC = sp(AMD_Ctl,:);
val_AMD = sp(AMD,:);

AMD_data  = val_AMD;

% Wilcoxon rank sum test
% container
clear h

for jj= 1: nodes
    [p(jj),h(jj),~] = ranksum(val_AC(:,jj),val_AMD(:,jj));
%     [H(jj),P(jj),~] = ttest2(val_AC(:,jj),val_AMD(:,jj));
end

% logical 2 double
h = h+0;

% figure
G = figure; hold on;
X = 1:nodes;
c = lines(length(AMD));

bar(X,h*3,1.0,'EdgeColor','none')


% Control
st = nanstd(val_AC);
m   = nanmean(val_AC,1);

% render control subjects range
A1 = plot(m+st,':','color',[0.6 0.6 0.6]);
A2 = plot(m-st,':','color',[0.6 0.6 0.6]);
A3 = plot(m+2*st,':','color',[0.8 0.8 0.8]);
A4 = plot(m-2*st,':','color',[0.8 0.8 0.8]);

plot(m,'color',[0 0 0], 'linewidth',3 )

% add individual FA plot
for k = 1:length(AMD) %1:length(subDir)
    plot(X,AMD_data(k,:),'--r',...
        'linewidth',1);
end
m   = nanmean(AMD_data,1);
plot(X,m,'r' ,'linewidth',3)

T = title(sprintf('%s comparing to AMD_C', fbName{fibID}(3:end)));
ylabel(upper(vals))
xlabel('Location')

% axis
% if b(1)<0;b(1)=0;end;
% switch vals
%     case {}
switch fibID
    case {1}
        b=[0.5, 1];
        % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        
        hold off;
    case {3}
        b=[0.3,.8];
        set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {5}
        b=[0.4, .8];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        %         bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {7,9}
        b=[0.4, 1];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        %         bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
end
% clear h
% Save current figure
if ~isempty(SavePath)
    saveas(G,fullfile(SavePath, [vals,'_',T.String,'.eps']),'psc2')
    saveas(G,fullfile(SavePath, [vals,'_',T.String]),'png')
    saveas(G,fullfile(SavePath, [vals,'_',T.String]),'fig')
    
    
%     !mv *eps DiffusivionPropertyPlot/
%     !mv *png DiffusivionPropertyPlot/
end


%% pl
%
vals ='pl';
val_AC = sp(AMD_Ctl,:);
val_AMD = sp(AMD,:);

AMD_data  = val_AMD;

% Wilcoxon rank sum test
% container
clear h

for jj= 1: nodes
    [p(jj),h(jj),~] = ranksum(val_AC(:,jj),val_AMD(:,jj));
%     [H(jj),P(jj),~] = ttest2(val_AC(:,jj),val_AMD(:,jj));
end

% logical 2 double
h = h+0;

% figure
G = figure; hold on;
X = 1:nodes;
c = lines(length(AMD));

bar(X,h*3,1.0,'EdgeColor','none')


% Control
st = nanstd(val_AC);
m   = nanmean(val_AC,1);

% render control subjects range
A1 = plot(m+st,':','color',[0.6 0.6 0.6]);
A2 = plot(m-st,':','color',[0.6 0.6 0.6]);
A3 = plot(m+2*st,':','color',[0.8 0.8 0.8]);
A4 = plot(m-2*st,':','color',[0.8 0.8 0.8]);

plot(m,'color',[0 0 0], 'linewidth',3 )

% add individual FA plot
for k = 1:length(AMD) %1:length(subDir)
    plot(X,AMD_data(k,:),'--r',...
        'linewidth',1);
end
m   = nanmean(AMD_data,1);
plot(X,m,'r' ,'linewidth',3)

T = title(sprintf('%s comparing to AMD_C', fbName{fibID}(3:end)));
ylabel(upper(vals))
xlabel('Location')

% axis
% if b(1)<0;b(1)=0;end;
% switch vals
%     case {}
switch fibID
    case {1}
        b=[0.5, 1];
        % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        
        hold off;
    case {3}
        b=[0.3,.8];
        set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {5}
        b=[0.4, .8];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        %         bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {7,9}
        b=[0.4, 1];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        %         bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
end
% clear h
% Save current figure
if ~isempty(SavePath)
    saveas(G,fullfile(SavePath, [vals,'_',T.String,'.eps']),'psc2')
    saveas(G,fullfile(SavePath, [vals,'_',T.String]),'png')
    saveas(G,fullfile(SavePath, [vals,'_',T.String]),'fig')
    
    
%     !mv *eps DiffusivionPropertyPlot/
%     !mv *png DiffusivionPropertyPlot/
end