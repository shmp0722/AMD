function Merged_AMD_ttest_20180223(fibID,SavePath)
% individual FA value along the core of OR and optic tract.
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    shmp0722/AMD
%
%
% Shumpei Ogawa 2014

%% load raw data and subjects
load ACH_0210.mat
AMD = 1:8;
AMD_Ctl = 9:20;
%% argument check
if notDefined('fibID')
    fibID = 1;
end

if notDefined('SavePath')
    SavePath = pwd;
end

fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
    'LOR30-90','ROR30-90'};

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
%%
for fibID = [5 7 9]
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
    
    switch fibID
        case 5 
            FA03 = fa(1:20,:);
            % ttest each node
            for jj= 1: nodes
%                 [H03(jj),P03(jj),~] = ttest2(FA03(1:8,jj),FA03(9:20,jj));
                [P03(jj),H03(jj)] = ranksum(FA03(1:8,jj),FA03(9:20,jj));

            end
        case 7
            FA15 = fa(1:20,:); 
            % ttest each node
            for jj= 1: nodes
%                 [H15(jj),P15(jj),~] = ttest2(FA03(1:8,jj),FA03(9:20,jj));
                [P15(jj),H15(jj)] = ranksum(FA15(1:8,jj),FA15(9:20,jj));
            end
        case 9
            FA90 = fa(1:20,:);
             % ttest each node
            for jj= 1: nodes
%                 [H90(jj),P90(jj),~] = ttest2(FA03(1:8,jj),FA03(9:20,jj));
                [P15(jj),H15(jj)] = ranksum(FA90(1:8,jj),FA90(9:20,jj));
            end
    end
        
end
%% pickup a center portion of optic radiation differentiated by ttest
portion =  find(H03);
% logical 2 double
% h = h+0;

%%
[a,b] = size(FA03(1:8, portion));
[c,d] = size(FA03(9:20, portion));

FA03A = reshape(FA03(1:8, portion), 1 , a*b);
FA03C = reshape(FA03(9:20, portion),1,c*d);

FA15A = reshape(FA15(1:8, portion), 1 , a*b);
FA15C = reshape(FA15(9:20, portion),1,c*d);

FA90A = reshape(FA90(1:8, portion), 1 , a*b);
FA90C = reshape(FA90(9:20, portion),1,c*d);

[h03,p03,ci03,stats03] = ttest2(FA03A, FA03C);
[h15,p15,ci15,stats15] = ttest2(FA15A, FA15C);
[h90,p90,ci90,stats90] = ttest2(FA90A, FA90C);


%% group bar plot
figure
hold on
hBar = bar(1:2, [mean(FA03A),mean(FA03C); mean(FA15A),mean(FA15C);...
 mean(FA90A),mean(FA90C)],0.3);

for k1 = 1:2
    ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
    ydt(k1,:) = hBar(k1).YData;
end


errorbar(ctr,ydt, [std(FA03A),std(FA03C); std(FA15A),std(FA15C);...
 std(FA90A),std(FA90C)],'.')

set(gca,'XTick',[1,2],'XTickLabel',{'Patient', 'Healthy'})
set(gca,'YLim', [0 .7] , 'YTick',[0 .7])
ylabel 'FA'
text(1.45, 0.65 ,'***','FontSize', 18)
% text(1.40, 0.6 ,'p<0.0001','FontSize', 12)
title 'R1'

saveas(gca, fullfile(pwd, 'Figure2/R1_FA_comp.pdf'))


%% bar plot
figure
hold on
bar(1:2,[mean(FA03A),mean(FA03C)],0.3)
errorbar(1:2,[mean(FA03A),mean(FA03C)],[std(FA03A), std(FA03C)],'.')

set(gca,'XTick',[1,2],'XTickLabel',{'Patient', 'Healthy'})
set(gca,'YLim', [0 .7] , 'YTick',[0 .7])
ylabel 'FA'
text(1.45, 0.65 ,'***','FontSize', 18)
% text(1.40, 0.6 ,'p<0.0001','FontSize', 12)
title 'R1'


% saveas(gca, fullfile(pwd, 'Figure2/R1_FA_comp.pdf'))


%% OT FA
G = figure; hold on;
X = 1:nodes;
c = lines(length(AMD));

% Control
st = nanstd(val_AC);
m   = nanmean(val_AC,1);

% render control subjects range

A1 = plot(m+st,':','color',[0.6 0.6 0.6]);
A2 = plot(m-st,':','color',[0.6 0.6 0.6]);
A3 = plot(m+2*st,':','color',[0.8 0.8 0.8]);
A4 = plot(m-2*st,':','color',[0.8 0.8 0.8]);
%
% % set color and style
% set(A1,'C',[0.6 0.6 0.6],'linestyle','none')
% set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
% set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
% set(A4,'FaceColor',[1 1 1],'linestyle','none')

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
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {3}
        b=[0,0.8];
        set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
        bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {5,7,9}
        b=[0,0.8];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
end
% clear h
% Save current figure
if ~isempty(SavePath)
    saveas(gca,fullfile(SavePath, [vals,'_',T.String,'.eps']),'epsc')
    %         saveas(G,fullfile(SavePath, [vals,'_',T.String,'.ai']))
    
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

