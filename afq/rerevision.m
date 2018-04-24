%% load afq

% load('/home/ganka/git/AMD/afq/afq_12-Apr-2018.mat')
load('afq_12-Apr-2018.mat')

%% compute nomrms
% [norms, patient_data, control_data, afq] = AFQ_ComputeNorms(afq);
%
% save /home/ganka/git/AMD/afq/afq_12-Apr-2018.mat afq

%%
fgNames = AFQ_get(afq,'fgnames');
nnodes = 6:95;

% color
c = lines(sum(afq.sub_group));

% input check 'property'
if notDefined('property')
    property = 'fa';
end

if notDefined('Alpha')
    Alpha = 0.05;
end

FgNum = 1:length(fgNames);
%% dipic figures
figure;

for ii =  FgNum;
    subplot(4,7,ii); hold on;
    
    % Control
    % collect the value of interest
    switch(property)
        case 'fa'
            st_c = afq.norms.sdFA';
            m_c   = afq.norms.meanFA';
            pt = afq.patient_data(ii).FA;
            
            ctl = afq.control_data(ii).FA;
            label = 'Fractional Anisotropy';
        case 'rd'
            st_c = afq.norms.sdRD';
            m_c   = afq.norms.meanRD';
            pt = afq.patient_data(ii).RD;
            ctl = afq.control_data(ii).RD;
            
            label = 'Radial Diffusivity';
        case 'ad'
            st_c = afq.norms.sdAD';
            m_c   = afq.norms.meanAD';
            pt = afq.patient_data(ii).AD;
            ctl = afq.control_data(ii).AD;
            
            label = 'Axial Diffusivity';
        case 'md'
            st_c = afq.norms.sdMD';
            m_c   = afq.norms.meanMD';
            pt = afq.patient_data(ii).MD;
            ctl = afq.control_data(ii).MD;
            
            label = 'Mead Diffusivity';
    end
    
    %     [a,b] = size(m_c);
    
    % render control subjects range
    A3 = area(m_c(ii,:)+2*st_c(ii,:));
    A1 = area(m_c(ii,:)+st_c(ii,:));
    A2 = area(m_c(ii,:)-st_c(ii,:));
    A4 = area(m_c(ii,:)-2*st_c(ii,:));
    
    % set color and style
    set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
    set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A4,'FaceColor',[1 1 1],'linestyle','none')
    
    plot(m_c(ii,:),'color',[0 0 0], 'linewidth',3 )
    
    % add individual FA plot
    for k = 1: sum(afq.sub_group) %1:length(subDir)
        plot(1:100, pt(k,:),'--','Color',[1  0  0],...
            'linewidth',1);
    end
    m  = nanmean(pt,1);
    plot(1:100,m,'Color',[1  0  0] ,'linewidth',3)
    
    T = title(fgNames{ii});
    ylabel(upper(property))
    xlabel('Location')
    
    % add stats
    for jj = 1:100
        [h(jj),p(jj)] = ttest2(pt(:,jj), ctl(:,jj), 'Alpha',Alpha);
    end
    
    bar(1:100,h*0.25,1.0,'EdgeColor','none')
    
    set(gca,'YLim',[0.1 1],'xLim',[6,95],'xtickLabel','');
    hold off;
    
    %     % save figure
    %     saveas(gca,sprintf('RerevisionForBSF/%s_%s.pdf',...
    %         fgNames{ii}(~isspace(fgNames{ii})),property))
end


%% merged bilateral
% dipic figures
figure;

% FG_analized = [1,3,5,7,11,13,15,17,19,9,10, 21:28];
FG_analized = [1,3,5,7,11,13,15,17,19,9,10];

for ii =  FG_analized;
    tmp = find(FG_analized == ii);
    
