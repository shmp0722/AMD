function Merged_AMD_plot_multicompare2(fibID, Alpha)
% Return figure with tract profile.  
% 
% fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
%    'LOR30-90','ROR30-90'};
%
% Shumpei Ogawa 2019.4

%% load raw data and subjects
% cd /home/ganka/git/AMD/DiffusionMeasure

load ACH_0210.mat
AMD = 1:8;
AMD_Ctl = 9:20;
%% argument check
if notDefined('fibID')
    fibID = [5,7,9];
end

if notDefined('Alpha')
    Alpha = 0.01;
end

fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
    'LOR30-90','ROR30-90'};

%% Figure
% figure;
for kk = fibID
    % indivisual FA value along optic tract
    fn = find(fibID==kk);
    %     subplot(1,3,fn); hold on;
    figure; hold on;
    % container
    nodes =  length(ACH{10,kk}.vals.fa);
    fa = nan(length(ACH), nodes);
    md = fa;
    ad = fa;
    rd = fa;
    cl = fa;
    pl = fa;
    sp = fa;
    % get values and merge both hemisphere
    for subID = 1:length(ACH)
        if isempty(ACH{subID,kk})
            fa(subID,:) =nan(1,nodes);
        else
            fa(subID,:) =  nanmean([ACH{subID,kk}.vals.fa;...
                ACH{subID,kk+1}.vals.fa]);
        end
        
        if isempty(ACH{subID,kk})
            md(subID,:) =nan(1,nodes);
        else
            md(subID,:) = nanmean([ ACH{subID,kk}.vals.md;...
                ACH{subID,kk+1}.vals.md]);
        end
        
        if isempty(ACH{subID,kk})
            rd(subID,:) =nan(1,nodes);
        else
            rd(subID,:) = nanmean([ ACH{subID,kk}.vals.rd;...
                ACH{subID,kk+1}.vals.rd]);
        end
        
        if isempty(ACH{subID,kk})
            ad(subID,:) =nan(1,nodes);
        else
            ad(subID,:) = nanmean([ ACH{subID,kk}.vals.ad;...
                ACH{subID,kk+1}.vals.ad]);
        end
        
        if isempty(ACH{subID,kk})
            cl(subID,:) =nan(1,nodes);
        else
            cl(subID,:) = nanmean([ ACH{subID,kk}.vals.cl;...
                ACH{subID,kk+1}.vals.cl]);
        end
        
        if isempty(ACH{subID,kk})
            sp(subID,:) =nan(1,nodes);
        else
            sp(subID,:) = nanmean([ ACH{subID,kk}.vals.sphericity;...
                ACH{subID,kk+1}.vals.sphericity]);
        end
        
        if isempty(ACH{subID,kk})
            pl(subID,:) =nan(1,nodes);
        else
            pl(subID,:) = nanmean([ ACH{subID,kk}.vals.planarity;...
                ACH{subID,kk+1}.vals.planarity]);
        end
    end
    
    %% FA
    val_AC = fa(AMD_Ctl,:);
    val_AMD = fa(AMD,:);
    AMD_data  = val_AMD;
    vals ='fa';
    
    % Wilcoxon Single rank test
    n = size(fa);
    nodes = n(2);
    
    %% ttest each node
    for jj= 1: nodes
        [H(jj),P(jj),~] = ttest2(fa(1:8,jj),fa(9:20,jj),'Alpha', Alpha);
%         [h,p,sigPairs] = ttest_bonf([fa(1:8,jj),fa(9:20,jj)],pairs,alpha,tail)
    end
    
    % logical 2 double
    H = H+0;
    
    %% FA
    %     G = figure; hold on;
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
        plot(X,AMD_data(k,:),'Color',c(k,:),...
            'linewidth',1);
    end
    m   = nanmean(AMD_data,1);
    plot(X,m,'Color',c(3,:) ,'linewidth',3)
    
    T = title(sprintf('%s vs AMD_C', fbName{kk}(3:end)));
    ylabel(upper(vals))
    xlabel('Location')
    
    % axis
    switch kk
        case {1}
            b=[0,0.7];
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
            
            % add infromation
