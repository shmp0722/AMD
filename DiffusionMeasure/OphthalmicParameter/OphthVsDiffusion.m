function OphthVsDiffusion(savefig)
%
%
%
%
% SO@ACH 2016.10.03

%% load files

% load TP structure called ACH
load ACH.mat
% load R.mat

% load the results of ophthalmic test
if exist('ganka','dir')
    read_AMD_VA
elseif exist('shumpei','dir')
    read_AMD_VA2
end

% argument check
if notDefined('savefig')
    savefig = false;
end

VA = readtable('AMD_VA.csv')

VA.logBoth = mean([VA.rightlogMAR, VA.leftlogMAR])

%% remind fiber name ordering and give merged name
fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
    'LOR30-90','ROR30-90'};

Merged = {'OR','OR03','OR15','OR90'};

valname = {'fa','ad','rd','md'};

if notDefined('fibID')
    fibID = [3,5,7,9];
end

% for r
R = struct;

% merged both hemisphere
for v =1:length(fibID)
    % get values and merge both hemisphere
    for subID = 1:20; % patients =1:8, healthy = 9;20;
        fa(subID,:) =  nanmean([ACH{subID,fibID(v)}.vals.fa;...
            ACH{subID,fibID(v)+1}.vals.fa]);
        
        md(subID,:) = nanmean([ ACH{subID,fibID(v)}.vals.md;...
            ACH{subID,fibID(v)+1}.vals.md]);
        
        rd(subID,:) = nanmean([ ACH{subID,fibID(v)}.vals.rd;...
            ACH{subID,fibID(v)+1}.vals.rd]);
        
        ad(subID,:) = nanmean([ ACH{subID,fibID(v)}.vals.ad;...
            ACH{subID,fibID(v)+1}.vals.ad]);
        
    end
    
    % unite diffusion properties for anlyze
    switch v
        case 1
            val_OR = struct;
            val_OR.fa = fa;
            val_OR.md = md;
            val_OR.ad = ad;
            val_OR.rd = rd;
        case 2
            val_OR03 = struct;
            val_OR03.fa = fa;
            val_OR03.md = md;
            val_OR03.ad = ad;
            val_OR03.rd = rd;
        case 3
            val_OR15 = struct;
            val_OR15.fa = fa;
            val_OR15.md = md;
            val_OR15.ad = ad;
            val_OR15.rd = rd;
        case 4
            val_OR90.fa = fa;
            val_OR90.md = md;
            val_OR90.ad = ad;
            val_OR90.rd = rd;
    end
    clear fa md ad rd;
end

%% Pearson correlation between val_OR and logMARVARL
c = lines(4);
figure; hold on;

for k = 1:length(valname)
    for node =1: length(val_OR.fa)
        [r(node),p(node)] = corr(val_OR.(valname{k})(1:8,node),logMARVARL);
        
        if p(node)<0.05
            plot(node,r(node),'o','color',c(k,:),'markersize',15);end
    end
    % add the range of r-value using bootstrap
    [bootstat,~] = bootstrp(1000,@corr,...
        val_OR.(valname{k})(1:8,node),logMARVARL);
    l(k) = plot(r,'color',c(k,:),'linewidth',1);
    se = std(bootstat);
    m(k) = plot(r+se,'--','color',c(k,:),'linewidth',1);
    n(k) = plot(r-se,'--','color',c(k,:),'linewidth',1);
end

% add
set(gca,'YLim',[-1 1],'YTick',[-1:0.5:1],'TickDir','out','XLim',[11 90],'XTick','')
legend(valname)
plot([0 100],[0 0],'-k')

ylabel('r')
title('OR')
hold off;
clear l

% keep r value
R.OR = r;
clear r

% saving figures
if savefig==1,
    saveas(gca,'OR_BCVA_boot.png')
    saveas(gca,'OR_BCVA_boot.eps','epsc')
    
    !mv *.png Figure/
    !mv *.eps Figure/
end
%% correlation val_OR03 and logMARVARL
figure; hold on;
c = lines(4);

for k = 1:length(valname)
    for node =1: length(val_OR03.fa)
        [r(node),p(node)] = corr(val_OR03.(valname{k})(1:8,node),logMARVARL);
        if p(node)<0.05
            plot(node,r(node),'o','color',c(k,:),'markersize',15);end
    end
    
    l(k) = plot(r,'color',c(k,:),'linewidth',1);
    
