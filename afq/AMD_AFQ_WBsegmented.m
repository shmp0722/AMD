function AMD_AFQ_WBsegmented
%
% Plot patient data against controls
%
%
% See: AFQ_PlotPatientMeans
%

%% load afq structure

load afq_29-Jan-2017.mat

%% Which nodes and vals to analyze

% exclude first and last 10 nodes from fibers
nodes = 21:80;

% define vals
valname = {'fa' 'md' 'rd' 'ad'};

% Get number of fiber groups and their names
nfg = AFQ_get(afq,'nfg');% nfg = 28;
fgNames = AFQ_get(afq,'fgnames');

% Set the colormap and color range for the renderings
cmap = AFQ_colormap('bgr');
% cmap = lines(256);

% cmap =colormap;
crange = [-4 4];

%% Loop over the different values
for v = 1:length(valname)
    % Open a new figure window for the mean plot
    figure; hold('on');
    
    % patient and control data
    %     pVals = AFQ_get(afq,'patient data');
    cVals = AFQ_get(afq,'control data');
    
    % Loop over each fiber group
    for ii = 1:nfg
        % Get the values for the patient and compute the mean
        vals_p = AFQ_get(afq,fgNames{ii},valname{v});
        
        % Get the value for each control and compute the mean
        vals_c = cVals(ii).(upper(valname{v}));
        vals_c = vals_c(:,nodes);
        vals_cm = nanmean(vals_c,2);
        
        % Compute control group mean and sd
        m = nanmean(vals_cm);
        sd = nanstd(vals_cm);
        
        % Plot control group means and sd
        x = [ii-.2 ii+.2 ii+.2 ii-.2 ii-.2];
        y1 = [m-sd m-sd m+sd m+sd m-sd];
        y2 = [m-2*sd m-2*sd m+2*sd m+2*sd m-2*sd];
        fill(x,y2, [.6 .6 .6],'edgecolor',[0 0 0]);
        fill(x,y1,[.4 .4 .4] ,'edgecolor',[0 0 0]);
        
        % plot individual means
        for jj = 1:sum(afq.sub_group)
            vals_cur = vals_p(jj,nodes);
            m_curr   = nanmean(vals_cur);
            % Define the color of the point for the fiber group based on its zscore
            tractcol = vals2colormap((m_curr - m)./sd,cmap,crange);
            
            % Plot patient mean as a circle
            plot(ii, m_curr,'ko', 'markerfacecolor',tractcol,'MarkerSize',6);
        end
    end
    
    
    %% make fgnames shorter
    %     newfgNames = {'l-TR','r-TR','l-C','r-C','l-CC','r-CC','l-CH','r-CH','CFMa',...
    %         'CFMi','l-IFOF','r-IFOF','l-ILF','r-ILF','l-SLF','r-SLF','l-U','r-U',...
    %         'l-A','r-A'};
    
    %     set(gca,'xtick',1:nfg,'xticklabel',newfgNames,'xlim',[0 nfg+1],'fontname','times','fontsize',11);
    set(gca,'xtick',1:nfg,'xticklabel',fgNames,'xlim',[0 nfg+1],'fontname','times','fontsize',11);
    set(gca, 'XTickLabelRotation',90)
    ylabel(upper(valname{v}));
    
    h = colorbar('AxisLocation','out');
    h.Label.String = 'z score';
    
    saveas(gca,sprintf('%s.eps',upper(valname{v})),'epsc')
end
return


%% 2nd, merge both hemisphere

Merged = [1,3,5,7,9,10,11,13,15,17,18];
cVals = AFQ_get(afq,'control data');
% Loop over the different values
for v = 1:length(valname)
    % Open a new figure window for the mean plot
    figure; hold('on');
    
    % Loop over each fiber group
    for ii = Merged
        
        % Merging if bilateral
        switch ii
            case 9,10
                % Get the values for the patient and compute the mean
                vals_p = AFQ_get(afq,fgNames{ii},valname{v});
                % Get the value for each control and compute the mean
                vals_c = cVals(ii).(upper(valname{v}));
                vals_c = vals_c(:,nodes);
                vals_cm = nanmean(vals_c,2);
                
            otherwise
                vals_p = (AFQ_get(afq,fgNames{ii},valname{v})+AFQ_get(afq,fgNames{ii+1},valname{v}))/2;
                % Get the value for each control and compute the mean
                vals_c = (cVals(ii).(upper(valname{v}))+cVals(ii+1).(upper(valname{v}))/2);
                vals_c = vals_c(:,nodes);
                vals_cm = nanmean(vals_c,2);
        end
        