% change logical to double
h = h+0;

%%
G = figure; hold on;
X = 1:nodes;
c = lines(length(AMD));

% Control
st = nanstd(val_AC);
m   = nanmean(val_AC,1);

% render control subjects range
A1 = plot(m+st,':','color',[0.6 0.6 0.6]);
A2 = plot(m-st,':','color',[0.6 0.6 0.6]);
A3 = plot(m+2*st,':','color',[0.8 0.8 0.8]);
A4 = plot(m-2*st,':','color',[0.8 0.8 0.8]);

% % set color and style
% set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
% set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
% set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
% set(A4,'FaceColor',[1 1 1],'linestyle','none')

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
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {3}
        b=[0.8,1.8];
        set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {5,7,9}
        b=[0.8, 1.8];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
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

%% Wilcoxon rank sum test
% container
group =2;
M = length(AMD_Ctl);
pac = nan(M,group);

clear h

for jj= 1: nodes
    
    pac(:,1)= val_AC(:,jj);
    pac(1:8,2)= val_AMD(:,jj);
    
    [p(jj),h(jj),~] = ranksum(pac(:,1),pac(:,2));
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
A1 = plot(m+st,':','color',[0.6 0.6 0.6]);
A2 = plot(m-st,':','color',[0.6 0.6 0.6]);
A3 = plot(m+2*st,':','color',[0.8 0.8 0.8]);
A4 = plot(m-2*st,':','color',[0.8 0.8 0.8]);

% % set color and style
% set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
% set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
% set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
% set(A4,'FaceColor',[1 1 1],'linestyle','none')

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
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {3}
        b=[0.2,1.1];
        set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {5,7,9}
        b=[0.2,1.1];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
end
clear h
% Save current figure
if ~isempty(SavePath)
    saveas(G,fullfile(SavePath, [vals,'_',T.String,'.eps']),'psc2')
    %     saveas(G,fullfile(SavePath, [vals,'_',T.String]),'bmp')
end

%% MD
%
vals ='md';
val_AC = md(AMD_Ctl,:);
val_AMD = md(AMD,:);

AMD_data  = val_AMD;

%% Wilcoxon rank sum test
% container
clear h

for jj= 1: nodes
    [p(jj),h(jj),~] = ranksum(val_AC(:,jj),val_AMD(:,jj));
    [H(jj),P(jj),~] = ttest2(val_AC(:,jj),val_AMD(:,jj));
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
        b=[0.8, 1.8];
        % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {3}
        b=[0.6,1.1];
        set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {5,7,9}
        b=[0.2,1.1];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
end
clear h
% Save current figure
if ~isempty(SavePath)
    saveas(G,fullfile(SavePath, [vals,'_',T.String,'.eps']),'psc2')
    saveas(G,fullfile(SavePath, [vals,'_',T.String]),'png')
    !mv *eps DiffusivionPropertyPlot/
    !mv *png DiffusivionPropertyPlot/
end

return

%% cl
%
vals ='cl';
val_AC = cl(AMD_Ctl,:);
val_AMD = cl(AMD,:);

AMD_data  = val_AMD;

% Wilcoxon rank sum test
% container
clear h

for jj= 1: nodes
    [p(jj),h(jj),~] = ranksum(val_AC(:,jj),val_AMD(:,jj));
    [H(jj),P(jj),~] = ttest2(val_AC(:,jj),val_AMD(:,jj));
end

% logical 2 double
h = h+0;

% figure
G = figure; hold on;
X = 1:nodes;
c = lines(length(AMD));

bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')


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
        b=[0.8, 1.8];
        % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        
        hold off;
    case {3}
        b=[0.6,1.1];
        set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {5,7,9}
        b=[0, .4];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        %         bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
end
clear h
% Save current figure
if ~isempty(SavePath)
    saveas(G,fullfile(SavePath, [vals,'_',T.String,'.eps']),'psc2')
    saveas(G,fullfile(SavePath, [vals,'_',T.String]),'png')
    !mv *eps DiffusivionPropertyPlot/
    !mv *png DiffusivionPropertyPlot/
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
    [H(jj),P(jj),~] = ttest2(val_AC(:,jj),val_AMD(:,jj));
end

% logical 2 double
h = h+0;

% figure
G = figure; hold on;
X = 1:nodes;
c = lines(length(AMD));

bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')


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
        b=[0.8, 1.8];
        % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        
        hold off;
    case {3}
        b=[0.6,1.1];
        set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
        bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
    case {5,7,9}
        b=[0.4, 1.0];
        set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
        %         bar(X,h*(b(1)+0.1),1.0,'EdgeColor','none')
        hold off;
end
clear h
% Save current figure
if ~isempty(SavePath)
    saveas(G,fullfile(SavePath, [vals,'_',T.String,'.eps']),'psc2')
    saveas(G,fullfile(SavePath, [vals,'_',T.String]),'png')
    !mv *eps DiffusivionPropertyPlot/
    !mv *png DiffusivionPropertyPlot/
end

