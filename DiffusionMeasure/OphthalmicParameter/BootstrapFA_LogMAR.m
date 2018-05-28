function BootstrapFA_LogMAR(BS_times,savefig)
%
%
%
%
% SO@ACH 2016.10.03

%% load files

% load TP structure called ACH
load ACH.mat
load R.mat

% load the results of ophthalmic test
if exist('/home/ganka','dir')
    read_AMD_VA
elseif exist('shumpei','dir')
    read_AMD_VA2
end

% argument check
if notDefined('savefig')
    savefig = false;
end

if notDefined('BS_times')
    BS_times = 1000;
end

%% remind fiber name ordering and give merged name
fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
    'LOR30-90','ROR30-90'};

Merged = {'OR','OR03','OR15','OR90'};

valname = {'fa','ad','rd'};

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


%% compare across ORs based on eccentricity
for k = 1%:length(valname) ;% only fa
    
    figure; hold on;
    c = lines(4);
    bs = zeros(BS_times,length(val_OR03.fa));
    bootstat03 = bs;
    bootstat15 = bs;
    bootstat90 = bs;
    clearvars bs;
    
    % loop over nodes 
    parfor node =1: length(val_OR15.fa)
        % 0-3 degree
        [r(node),p(node)] = corr(val_OR03.(valname{k})(1:8,node),logMARVARL);
        [bootstat03(:,node),~] = bootstrp(BS_times,@corr,val_OR03.(valname{k})(1:8,node),logMARVARL);
        % loaction p-value
        if p(node)<0.05
            plot(node,r(node),'o','color',c(1,:),'markersize',15);
        end
        
        % 15-30 degree
        [r(node),p(node)] = corr(val_OR15.(valname{k})(1:8,node),logMARVARL);
        [bootstat15(:,node),~] = bootstrp(BS_times,@corr,val_OR15.(valname{k})(1:8,node),logMARVARL);
        if p(node)<0.05
            plot(node,r(node),'o','color',c(2,:),'markersize',15);end
        
        [r(node),p(node)] = corr(val_OR90.(valname{k})(1:8,node),logMARVARL);
        [bootstat90(:,node),~] = bootstrp(BS_times,@corr,...
            val_OR90.(valname{k})(1:8,node),logMARVARL);
        if p(node)<0.05
            plot(node,r(node),'o','color',c(3,:),'markersize',15);
        end
        
        
    end    
    
    ci = prctile(bootstat03,[2.5,50,97.5]);
    plot(ci(1,:),'--','color',c(1,:));
    plot(ci(3,:),'--','color',c(1,:));
    l1 = plot(ci(2,:),'color',c(1,:),'Linewidth',2);
    
    
    ci = prctile(bootstat15,[2.5,50,97.5]);
    plot(ci(1,:),'--','color',c(2,:));
    plot(ci(3,:),'--','color',c(2,:));
    l2 = plot(ci(2,:),'color',c(2,:),'Linewidth',2);
    
    ci = prctile(bootstat90,[2.5,50,97.5]);
    plot(ci(1,:),'--','color',c(3,:));
    plot(ci(3,:),'--','color',c(3,:));
    l3 = plot(ci(2,:),'color',c(3,:),'Linewidth',2);
    
    % make it up
    set(gca,'YLim',[-1 1],'YTick',[-1:0.5:1],'TickDir','out','XLim',[6 45],'XTick','')
    plot([0 100],[0 0],'-k')
    
    ylabel('r')
    xlabel('Location')
    title(sprintf('%s vs LogMAR - bootsrap %d ci %d',upper(valname{k}),BS_times,95));
    
    legend([l1,l2,l3],'0-3','15-30','30-90')
    
    if savefig ==1,
        saveas(gca,sprintf('ThreeEcc_%s_BS%d_ci%d.eps',upper(valname{k}),BS_times,95),'epsc')
        saveas(gca,sprintf('ThreeEcc_%s_BS%d_ci%d.png',upper(valname{k}),BS_times,95))
        !mv *.png Figure/
        !mv *.eps Figure/
    end
    
    
    %% test 80% tile
    figure;hold on;
    ci = prctile(bootstat03,[10,50,90]);
    plot(ci(1,:),'--','color',c(1,:));
    plot(ci(3,:),'--','color',c(1,:));
    l1 = plot(ci(2,:),'color',c(1,:),'Linewidth',2);
    
    
    ci = prctile(bootstat15,[10,50,90]);
    plot(ci(1,:),'--','color',c(2,:));
    plot(ci(3,:),'--','color',c(2,:));
    l2 = plot(ci(2,:),'color',c(2,:),'Linewidth',2);
    
    ci = prctile(bootstat90,[10,50,90]);
    plot(ci(1,:),'--','color',c(3,:));
    plot(ci(3,:),'--','color',c(3,:));
    l3 = plot(ci(2,:),'color',c(3,:),'Linewidth',2);
    
    % make it up
    set(gca,'YLim',[-1 1],'YTick',[-1:0.5:1],'TickDir','out','XLim',[6 45],'XTick','')
    plot([0 100],[0 0],'-k')
    
    ylabel('r')
    xlabel('Location')
    title(sprintf('%s vs LogMAR - bootsrap %d ci %d',upper(valname{k}),BS_times,90));
    
    legend([l1,l2,l3],'0-3','15-30','30-90')
    
    if savefig ==1,
        saveas(gca,sprintf('ThreeEcc_%s_BS%d_ci%d.eps',upper(valname{k}),BS_times,90),'epsc')
        saveas(gca,sprintf('ThreeEcc_%s_BS%d_ci%d.png',upper(valname{k}),BS_times,90))
        !mv *.png Figure/
        !mv *.eps Figure/
    end
end