end

% legend(valname)

% add
set(gca,'YLim',[-1 1],'YTick',[-1:0.5:1],'TickDir','out','XLim',[6 45],'XTick','')
plot([0 100],[0 0],'-k')

ylabel('r')
title(Merged{2})
hold off;
legend([l(1),l(2),l(3)],valname)

% keep r value
R.OR03 = r;

clear l r;

% save the figure
if savefig ==1,
    saveas(gca,'OR03_BCVA.eps','epsc')
    saveas(gca,'OR03_BCVA.png')
    
    !mv *.png Figure/
    !mv *.eps Figure/
end

%% correlation val_OR15 and logMARVARL
figure; hold on;
c = lines(4);

for k = 1:length(valname)
    for node =1: length(val_OR15.fa)
        [r(node),p(node)] = corr(val_OR15.(valname{k})(1:8,node),logMARVARL);
        if p(node)<0.05
            plot(node,r(node),'o','color',c(k,:),'markersize',15);end
    end
    
    l(k)= plot(r,'color',c(k,:),'linewidth',1);
    
end

% legend(valname)

% add
set(gca,'YLim',[-1 1],'YTick',[-1:0.5:1],'TickDir','out','XLim',[6 45],'XTick','')
plot([0 100],[0 0],'-k')

ylabel('r')
title(Merged{3})
hold off;

legend([l(1),l(2),l(3)],valname)

% keep r value
R.OR15 = r;
clear l r;

if savefig ==1,
    saveas(gca,'OR15_BCVA.eps','epsc')
    saveas(gca,'OR15_BCVA.png')
end

%% correlation val_OR90 and logMARVARL
figure; hold on;
c = lines(4);

for k = 1:length(valname)
    for node =1: length(val_OR90.fa)
        [r(node),p(node)] = corr(val_OR90.(valname{k})(1:8,node),logMARVARL);
        if p(node)<0.05
            plot(node,r(node),'o','color',c(k,:),'markersize',15);end
    end
    
    l(k)= plot(r,'color',c(k,:),'linewidth',1);
    
end

% legend(valname)

% add
set(gca,'YLim',[-1 1],'YTick',[-1:0.5:1],'TickDir','out','XLim',[6 45],'XTick','')
plot([0 100],[0 0],'-k')

ylabel('r')
title(Merged{4})
legend([l(1),l(2),l(3)],valname)

hold off;

% keep r value
R.OR90 = r;

clear l r ;

if savefig ==1;
    saveas(gca,'OR90_BCVA.eps','epsc')
    saveas(gca,'OR90_BCVA.png')
    !mv *.png Figure/
    !mv *.eps Figure/
end

%% save
save R R

%% compare across ORs based on eccentricity
for k = 1:length(valname)
    
%     ORs ={'val_OR03','val_OR15','val_OR90'};
    
    figure; hold on;
    c = lines(4);
    % 0-3 degree
    for node =1: length(val_OR03.fa)
        [r(node),p(node)] = corr(val_OR03.(valname{k})(1:8,node),logMARVARL);
         [bootstat(:,node),~] = bootstrp(1000,@corr,val_OR03.(valname{k})(1:8,node),logMARVARL);
        % loaction p-value
        if p(node)<0.05
            plot(node,r(node),'o','color',c(1,:),'markersize',15);
        end
    end
    
    % render the correlation value
    l1= plot(r,'color',c(1,:),'linewidth',1);
       