%     subplot(4,5,tmp); hold on;
    subplot(3,4,tmp); hold on;
    switch ii
        case {9,10,21:28}
            
            % collect the value of interest
            switch(property)
                case 'fa'
                    st_c = afq.norms.sdFA';
                    m_c   = afq.norms.meanFA';
                    pt = afq.patient_data(ii).FA;
                    
                    ctl = afq.control_data(ii).FA;
                    label = 'Fractional Anisotropy';
                    
                    T = title(fgNames{ii}); % Graph title for subplot
                    
                    % render control subjects range
                    A3 = area(m_c(ii,:)+2*st_c(ii,:));
                    A1 = area(m_c(ii,:)+st_c(ii,:));
                    A2 = area(m_c(ii,:)-st_c(ii,:));
                    A4 = area(m_c(ii,:)-2*st_c(ii,:));
                    
                case 'rd'
                    st_c = afq.norms.sdRD';
                    m_c   = afq.norms.meanRD';
                    pt = afq.patient_data(ii).RD;
                    ctl = afq.control_data(ii).RD;
                    
                    label = 'Radial Diffusivity';
                    T = title(fgNames{ii}); % Graph title for subplot
                    
                    % render control subjects range
                    A3 = area(m_c(ii,:)+2*st_c(ii,:));
                    A1 = area(m_c(ii,:)+st_c(ii,:));
                    A2 = area(m_c(ii,:)-st_c(ii,:));
                    A4 = area(m_c(ii,:)-2*st_c(ii,:));
                    
                case 'ad'
                    st_c = afq.norms.sdAD';
                    m_c   = afq.norms.meanAD';
                    pt = afq.patient_data(ii).AD;
                    ctl = afq.control_data(ii).AD;
                    
                    label = 'Axial Diffusivity';
                    T = title(fgNames{ii}); % Graph title for subplot
                    
                    % render control subjects range
                    A3 = area(m_c(ii,:)+2*st_c(ii,:));
                    A1 = area(m_c(ii,:)+st_c(ii,:));
                    A2 = area(m_c(ii,:)-st_c(ii,:));
                    A4 = area(m_c(ii,:)-2*st_c(ii,:));
                    
                case 'md'
                    st_c = afq.norms.sdMD';
                    m_c   = afq.norms.meanMD';
                    pt = afq.patient_data(ii).MD;
                    ctl = afq.control_data(ii).MD;
                    
                    label = 'Mead Diffusivity';
                    T = title(fgNames{ii}); % Graph title for subplot
                    
                    % render control subjects range
                    A3 = area(m_c(ii,:)+2*st_c(ii,:));
                    A1 = area(m_c(ii,:)+st_c(ii,:));
                    A2 = area(m_c(ii,:)-st_c(ii,:));
                    A4 = area(m_c(ii,:)-2*st_c(ii,:));
                    
            end
            
        case {1;3;5;7;11;13;15;17;19}
            % collect the value of interest
            switch(property)
                case 'fa'
                    st_c = afq.norms.sdFA';
                    m_c   = afq.norms.meanFA';
                    pt = (afq.patient_data(ii).FA...
                        + afq.patient_data(ii+1).FA)./2;
                    
                    ctl = (afq.control_data(ii).FA + ...
                        afq.control_data(ii).FA)./ 2;
                    label = 'Fractional Anisotropy';
                    
                    Space = strfind(fgNames{ii},' ');
                    T = title(fgNames{ii}( Space(1)+1:end)); % Graph title for subplot
                    
                    % render control subjects range
                    A3 = area(m_c(ii,:) + st_c(ii,:)+st_c(ii+1,:) );
                    A1 = area(m_c(ii,:) + (st_c(ii,:)+st_c(ii+1,:))./2 );
                    A2 = area(m_c(ii,:) - (st_c(ii,:)+st_c(ii+1,:))./2 );
                    A4 = area(m_c(ii,:) - (st_c(ii,:)+st_c(ii+1,:)) );
                    
                case 'rd'
                    st_c = afq.norms.sdRD';
                    m_c   = afq.norms.meanRD';
                    pt = (afq.patient_data(ii).RD...
                        + afq.patient_data(ii+1).RD)./2;
                    
                    ctl = (afq.control_data(ii).RD + ...
                        afq.control_data(ii).RD)./ 2;
                    
                    label = 'Radial Diffusivity';
                    % Graph title for subplot
                    Space = strfind(fgNames{ii},' ');
                    T = title(fgNames{ii}( Space(1)+1:end));
                    % render control subjects range
                    A3 = area(m_c(ii,:) + st_c(ii,:)+st_c(ii+1,:) );
                    A1 = area(m_c(ii,:) + (st_c(ii,:)+st_c(ii+1,:))./2 );
                    A2 = area(m_c(ii,:) - (st_c(ii,:)+st_c(ii+1,:))./2 );
                    A4 = area(m_c(ii,:) - (st_c(ii,:)+st_c(ii+1,:)) );
                    
                case 'ad'
                    st_c = afq.norms.sdAD';
                    m_c   = afq.norms.meanAD';
                    pt = (afq.patient_data(ii).AD...
                        + afq.patient_data(ii+1).AD)./2;
                    
                    ctl = (afq.control_data(ii).AD + ...
                        afq.control_data(ii).AD)./ 2;
                    
                    label = 'Axial Diffusivity';
                    % Graph title for subplot
                    Space = strfind(fgNames{ii},' ');
                    T = title(fgNames{ii}( Space(1)+1:end));
                    % render control subjects range
                    A3 = area(m_c(ii,:) + st_c(ii,:)+st_c(ii+1,:) );
                    A1 = area(m_c(ii,:) + (st_c(ii,:)+st_c(ii+1,:))./2 );
                    A2 = area(m_c(ii,:) - (st_c(ii,:)+st_c(ii+1,:))./2 );
                    A4 = area(m_c(ii,:) - (st_c(ii,:)+st_c(ii+1,:)) );
                    
                case 'md'
                    st_c = afq.norms.sdMD';
                    m_c   = afq.norms.meanMD';
                    pt = (afq.patient_data(ii).MD...
                        + afq.patient_data(ii+1).MD)./2;
                    
                    ctl = (afq.control_data(ii).MD + ...
                        afq.control_data(ii).MD)./ 2;
                    
                    label = 'Mead Diffusivity';
                    % Graph title for subplot
                    Space = strfind(fgNames{ii},' ');
                    T = title(fgNames{ii}( Space(1)+1:end));
                    % render control subjects range
                    A3 = area(m_c(ii,:) + st_c(ii,:)+st_c(ii+1,:) );
                    A1 = area(m_c(ii,:) + (st_c(ii,:)+st_c(ii+1,:))./2 );
                    A2 = area(m_c(ii,:) - (st_c(ii,:)+st_c(ii+1,:))./2 );
                    A4 = area(m_c(ii,:) - (st_c(ii,:)+st_c(ii+1,:)) );
            end
    end
    
    
    
    
    % set color and style
    set(A1,'FaceColor',[0.6 0.6 0.6],'linestyle','none')
    set(A2,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A3,'FaceColor',[0.8 0.8 0.8],'linestyle','none')
    set(A4,'FaceColor',[1 1 1],'linestyle','none')
    
    plot(m_c(ii,:),'color',[0 0 0], 'linewidth',3 )
    
    % add individual FA plot
    for k = 1: sum(afq.sub_group) %1:length(subDir)
        plot(1:100, pt(k,:),'--','Color',[1  0  0],...
            'linewidth',1);
    end
    m  = nanmean(pt,1);
    plot(1:100,m,'Color',[1  0  0] ,'linewidth',3)
    
    ylabel(upper(property))
    xlabel('Location')
    
    % add stats
    for jj = 1:100
        [h(jj),p(jj)] = ttest2(pt(:,jj), ctl(:,jj), 'Alpha',Alpha/50);
    end
    
    bar(1:100,h*0.25,1.0,'EdgeColor','none')
    
    set(gca,'YLim',[0.1 1],'xLim',[6,95],'xtickLabel','');
    hold off;
    
    %     % save figure
    %     saveas(gca,sprintf('RerevisionForBSF/%s_%s.pdf',...
    %         fgNames{ii}(~isspace(fgNames{ii})),property))
end



%%
selected = fgNames;
selected{1, 21:end} = [];

AFQ_MakeFiberGroupMontage(afq, selected); %%,'numfibers',500)


%% compare tract profile with AMD_Ctl

% % ANOVA
%  group =2;
%  M = length(AMD_Ctl);
%  pac = nan(M,group);
%
%
% for jj= 1: nodes
%     pac(:,1)= val_AC(:,jj);
%     pac(1:8,2)= val_AMD(:,jj);
%     [p(jj),~,stats(jj)] = anova1(pac,[],'off');
% %     co = multcompare(stats(jj),'display','off');
% %     C{jj}=co;
% end
% Portion =  p<0.05; % where is most effected
%
% Portion = Portion+0;
