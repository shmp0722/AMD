function Merged_AMD_plot_ranksum(fibID,SavePath)
% individual FA value along the core of OR and optic tract.
%
% Repository dependencies
%    VISTASOFT
%    AFQ
%    shmp07nn+1/AMD
%
%
% Shumpei Ogawa 2014

%% load raw data and subjects
Git
cd AMD/afq
load afq_04-Feb-2017.mat

AMD = 1:8;
AMD_Ctl = 9:20;
%% argument check
fgnames = afq.fgnames;

fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
    'LOR30-90','ROR30-90'};
if notDefined('fibID')
    fibID = 1;
end

if notDefined('SavePath')
    SavePath = pwd;
end

if notDefined('val')
    val = fieldnames(afq.vals);
end

%% Render all val
% [norms, patient_data, control_data, afq] = AFQ_ComputeNorms(afq);
% Group plots
for nn = [21,23,25,27]
    for kk =[8,9,11,12] ;%[1:9,11,12]
        Ctl = AFQ_get(afq,'control_data');
        Pt = AFQ_get(afq,'patient_data');
        
        % define the colors to be used for each groups plot
        c =lines(length(afq.vals.ad));
        figure; hold on;
        % merged
        OT_P = ( Pt(nn).(upper(val{kk})) + Pt(nn+1).(upper(val{kk})))/2;
        OT_C = ( Ctl(nn).(upper(val{kk})) + Ctl(nn+1).(upper(val{kk})))/2;
        
        label = upper(val{kk});
        
        % Wilcoxon rank sum test
        nodes = length(Pt(nn).(upper(val{kk}))) ;
        for jj= 1: nodes
            [p(jj),h(jj)] = ranksum(OT_P(:,jj),OT_C(:,jj));
        end
        % logical2double
        h = h+0;
        
        % number of subjects with measurements for this tract
        n  = sum(~isnan(OT_P(:,1)));
        % group mean diffusion profile
        m  = nanmean(OT_P);
        M  = nanmean(OT_C);
        
        % plot the mean
        bar(1:nodes,h,1.0,'EdgeColor','none')
        plot(m,'-','Color',c(nn,:),'linewidth',3);
        plot(M,'-','Color',[0 0 0],'linewidth',3);
        
        
        % plot the confidence interval
        % standard deviation at each node
        sd = nanstd(OT_C);
        plot(M+sd,'--','Color',[0 0 0]);
        plot(M-sd,'--','Color',[0 0 0]);
        plot(M+sd*2,'--','Color',[0 0 0]);
        plot(M-sd*2,'--','Color',[0 0 0]);
        % label the axes etc.
        xlabel('Location','fontName','Times','fontSize',12);
        ylabel(label,'fontName','Times','fontSize',12);
        title(afq.fgnames{nn}(2:4),'fontName','Times','fontSize',12);
        
        switch kk
            case {1}
                set(gca,'fontName','Times','fontSize',12,'YLim',[0 0.6],'XLim',[0 nodes]);
            case {2:9,11,12}
                set(gca,'fontName','Times','fontSize',12,'XLim',[0 nodes]);
                
        end
    end
    % add a legend to the plot
    %         legend(h,gnames);
end

%% Render OD
% [norms, patient_data, control_data, afq] = AFQ_ComputeNorms(afq);
% Group plots
Ctl = AFQ_get(afq,'control_data');
Pt = AFQ_get(afq,'patient_data');
c =lines(length(afq.vals.ad));
  nodes = 11:90;