%     % compute the two-tailed % confidence intervals:
%     ci = prctile(bootstat,[5,95]);
%     ci1 = plot(ci(1,:),'--','color',c(1,:));
%     ci2 = plot(ci(2,:),'--','color',c(1,:));
    
    % add the range of r-value using bootstrap
    se = std(bootstat);
    m(k) = plot(r+se,'--','color',c(1,:),'linewidth',1);
    n(k) = plot(r-se,'--','color',c(1,:),'linewidth',1);
    clearvars bootstat
    
    % 15-30 degree
    for node =1: length(val_OR15.fa)
        [r(node),p(node)] = corr(val_OR15.(valname{k})(1:8,node),logMARVARL);
        [bootstat(:,node),~] = bootstrp(1000,@corr,val_OR15.(valname{k})(1:8,node),logMARVARL);
        if p(node)<0.05
            plot(node,r(node),'o','color',c(2,:),'markersize',15);end
    end
    
    l2 = plot(r,'color',c(2,:),'linewidth',1);
    
    % add the range of r-value using bootstrap
    se = std(bootstat);
    m(k) = plot(r+se,'--','color',c(2,:),'linewidth',1);
    n(k) = plot(r-se,'--','color',c(2,:),'linewidth',1);
    
    
    % 30-90 degree
    for node =1: length(val_OR90.fa)
        [r(node),p(node)] = corr(val_OR90.(valname{k})(1:8,node),logMARVARL);
        [bootstat(:,node),~] = bootstrp(1000,@corr,...
        val_OR90.(valname{k})(1:8,node),logMARVARL);
        if p(node)<0.05
            plot(node,r(node),'o','color',c(3,:),'markersize',15);
        end
    end
    
    l3 = plot(r,'color',c(3,:),'linewidth',1);
    
    % add the range of r-value using bootstrap
   
    se = std(bootstat);
    m(k) = plot(r+se,'--','color',c(3,:),'linewidth',1);
    n(k) = plot(r-se,'--','color',c(3,:),'linewidth',1);
    
    % make it up
    set(gca,'YLim',[-1 1],'YTick',[-1:0.5:1],'TickDir','out','XLim',[6 45],'XTick','')
    plot([0 100],[0 0],'-k')
    
    ylabel('r')
    xlabel('Location')
    title(upper(valname{k}))
    
    legend([l1,l2,l3],'0-3','15-30','30-90')
    
    if savefig ==1,
        saveas(gca,sprintf('ThreeEcc_%s.eps',upper(valname{k})),'epsc')
        saveas(gca,sprintf('ThreeEcc_%s.png',upper(valname{k})))
        !mv *.png Figure/
        !mv *.eps Figure/
    end
    
end

%% compare across ORs based on eccentricity
for k = 1:length(valname)
    
%     ORs ={'val_OR03','val_OR15','val_OR90'};
    
    figure; hold on;
    c = lines(4);
    % 0-3 degree
    for node =1: length(val_OR03.fa)
        [r(node),p(node)] = corr(val_OR03.(valname{k})(1:8,node),logMARVARL);
%          [bootstat(:,node),~] = bootstrp(1000,@corr,val_OR03.(valname{k})(1:8,node),logMARVARL);
        % loaction p-value
        if p(node)<0.05
            plot(node,r(node),'o','color',c(1,:),'markersize',15);
        end
    end
    
    % render the correlation value
    l1= plot(r,'color',c(1,:),'linewidth',1);
       
%     % compute the two-tailed % confidence intervals:
%     ci = prctile(bootstat,[5,95]);
%     ci1 = plot(ci(1,:),'--','color',c(1,:));
%     ci2 = plot(ci(2,:),'--','color',c(1,:));
    
    % add the range of r-value using bootstrap
%     se = std(bootstat);
%     m(k) = plot(r+se,'--','color',c(1,:),'linewidth',1);
%     n(k) = plot(r-se,'--','color',c(1,:),'linewidth',1);
%     clearvars bootstat
    
    % 15-30 degree
    for node =1: length(val_OR15.fa)
        [r(node),p(node)] = corr(val_OR15.(valname{k})(1:8,node),logMARVARL);
%         [bootstat(:,node),~] = bootstrp(1000,@corr,val_OR15.(valname{k})(1:8,node),logMARVARL);
        if p(node)<0.05
            plot(node,r(node),'o','color',c(2,:),'markersize',15);end
    end
    
    l2 = plot(r,'color',c(2,:),'linewidth',1);
    
%     % add the range of r-value using bootstrap
%     se = std(bootstat);
%     m(k) = plot(r+se,'--','color',c(2,:),'linewidth',1);
%     n(k) = plot(r-se,'--','color',c(2,:),'linewidth',1);
    
    
    % 30-90 degree
    for node =1: length(val_OR90.fa)
        [r(node),p(node)] = corr(val_OR90.(valname{k})(1:8,node),logMARVARL);
%         [bootstat(:,node),~] = bootstrp(1000,@corr,...
%         val_OR90.(valname{k})(1:8,node),logMARVARL);
        if p(node)<0.05
            plot(node,r(node),'o','color',c(3,:),'markersize',15);
        end
    end
    
    l3 = plot(r,'color',c(3,:),'linewidth',1);
    
    % add the range of r-value using bootstrap
   
