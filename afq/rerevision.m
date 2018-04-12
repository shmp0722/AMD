%% load afq

load('/home/ganka/git/AMD/afq/afq_12-Apr-2018.mat')

%%
[norms, patient_data, control_data, afq] = AFQ_ComputeNorms(afq);

save /home/ganka/git/AMD/afq/afq_12-Apr-2018.mat afq

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
