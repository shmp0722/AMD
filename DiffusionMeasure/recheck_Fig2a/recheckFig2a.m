%% check Fig2a


%% load subject data
load('sub_group.mat')
load('data.mat')

%%
figure; hold on 

for ii = 1:8
    plot(data(ii,:),'-r')
end

m = mean(data(1:8,:));
plot(m,'-r','linewidth',2);

% add contorols

M  = nanmean(data(9:20,:));
plot(M,'linewidth',2,'color',[0 0 0])

SD = nanstd(data(9:20,:));
 
plot(M+2*SD,'--','color',[.4 .4 .4])
plot(M-2*SD,'--','color',[.4 .4 .4])

plot(M+SD,'--','color',[.7 .7 .7])
plot(M-SD,'--','color',[.7 .7 .7])

% stats
% Wilcoxon rank sum test
nodes = length(data);
for jj= 1: nodes    
    
    % Wilcoxon signed rank test
%     [p(jj),h(jj),~] = signrank([data(1:8,jj);nan(4,1)],data(9:20,jj));
     [p(jj),h(jj)] =ranksum([data(1:8,jj);nan(4,1)],data(9:20,jj));
    
    % ttest
    [H(jj),P(jj),~] = ttest2(data(1:8,jj),data(9:20,jj));
    %     co = multcompare(stats(jj),'display','off');
    %     C{jj}=co;
end

bar(h*0.1)

hold off;

%%
figure; hold on 

for ii = 1:8
    plot(data(ii,:),'-r')
end

m = mean(data(1:8,:));
plot(m,'-r','linewidth',2);

% add contorols

M  = nanmean(data(9:20,:));
plot(M,'linewidth',2,'color',[0 0 0])

SD = nanstd(data(9:20,:));
 
plot(M+2*SD,'--','color',[.4 .4 .4])
plot(M-2*SD,'--','color',[.4 .4 .4])

plot(M+SD,'--','color',[.7 .7 .7])
plot(M-SD,'--','color',[.7 .7 .7])

bar(H*0.1)