%     se = std(bootstat);
%     m(k) = plot(r+se,'--','color',c(3,:),'linewidth',1);
%     n(k) = plot(r-se,'--','color',c(3,:),'linewidth',1);
    
    % make it up
    set(gca,'YLim',[-1 1],'YTick',[-1:0.5:1],'TickDir','out','XLim',[6 45],'XTick','')
    plot([0 100],[0 0],'-k')
    
    ylabel('r')
    xlabel('Location')
    title(sprintf('LogMAR vs %s',upper(valname{k})))
    
    legend([l1,l2,l3],'0-3','15-30','30-90')
    
    if savefig ==1,
        saveas(gca,sprintf('ThreeEcc_%s_wo.eps',upper(valname{k})),'epsc')
        saveas(gca,sprintf('ThreeEcc_%s_wo.png',upper(valname{k})))
        !mv *.png Figure/
        !mv *.eps Figure/
    end
    
end

%% compare across ORs based on eccentricity
for k = 1:length(valname)
       
    figure; hold on;
    c = lines(4);
    % 0-3 degree
    for node =1: length(val_OR03.fa)
        [r(node),p(node)] = corr(val_OR03.(valname{k})(1:8,node),logMARVARL);
%          [bootstat(:,node),~] = bootstrp(1000,@corr,val_OR03.(valname{k})(1:8,node),logMARVARL);
        % loaction p-value
        if p(node)<0.05
            plot(node,r(node),'o','color',c(1,:),'markersize',15);
        end
    end
    
    % render the correlation value
    l1= plot(r,'color',c(1,:),'linewidth',1);
       
%     % compute the two-tailed % confidence intervals:
%     ci = prctile(bootstat,[5,95]);
%     ci1 = plot(ci(1,:),'--','color',c(1,:));
%     ci2 = plot(ci(2,:),'--','color',c(1,:));
    
    % add the range of r-value using bootstrap
%     se = std(bootstat);
%     m(k) = plot(r+se,'--','color',c(1,:),'linewidth',1);
%     n(k) = plot(r-se,'--','color',c(1,:),'linewidth',1);
%     clearvars bootstat
    
    % 15-30 degree
    for node =1: length(val_OR15.fa)
        [r(node),p(node)] = corr(val_OR15.(valname{k})(1:8,node),logMARVARL);
%         [bootstat(:,node),~] = bootstrp(1000,@corr,val_OR15.(valname{k})(1:8,node),logMARVARL);
        if p(node)<0.05
            plot(node,r(node),'o','color',c(2,:),'markersize',15);end
    end
    
    l2 = plot(r,'color',c(2,:),'linewidth',1);
    
%     % add the range of r-value using bootstrap
%     se = std(bootstat);
%     m(k) = plot(r+se,'--','color',c(2,:),'linewidth',1);
%     n(k) = plot(r-se,'--','color',c(2,:),'linewidth',1);
    
    
    % 30-90 degree
    for node =1: length(val_OR90.fa)
        [r(node),p(node)] = corr(val_OR90.(valname{k})(1:8,node),logMARVARL);
%         [bootstat(:,node),~] = bootstrp(1000,@corr,...
%         val_OR90.(valname{k})(1:8,node),logMARVARL);
        if p(node)<0.05
            plot(node,r(node),'o','color',c(3,:),'markersize',15);
        end
    end
    
    l3 = plot(r,'color',c(3,:),'linewidth',1);
    
    % add the range of r-value using bootstrap
   
%     se = std(bootstat);
%     m(k) = plot(r+se,'--','color',c(3,:),'linewidth',1);
%     n(k) = plot(r-se,'--','color',c(3,:),'linewidth',1);
    
    % make it up
    set(gca,'YLim',[-1 1],'YTick',[-1:0.5:1],'TickDir','out','XLim',[6 45],'XTick','')
    plot([0 100],[0 0],'-k')
    
    ylabel('r')
    xlabel('Location')
    title(sprintf('LogMAR vs %s',upper(valname{k})))
    
    legend([l1,l2,l3],'0-3','15-30','30-90')
    
    if savefig ==1,
        saveas(gca,sprintf('ThreeEcc_%s_wo.eps',upper(valname{k})),'epsc')
        saveas(gca,sprintf('ThreeEcc_%s_wo.png',upper(valname{k})))
        !mv *.png Figure/
        !mv *.eps Figure/
    end
    
end