%             text(20, .3, 'P<0.001')
            hold off;
    end
    clear h H
    % Save current figure
    saveas(gca,fullfile(pwd, [vals,'_',T.String,'.pdf']))
    
    %% AD
    vals ='ad';
    val_AC = ad(AMD_Ctl,:);
    val_AMD = ad(AMD,:);
    AMD_data  = val_AMD;
    
    %% ttest each node
    for jj= 1: nodes
        [H(jj),P(jj),~] = ttest2(ad(1:8,jj),ad(9:20,jj),'Alpha', Alpha);
    end

    % logical 2 double
    H = H+0;
    
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
        plot(X,AMD_data(k,:),'Color',c(k,:),...
            'linewidth',1);
    end
    m   = nanmean(AMD_data,1);
    plot(X,m,'Color',c(3,:) ,'linewidth',3)
    
    T = title(sprintf('%s vs AMD_C', fbName{kk}(3:end)));
    ylabel(upper(vals))
    xlabel('Location')
    
    switch kk
        case {1}
            b=[0.9, 2];
            % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
            set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
        case {3}
            b=[0.8,1.8];
            set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
        case {5,7,9}
            b=[0.8, 1.8];
            set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
    end
    clear H
   
    saveas(gca,fullfile(pwd, [vals,'_',T.String,'.pdf']))
    
    %% RD
    %
    vals ='rd';
    val_AC = rd(AMD_Ctl,:);
    val_AMD = rd(AMD,:);
    
    AMD_data  = val_AMD;
    
    %% ttest each node
    for jj= 1: nodes
        [H(jj),P(jj),~] = ttest2(rd(1:8,jj),rd(9:20,jj),'Alpha', Alpha);
    end
    
    % logical 2 double
    H = H+0;
    
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
        plot(X,AMD_data(k,:),'Color',c(k,:),...
            'linewidth',1);
    end
    m   = nanmean(AMD_data,1);
    plot(X,m,'Color',c(3,:) ,'linewidth',3)
    
    T = title(sprintf('%s comparing to AMD_C', fbName{kk}(3:end)));
    ylabel(upper(vals))
    xlabel('Location')
    
    % axis
    switch kk
        case {1}
            b=[0.4, 1.8];
            % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
            set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
        case {3}
            b=[0.2,1.1];
            set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
        case {5,7,9}
            b=[0.2,1.1];
            set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
    end
    clear H
    % % Save current figure

    saveas(gca,fullfile(pwd, [vals,'_',T.String,'.pdf']))
    
    
    %% MD
    %
    vals ='md';
    val_AC = md(AMD_Ctl,:);
    val_AMD = md(AMD,:);
    
    AMD_data  = val_AMD;
    
    %% ttest each node
    for jj= 1: nodes
        [H(jj),P(jj),~] = ttest2(md(1:8,jj),md(9:20,jj),'Alpha', Alpha);
    end
   
    % logical 2 double
    H = H+0;
    
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
    
    % add individual MD plot
    for k = 1:length(AMD) %1:length(subDir)
        plot(X,AMD_data(k,:),'color',c(k,:),...
            'linewidth',1);
    end
    m   = nanmean(AMD_data,1);
    plot(X,m,'Color',c(3,:) ,'linewidth',3)
    
    
    T = title(sprintf('%s comparing to AMD_C', fbName{kk}(3:end)));
    ylabel(upper(vals))
    xlabel('Location')
    
    % axis
    switch kk
        case {1}
            b=[0.8, 1.8];
            % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
            set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
        case {3}
            b=[0.6,1.1];
            set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
        case {5,7,9}
            b=[0.3,1.3];
            set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
    end
    clear H
    % Save current figure
    saveas(gca,fullfile(pwd, [vals,'_',T.String,'.pdf']))
    % end
    % return
    
    %% cl
    %
    vals ='cl';
    val_AC = cl(AMD_Ctl,:);
    val_AMD = cl(AMD,:);
    
    AMD_data  = val_AMD;
    
    % stats
    % container
    clear h
    
    for jj= 1: nodes
        %     [p(jj),h(jj),~] = ranksum(val_AC(:,jj),val_AMD(:,jj));
        [h(jj),P(jj),~] = ttest2(val_AC(:,jj),val_AMD(:,jj));
    end
    
    % logical 2 double