%         % Get the value for each control and compute the mean
%         vals_c = cVals(ii).(upper(valname{v}));
%         vals_c = vals_c(:,nodes);
%         vals_cm = nanmean(vals_c,2);
        
        % Compute control group mean and sd
        m = nanmean(vals_cm);
        sd = nanstd(vals_cm);
        
        X = find(Merged==ii);
        
        % Plot control group means and sd
        x = [X-.2 X+.2 X+.2 X-.2 X-.2];
        y1 = [m-sd m-sd m+sd m+sd m-sd];
        y2 = [m-2*sd m-2*sd m+2*sd m+2*sd m-2*sd];
        fill(x,y2, [.6 .6 .6],'edgecolor',[0 0 0]);
        fill(x,y1,[.4 .4 .4] ,'edgecolor',[0 0 0]);
        
        % plot individual means
        for jj = 1:sum(afq.sub_group)
            vals_cur = vals_p(jj,nodes);
            m_curr   = nanmean(vals_cur);
            % Define the color of the point for the fiber group based on its zscore
            tractcol = vals2colormap((m_curr - m)./sd,cmap,crange);
            
            % Plot patient mean as a circle
            plot(X, m_curr,'ko', 'markerfacecolor',tractcol,'MarkerSize',6);
        end
    end
    
    
    % make fgnames shorter
    for k = 1:length(Merged)
        newfgNames{k} = fgNames{Merged(k)};
    end
    %     set(gca,'xtick',1:nfg,'xticklabel',newfgNames,'xlim',[0 nfg+1],'fontname','times','fontsize',11);
    set(gca, 'xtick',1:length(Merged),'xticklabel',newfgNames,...
        'xlim',[0 length(Merged)+1],'fontname','times','fontsize',11);
    set(gca, 'XTickLabelRotation',90)
    ylabel(upper(valname{v}));
    
    h = colorbar('AxisLocation','out');
    h.Label.String = 'z score';
    
    % save a file 
    saveas(gca,sprintf('%s_merged.eps',upper(valname{v})),'epsc')
end
clear newfgNames


%% Focus on Visual pathways


Focus  = [10,29,31,33,35];
% Focus  = [9,10,29,31,33,35];
Merged = [1,3,5,7,9,10,11,13,15,17,18];
CC     = [21:28];
cVals = AFQ_get(afq,'control data');

% Loop over the different values
for v = 1:length(valname)
    % Open a new figure window for the mean plot
    figure; hold('on');
    
    % Loop over each fiber group
    for ii = Focus
        
        % Merging if bilateral
        switch ii
            case 9,10
                % Get the values for the patient and compute the mean
                vals_p = AFQ_get(afq,fgNames{ii},valname{v});
                % Get the value for each control and compute the mean
                vals_c = cVals(ii).(upper(valname{v}));
                vals_c = vals_c(:,nodes);
                vals_cm = nanmean(vals_c,2);
                
            otherwise
                vals_p = (AFQ_get(afq,fgNames{ii},valname{v})+AFQ_get(afq,fgNames{ii+1},valname{v}))/2;
                % Get the value for each control and compute the mean
                vals_c = (cVals(ii).(upper(valname{v}))+cVals(ii+1).(upper(valname{v}))/2);
                vals_c = vals_c(:,nodes);
                vals_cm = nanmean(vals_c,2);
        end
        