for nn = [21,23,25,27]
    % [21,23,25,27,29]
    kk =9 ;%[1:9,11,12]
    % define the colors to be used for each groups plot
    
    figure; hold on;
    % merged
    OT_P = ( Pt(nn).(upper(val{kk})) + Pt(nn+1).(upper(val{kk})))/2;
    OT_C = ( Ctl(nn).(upper(val{kk})) + Ctl(nn+1).(upper(val{kk})))/2;
    
    label = upper(val{kk});
    
    % Wilcoxon rank sum test
    %         nodes = length(Pt(nn).(upper(val{kk}))) ;
  
    for jj= nodes
        [p(jj),h(jj)] = ranksum(OT_P(:,jj),OT_C(:,jj));
    end
    % logical2double
    h = h+0;
    
    % number of subjects with measurements for this tract
    n  = sum(~isnan(OT_P(:,1)));
    % group mean diffusion profile
    m  = nanmean(OT_P);
    M  = nanmean(OT_C);
    
    % plot the mean
    bar(nodes,h(nodes),1.0,'EdgeColor','none')
    plot(m,'-','Color',c(nn,:),'linewidth',3);
    plot(M,'-','Color',[0 0 0],'linewidth',3);
    
    % plot the confidence interval
    % standard deviation at each node
    sd = nanstd(OT_C);
    plot(M+sd,'--','Color',[0 0 0]);
    plot(M-sd,'--','Color',[0 0 0]);
    plot(M+sd*2,'--','Color',[0 0 0]);
    plot(M-sd*2,'--','Color',[0 0 0]);
    % label the axes etc.
    xlabel('Location','fontName','Times','fontSize',12);
    ylabel(label,'fontName','Times','fontSize',12);
    title(afq.fgnames{nn}(2:5),'fontName','Times','fontSize',12);
    
%    switch nn
%        case {27}
%            set(gca,'fontName','Times','fontSize',12,'XLim',[11 90],'YLim',[0, 0.4]);
%        case {21,23,25}
           set(gca,'fontName','Times','fontSize',12,'XLim',[11 90],'YLim',[0, 0.4]);
%    end
    
    %         end
    %     end
    % add a legend to the plot
    %         legend(h,gnames);
end

%% correlation FA vs OD

nn = 23;% [21,23,25,27]
kk = 1;
% [8,9,11,12] ;%[1:9,11,12]
Ctl = AFQ_get(afq,'control_data');
Pt = AFQ_get(afq,'patient_data');

% define the colors to be used for each groups plot
%         c =lines(length(afq.vals.ad));
% merged
FA_OT_P = ( Pt(nn).FA + Pt(nn+1).FA)/2;
OD_OT_P = ( Pt(nn).FIT_OD + Pt(nn+1).FIT_OD)/2;

FA_OT_C = ( Ctl(nn).FA + Ctl(nn+1).FA)/2;
OD_OT_C = ( Ctl(nn).FIT_OD + Ctl(nn+1).FIT_OD)/2;

figure; hold on;
plot(FA_OT_P(:),OD_OT_P(:),'or')
xlabel FA
ylabel OD
title 'Pt OR'
lsline

[h,p] = corr(FA_OT_P(:),OD_OT_P(:))

figure; hold on;
%         FA_OT_C(isnan(FA_OT_C))=[];
plot(FA_OT_C(:),OD_OT_C(:),'ob')
xlabel FA
ylabel OD
title 'Ctl OR'
lsline


% remove nan

[h,p] = corrcoef(FA_OT_C(:),OD_OT_C(:),'rows','pairwise')
mdl  = fitglm(FA_OT_C(:),OD_OT_C(:))


%% correlation FA vs OD

nn = 23;% [21,23,25,27]
kk = 1;
% [8,9,11,12] ;%[1:9,11,12]
Ctl = AFQ_get(afq,'control_data');
Pt = AFQ_get(afq,'patient_data');

% define the colors to be used for each groups plot
%         c =lines(length(afq.vals.ad));
% merged
FA_OT_P = ( Pt(nn).FA + Pt(nn+1).FA)/2;
OD_OT_P = ( Pt(nn).FIT_OD + Pt(nn+1).FIT_OD)/2;

FA_OT_C = ( Ctl(nn).FA + Ctl(nn+1).FA)/2;
OD_OT_C = ( Ctl(nn).FIT_OD + Ctl(nn+1).FIT_OD)/2;

