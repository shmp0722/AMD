function AMD_AFQ_WBsegmented
%
% Plot patient data against controls
%
%
% See: AFQ_PlotPatientMeans
%

%% load afq structure

load /home/ganka/git/AMD/afq/afq_13-Sep-2016.mat

%% Which nodes and vals to analyze

% exclude first and last 10 nodes from fibers
nodes = 21:80;

% define vals
valname = {'fa' 'md' 'rd' 'ad'};

% Get number of fiber groups and their names
nfg = AFQ_get(afq,'nfg');% nfg = 28;
fgNames = AFQ_get(afq,'fgnames');

% % Set the views for each fiber group
% fgviews = {'leftsag', 'rightsag', 'leftsag', 'rightsag', ...
%     'leftsag', 'rightsag', 'leftsag', 'rightsag', 'axial', 'axial',...
%     'leftsag', 'rightsag', 'leftsag', 'rightsag',  'leftsag', 'rightsag'...
%     'leftsag', 'rightsag', 'leftsag', 'rightsag'};
% % Slices to add to the rendering
% slices = [-5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0;...
%     0 0 -5; 0 0 -5; -5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0; -5 0 0; 5 0 0];

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
    
    saveas(gca,sprintf('%s.eps',upper(valname{v})),'psc2')
end
return