%         % Get the value for each control and compute the mean
%         vals_c = cVals(ii).(upper(valname{v}));
%         vals_c = vals_c(:,nodes);
%         vals_cm = nanmean(vals_c,2);
        
        % Compute control group mean and sd
        m = nanmean(vals_cm);
        sd = nanstd(vals_cm);
        
        X = find(Focus==ii);
        
        % Plot control group means and sd
        x = [X-.2 X+.2 X+.2 X-.2 X-.2];
        y1 = [m-sd m-sd m+sd m+sd m-sd];
        y2 = [m-2*sd m-2*sd m+2*sd m+2*sd m-2*sd];
        fill(x,y2, [.6 .6 .6],'edgecolor',[0 0 0]);
        fill(x,y1,[.4 .4 .4] ,'edgecolor',[0 0 0]);
        
        % plot individual means
        for jj = 1:sum(afq.sub_group)
            vals_cur = vals_p(jj,nodes);
            m_curr   = nanmean(vals_cur);
            % Define the color of the point for the fiber group based on its zscore
            tractcol = vals2colormap((m_curr - m)./sd,cmap,crange);
            
            % Plot patient mean as a circle
            plot(X, m_curr,'ko', 'markerfacecolor',tractcol,'MarkerSize',6);
        end
    end
    
    
    % make fgnames shorter
    for k = 1:length(Focus)
        newfgNames{k} = fgNames{Focus(k)};
    end
    %     set(gca,'xtick',1:nfg,'xticklabel',newfgNames,'xlim',[0 nfg+1],'fontname','times','fontsize',11);
    set(gca, 'xtick',1:length(Focus),'xticklabel',newfgNames,...
        'xlim',[0 length(Focus)+1],'fontname','times','fontsize',11);
    set(gca, 'XTickLabelRotation',90)
    ylabel(upper(valname{v}));
    
    h = colorbar('AxisLocation','out');
    h.Label.String = 'z score';
    
    % save a file 
    saveas(gca,sprintf('%s_focus.eps',upper(valname{v})),'epsc')
end
return
    
%% Focus on Visual pathways

switch Class
    case 'focus'
        FG  = [10,29,31,33,35];
    case 'merged','Merged'
        FG = [1,3,5,7,9,10,11,13,15,17,18];
    case 'CC','cc'
        FG = 21:28;
end
cVals = AFQ_get(afq,'control data');

% Loop over the different values
for v = 1:length(valname)
    % Open a new figure window for the mean plot
    figure; hold('on');
    
    % Loop over each fiber group
    for ii = Focus
        
        % Merging if bilateral
        switch ii
            case 9,10
                % Get the values for the patient and compute the mean
                vals_p = AFQ_get(afq,fgNames{ii},valname{v});
                % Get the value for each control and compute the mean
                vals_c = cVals(ii).(upper(valname{v}));
                vals_c = vals_c(:,nodes);
                vals_cm = nanmean(vals_c,2);
                
            otherwise
                vals_p = (AFQ_get(afq,fgNames{ii},valname{v})+AFQ_get(afq,fgNames{ii+1},valname{v}))/2;
                % Get the value for each control and compute the mean
                vals_c = (cVals(ii).(upper(valname{v}))+cVals(ii+1).(upper(valname{v}))/2);
                vals_c = vals_c(:,nodes);
                vals_cm = nanmean(vals_c,2);
        end
        
%         % Get the value for each control and compute the mean
%         vals_c = cVals(ii).(upper(valname{v}));
%         vals_c = vals_c(:,nodes);
%         vals_cm = nanmean(vals_c,2);
        
        % Compute control group mean and sd
        m = nanmean(vals_cm);
        sd = nanstd(vals_cm);
        
        X = find(Focus==ii);
        
        % Plot control group means and sd
        x = [X-.2 X+.2 X+.2 X-.2 X-.2];
        y1 = [m-sd m-sd m+sd m+sd m-sd];
        y2 = [m-2*sd m-2*sd m+2*sd m+2*sd m-2*sd];
        fill(x,y2, [.6 .6 .6],'edgecolor',[0 0 0]);
        fill(x,y1,[.4 .4 .4] ,'edgecolor',[0 0 0]);
        
        % plot individual means
        for jj = 1:sum(afq.sub_group)
            vals_cur = vals_p(jj,nodes);
            m_curr   = nanmean(vals_cur);
            % Define the color of the point for the fiber group based on its zscore
            tractcol = vals2colormap((m_curr - m)./sd,cmap,crange);
            
            % Plot patient mean as a circle
            plot(X, m_curr,'ko', 'markerfacecolor',tractcol,'MarkerSize',6);
        end
    end
    
    
    % make fgnames shorter
    for k = 1:length(Focus)
        newfgNames{k} = fgNames{Focus(k)};
    end
    %     set(gca,'xtick',1:nfg,'xticklabel',newfgNames,'xlim',[0 nfg+1],'fontname','times','fontsize',11);
    set(gca, 'xtick',1:length(Focus),'xticklabel',newfgNames,...
        'xlim',[0 length(Focus)+1],'fontname','times','fontsize',11);
    set(gca, 'XTickLabelRotation',90)
    ylabel(upper(valname{v}));
    
    h = colorbar('AxisLocation','out');
    h.Label.String = 'z score';
    
    % save a file 
    saveas(gca,sprintf('%s_focus.eps',upper(valname{v})),'epsc')
end
return
    