figure; hold on;
plot(FA_OT_P(:),OD_OT_P(:),'or')
xlabel FA
ylabel OD
title 'Pt OR'
lsline

[h,p] = corr(FA_OT_P(:),OD_OT_P(:))

figure; hold on;
%         FA_OT_C(isnan(FA_OT_C))=[];
plot(FA_OT_C(:),OD_OT_C(:),'ob')
xlabel FA
ylabel OD
title 'Ctl OR'
lsline


% remove nan

[h,p] = corrcoef(FA_OT_C(:),OD_OT_C(:),'rows','pairwise')
mdl  = fitglm(FA_OT_C(:),OD_OT_C(:))

%
 OD = (afq.vals.FIT_OD{23}+afq.vals.FIT_OD{24})/2;
 FA = (afq.vals.fa{23}+afq.vals.fa{24})/2;
 
 [h,p] = corrcoef(OD(:), FA(:),'rows','pairwise')

 figure;hold on;
 plot(FA(:), OD(:),'o')
 xlabel FA
 ylabel OD
 
 
 

%% Individual plots
%  Plot the norms and confidence intervals then add each individual patient
%  to the plot
if sum(strcmpi('individual',arg)) == 1
    % The first set of data will be norms. Collect the property of interest
    norms = data{1};
    % number of nodes to be plotted
    nnodes = size(data{1}.meanFA,1);
    % collect the value of interest
    switch(property)
        case 'fa'
            Meanvals = norms.meanFA;
            SDvals   = norms.sdFA;
            axisScale = [1 nnodes .2 .9];
            label = 'Fractional Anisotropy';
        case 'rd'
            Meanvals = norms.meanRD;
            SDvals   = norms.sdRD;
            axisScale = [1 nnodes .2 .9];
            label = 'Radial Diffusivity';
        case 'ad'
            Meanvals = norms.meanAD;
            SDvals   = norms.sdAD;
            axisScale = [1 nnodes 1 2.1];
            label = 'Axial Diffusivity';
        case 'md'
            Meanvals = norms.meanMD;
            SDvals   = norms.sdMD;
            axisScale = 'auto';
            label = 'Mead Diffusivity';
        otherwise
            % look for the value in the structure and change the case if
            % needed
            if isfield(norms, ['mean' property]);
                fprintf('\nPlotting %s\n',property);
            elseif isfield(norms, ['mean' upper(property)]);
                property = upper(property);
                fprintf('\nPlotting %s\n',property);
            elseif isfield(norms, ['mean' lower(property)]);
                property = lower(property);
                fprintf('\nPlotting %s\n',property);
            else
                error('Property %s could not be found',property);
            end
            Meanvals = norms.(['mean' property]);
            SDvals = norms.(['sd' property]);
            axisScale = 'auto';
            label = property;
    end
    % make a legend if desired
    if sum(strcmpi('legend',varargin)) > 0
        L = varargin{find(strcmpi('legend',varargin))+1};
    else
        L = [];
    end
    % Define the confidence intervals to be plotted. Percentiles are
    % converted to z scores
    if sum(strcmpi('ci',varargin)) > 0
        cutoff = varargin{find(strcmpi('ci',varargin))+1};
    else
        % if no confidence interval is defined use 10 and 90
        cutoff = [10 90];
    end
    cutZ=norminv(cutoff*.01);
    cutZ2=norminv([.25 .75]);
    % plot the norms for each tract
    for jj = tracts
        figure(fignums(jj));hold on;
        % plot 10 and 90 percentile bands unless the user defines another
        % confidence interval
        x = [1:nnodes fliplr(1:nnodes)];
        y = vertcat(Meanvals(:,jj)+max(cutZ)*SDvals(:,jj), flipud(Meanvals(:,jj)+min(cutZ)*SDvals(:,jj)));
        fill(x,y, [.6 .6 .6]);
        clear y
        % plot the 25 and 75 percentile bands
        y = vertcat(Meanvals(:,jj)+max(cutZ2)*SDvals(:,jj), flipud(Meanvals(:,jj)+min(cutZ2)*SDvals(:,jj)));
        fill(x,y, [.3 .3 .3]);
        clear y
        % plot the mean
        plot(Meanvals(:,jj),'-','Color','k','LineWidth',5);
        % scale the axes and name them
        axis(axisScale);
        xlabel('Location','fontName','Times','fontSize',12);
        ylabel(label,'fontName','Times','fontSize',12)
        title(fgNames{jj},'fontName','Times','fontSize',12)
        set(gcf,'Color','w');
        set(gca,'Color',[.9 .9 .9],'fontName','Times','fontSize',12)
    end
    % the second set of data will be individual subjects
    subData = data{2};
    % define the colors to be used for each individual
    c = hsv(length(subjects)).*0.6;
    % Loop over all the tracts
    for jj = tracts
        figure(fignums(jj));
        % Collect the property of interest for tract jj
        subVals = [];
        switch(property)
            case 'fa'
                subVals = subData(jj).FA;
            case 'rd'
                subVals = subData(jj).RD;
            case 'ad'
                subVals = subData(jj).AD;
            case 'md'
                subVals = subData(jj).MD;
            otherwise
                subVals = subData(jj).(property);
        end
        % For each tract loop over the number of subjects and plot each
        % on the same plot with the norms
        cnum = 0;
        for ii = subjects
            cnum = cnum+1;
            h(ii) = plot(subVals(ii,:)','-','Color',c(cnum,:),'linewidth',2);
        end
        % add a legend to the plot if desired
        if ~isempty(L)
            legend(h(subjects),L);
        end
    end
    
    % Save the figures if desired
    if ~isempty(outdir)
        cd(outdir);
        for jj = tracts
            figure(fignums(jj));
            fname = [fgNames{jj} property];
            print(gcf, '-depsc',fname)
        end
    end
end

%% Colormap plots
% Plot each individual subject and the group mean.  The Color of the group
% mean will vary based on the value at that location on the tract profile.
if sum(strcmpi('colormap',arg)) == 1
    % Check if a legend is desired
    if sum(strcmpi('legend',varargin)) > 0
        L = varargin{find(strcmpi('legend',varargin))+1};
    else
        L = [];
    end
    % Check if the colormap range is defined
    if sum(strcmpi('cmap',varargin)) > 0
        FArange = varargin{find(strcmpi('cmap',varargin))+1};
    else
        FArange = [.3 .6];
    end
    % the first set of data will be individual subjects
    subData = data{1};
    % number of nodes to be plotted
    nnodes = length(subData(1).FA(1,:));
    
    % Loop over all the tracts
    for jj = 1 : length(tracts)
        % collect the property of interest for tract jj
        switch(property)
            case 'fa'
                subVals(:,:,tracts(jj)) = subData(tracts(jj)).FA;
                axisScale = [1 nnodes .2 .9];
                label = 'Fractional Anisotropy';
            case 'rd'
                subVals(:,:,tracts(jj)) = subData(tracts(jj)).RD;
                axisScale = [1 nnodes .2 .9];
                label = 'Radial Diffusivity';
            case 'ad'
                subVals(:,:,tracts(jj)) = subData(tracts(jj)).AD;
                axisScale = [1 nnodes 1 2.1];
                label = 'Axial Diffusivity';
            case 'md'
                subVals(:,:,tracts(jj)) = subData(tracts(jj)).MD;
                axisScale = [1 nnodes .6 1.3];
                label = 'Mean Diffusivity';
            otherwise
                subVals(:,:,tracts(jj)) = AFQ_get(afq, fgNames{tracts(jj)},property);
                label = property;
        end
        
        figure(fignums(jj)); hold on;
        % For each tract loop over the number of subjects and plot each
        % on the same axis
        for ii = 1 : length(subVals(:,1))
            h(ii) = plot(subVals(ii,:,tracts(jj))','-','Color',[.5 .5 .5],'linewidth',1);
        end
        % add a legend to the plot if desired
        if ~isempty(L)
            legend(h(1:length(L)),L);
        end
    end
    
    % To plot the mean we will heatmap each location on the mean
    % profile based on it's FA value and plot a sphere there.
    for jj=1:length(tracts)
        figure(fignums(jj));hold on;
        % compute the mean tract profile
        meanTP = nanmean(subVals(:,:,tracts(jj)));
        % Interpolate the mean profile so the heatmap transitions smoothly
        meanTPinterp = interp1(1:100,meanTP,linspace(1,100,1000));
        % Set the colormap
        c = jet(256);
        % Create a evenly spaced linear mapping between values in the tract
        % profile and colors in the colormap
        lm = linspace(FArange(1), FArange(2),256);
        % Compute the apropriate color for each point on the tract profile
        for k = 1:length(meanTPinterp)
            d = [];
            d = abs(meanTPinterp(k) - lm);
            [tmp, mcolor(k)] = min(d);
        end
        % Plot each point on the tract profile a circle of the apropriate
        % color
        for k = 1:1000
            plot(k./10,meanTPinterp(k),'.','Color',c(mcolor(k),:),'markersize',40);
        end
        % scale the axes and name them
        if exist('axisScale') && ~isempty(axisScale)
            axis(axisScale);
        else
            axis('normal');
        end
        xlabel('Location','fontName','Times','fontSize',12);
        ylabel(label,'fontName','Times','fontSize',12)
        title(fgNames{tracts(jj)},'fontName','Times','fontSize',12)
        set(gcf,'Color','w');
        set(gca,'fontName','Times','fontSize',12)
    end
end
%% Save figures if an output directory is defined
if savefigs==1
    cd(outdir)
    for ii=1:length(fa)
        figure(ii);
        set(gcf,'Color','w','InvertHardCopy','off','PaperPositionMode','auto');
        saveas(gcf,['Figure' num2str(ii)],'png');
    end
end





% OT_val =nanmean([afq.vals.(val{1}){nn};afq.vals.(val{1}){nn+1}]);
%%
% percentiles to define normal range
ci = afq.params.cutoff;
ci =[5, 95]; %95

% loop over tracts and plot abnormal subjects
for jj = nn:length(afq.vals.fa)
    % Find subjects that show an abnormality on tract jj
    sub_nums = find(abnTracts(:,jj));
    % Generate a structure for a legend
    L = {};
    for ii = 1:length(sub_nums)
        L{ii} = num2str(sub_nums(ii));
    end
    if ~isempty(sub_nums)
        AFQ_plot(norms, patient_data,'individual','ci',ci,'subjects',sub_nums,'tracts',jj,'legend',L);
    end
    % AFQ_PlotResults(patient_data, norms, abn, afq.params.cutoff,property, afq.params.numberOfNodes, afq.params.outdir, afq.params.savefigs);
end


%% Plot group means for the patients and the controls

% Only plot if there is data for patients and controls
if sum(sub_group == 1) > 2 && sum(sub_group == 0) > 2 && AFQ_get(afq,'showfigs')
    AFQ_plot('Patients', patient_data, 'Controls', control_data, 'group');
elseif sum(sub_group == 1) <= 2 && sum(sub_group == 0) <= 2
    fprintf('\nNot enough subjects for a group comparison\n')
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

%% FA
val_AC = fa(AMD_Ctl,:);
val_AMD = fa(AMD,:);
AMD_data  = val_AMD;
vals ='fa';

% Wilcoxon Single rank test
n = size(fa);
nodes = n(2);

% ttest each node
for jj= 1: nodes
    [H(jj),P(jj),~] = ttest2(fa(1:8,jj),fa(9:20,jj));
end

% logical 2 double
% h = h+0;

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

