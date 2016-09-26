%% load files

load ACH.mat
read_AMD_VA


% remind fiber ordering and give merged name
fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
    'LOR30-90','ROR30-90'};

Merged = {'OR','OR03','OR15','OR90'};

valname = {'fa','ad','rd'};

if notDefined('fibID')
    fibID = [3,5,7,9];
end

% merged both hemisphere
for v =1:length(fibID)
    % get values and merge both hemisphere
    for subID = 1:20;
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

%% Pearson correlation val_OR and logMARVARL
c = lines(4);
figure; hold on;

for k = 1:length(valname)
    for ii =1: length(val_OR.fa)
        [r(ii),p(ii)] = corr(val_OR.(valname{k})(1:8,ii),logMARVARL);
        if p(ii)<0.05
            plot(ii,r(ii),'o','color',c(k,:),'markersize',15);end
    end
    l(k) = plot(r,'color',c(k,:),'linewidth',1);
    
end

% add
set(gca,'YLim',[-1 1],'YTick',[-1:0.5:1],'TickDir','out','XLim',[11 90],'XTick','')
legend(valname)
plot([0 100],[0 0],'-k')

ylabel('r')
title(Merged{1})
hold off;
clear l

saveas(gca,'OR_BCVA.eps','epsc')
%% correlation val_OR03 and logMARVARL
figure; hold on;
c = lines(4);

for k = 1:length(valname)
    for ii =1: length(val_OR03.fa)
        [r(ii),p(ii)] = corr(val_OR03.(valname{k})(1:8,ii),logMARVARL);
        if p(ii)<0.05
            plot(ii,r(ii),'o','color',c(k,:),'markersize',15);end
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

clear l
saveas(gca,'OR03_BCVA.eps','epsc')

%% correlation val_OR15 and logMARVARL
figure; hold on;
c = lines(4);

for k = 1:length(valname)
    for ii =1: length(val_OR15.fa)
        [r(ii),p(ii)] = corr(val_OR15.(valname{k})(1:8,ii),logMARVARL);
        if p(ii)<0.05
            plot(ii,r(ii),'o','color',c(k,:),'markersize',15);end
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


saveas(gca,'OR15_BCVA.eps','epsc')

%% correlation val_OR90 and logMARVARL
figure; hold on;
c = lines(4);

for k = 1:length(valname)
    for ii =1: length(val_OR90.fa)
        [r(ii),p(ii)] = corr(val_OR90.(valname{k})(1:8,ii),logMARVARL);
        if p(ii)<0.05
            plot(ii,r(ii),'o','color',c(k,:),'markersize',15);end
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



saveas(gca,'OR90_BCVA.eps','epsc')

%%
for k = 1:length(valname)
    
    figure; hold on;
    c = lines(4);
    % 03
    for ii =1: length(val_OR03.fa)
        [r(ii),p(ii)] = corr(val_OR03.(valname{k})(1:8,ii),logMARVARL);
        if p(ii)<0.05
            plot(ii,r(ii),'o','color',c(1,:),'markersize',15);end
    end
    
    l1= plot(r,'color',c(1,:),'linewidth',1);
    
    % 15
    for ii =1: length(val_OR15.fa)
        [r(ii),p(ii)] = corr(val_OR15.(valname{k})(1:8,ii),logMARVARL);
        if p(ii)<0.05
            plot(ii,r(ii),'o','color',c(2,:),'markersize',15);end
    end
    
    l2 = plot(r,'color',c(2,:),'linewidth',1);
    
    % 90
    for ii =1: length(val_OR90.fa)
        [r(ii),p(ii)] = corr(val_OR90.(valname{k})(1:8,ii),logMARVARL);
        if p(ii)<0.05
            plot(ii,r(ii),'o','color',c(3,:),'markersize',15);end
    end
    
    l3 = plot(r,'color',c(3,:),'linewidth',1);
    
    set(gca,'YLim',[-1 1],'YTick',[-1:0.5:1],'TickDir','out','XLim',[6 45],'XTick','')
    plot([0 100],[0 0],'-k')
    
    ylabel('r')
    xlabel('Location')
    title(upper(valname{k}))
    
    legend([l1,l2,l3],'0-3','15-30','30-90')
    
    saveas(gca,sprintf('ThreeEcc_%s.eps',upper(valname{k})),'epsc')
    
end