%     h = P < Alpha/nodes;
    
    H = h+0;
    
    % figure
    G = figure; hold on;
    X = 1:nodes;
    c = lines(length(AMD));
    
    bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
    
    
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
    
    T = title(sprintf('%s comparing to AMD_C', fbName{kk}(3:end)));
    ylabel(upper(vals))
    xlabel('Location')
    
    % axis
    switch kk
        case {1}
            b=[0, .4];
            % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
            set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            
            hold off;
        case {3}
            b=[0, .4];
            set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
        case {5,7,9}
            b=[0, .4];
            set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
            %         bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
    end
    clear h
    % Save current figure
    saveas(G,fullfile(pwd, [vals,'_',T.String]),'png')
    %     end
    
    %% Westin peoperties sp
    %
    vals ='sp';
    val_AC = sp(AMD_Ctl,:);
    val_AMD = sp(AMD,:);
    
    AMD_data  = val_AMD;
    
    % stats
    clear h
    
    for jj= 1: nodes
        %     [p(jj),h(jj),~] = ranksum(val_AC(:,jj),val_AMD(:,jj));
        [H(jj),P(jj),~] = ttest2(val_AC(:,jj),val_AMD(:,jj));
    end
    
    % logical 2 double
    H = H+0;
    
    % figure
    G = figure; hold on;
    X = 1:nodes;
    c = lines(length(AMD));
    
    bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
       
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
    
    T = title(sprintf('%s comparing to AMD_C', fbName{kk}(3:end)));
    ylabel(upper(vals))
    xlabel('Location')
    
    % axis
    % if b(1)<0;b(1)=0;end;
    % switch vals
    %     case {}
    switch kk
        case {1}
            b=[0.5, 1];
            % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
            set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            
            hold off;
        case {3}
            b=[0.3,.8];
            set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
        case {5,7,9}
            b=[0.4, 1.0];
            set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
            %         bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
    end
    clear h
    % Save current figure
    saveas(G,fullfile(pwd, [vals,'_',T.String]),'pdf')

    %% pl
    % Westin peoperties sp
    %
    vals ='pl';
    val_AC = pl(AMD_Ctl,:);
    val_AMD = pl(AMD,:);
    
    AMD_data  = val_AMD;
    
    % Wilcoxon rank sum test
    % container
    clear h
    
    for jj= 1: nodes
        %     [p(jj),h(jj),~] = ranksum(val_AC(:,jj),val_AMD(:,jj));
        [H(jj),P(jj),~] = ttest2(val_AC(:,jj),val_AMD(:,jj));
    end
    
    % logical 2 double
%     h = P < Alpha/nodes;
    
    H = H+0;
    
    % figure
    G = figure; hold on;
    X = 1:nodes;
    c = lines(length(AMD));
    
    bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
    
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
    
    T = title(sprintf('%s comparing to AMD_C', fbName{kk}(3:end)));
    ylabel(upper(vals))
    xlabel('Location')
    
    % axis
    % if b(1)<0;b(1)=0;end;
    % switch vals
    %     case {}
    switch kk
        case {1}
            b=[0, .3];
            % set(gca,'ylim',b,'yTick',b,'xLim',[0,length(X)],'xtickLabel','');
            set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            
            hold off;
        case {3}
            b=[0,0.5];
            set(gca,'ylim',b,'yTick',b,'xLim',[11,90],'XTick',[11 90],'xtickLabel','');
            bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
        case {5,7,9}
            b=[0, 0.4];
            set(gca,'ylim',b,'yTick',b,'xLim',[6,45],'XTick',[6,45],'xtickLabel','');
            %         bar(X,H*(b(1)+0.1),1.0,'EdgeColor','none')
            hold off;
    end
    clear h
    % Save current figure

    saveas(G,fullfile(pwd, [vals,'_',T.String]),'pdf')
end
