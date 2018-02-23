%% compare center portino of optic radiation

% load FA values
load 'FA03.mat'
load 'FA15.mat'
load 'FA90.mat'

% patient & healthy
patient   = 1:8;
Helathy   = 9:20;

%% t-test on each node 

% ttest each node
% rank sum
for jj= 1: length(FA03)
                    [H03(jj),P03(jj),~] = ttest2(FA03(1:8,jj),FA03(9:20,jj));
%     [P03(jj),H03(jj)] = ranksum(FA03(patient,jj),FA03(Helathy,jj));
    
                    [H15(jj),P15(jj),~] = ttest2(FA03(1:8,jj),FA03(9:20,jj));
%     [P15(jj),H15(jj)] = ranksum(FA15(patient,jj),FA15(Helathy,jj));

                    [H90(jj),P90(jj),~] = ttest2(FA03(1:8,jj),FA03(9:20,jj));
%     [P15(jj),H15(jj)] = ranksum(FA90(patient,jj),FA90(Helathy,jj));
end


%% pickup a center portion in R1 where is significant difference  
portion =  find(H03);

%%
% just reshaping
[a,b] = size(FA03(1:8, portion));
[c,d] = size(FA03(9:20, portion));

FA03_p = reshape(FA03(1:8, portion), 1 , a*b);
FA03_h = reshape(FA03(9:20, portion),1,c*d);

FA15_p = reshape(FA15(1:8, portion), 1 , a*b);
FA15_h = reshape(FA15(9:20, portion),1,c*d);

FA90_p = reshape(FA90(1:8, portion), 1 , a*b);
FA90_h = reshape(FA90(9:20, portion),1,c*d);

% ttest
[h03,p03,ci03,stats03] = ttest2(FA03_p, FA03_h);
[h15,p15,ci15,stats15] = ttest2(FA15_p, FA15_h);
[h90,p90,ci90,stats90] = ttest2(FA90_p, FA90_h);

%% figure
% bar plot R1
figure;
hold on;
% subplot(1,3,1); 
bar(1:2,[mean(FA03_p),mean(FA03_h)],0.3)
errorbar(1:2,[mean(FA03_p),mean(FA03_h)],[std(FA03_p), std(FA03_h)],'.')

set(gca,'XTick',[1,2],'XTickLabel',{'Patient', 'Healthy'})
set(gca,'YLim', [0 .7] , 'YTick',[0 .7])
ylabel 'FA'
text(1.45, 0.65 ,'***','FontSize', 18)
text(1.3, 0.6 ,sprintf('p = %s',p03),'FontSize', 12)
title 'R1'

%% R2
figure
hold on;
% subplot(1,3,2); 

bar(1:2,[mean(FA15_p),mean(FA15_h)],0.3)
errorbar(1:2,[mean(FA15_p),mean(FA15_h)],[std(FA15_p), std(FA15_h)],'.')

set(gca,'XTick',[1,2],'XTickLabel',{'Patient', 'Healthy'})
set(gca,'YLim', [0 .7] , 'YTick',[0 .7])
ylabel 'FA'
text(1.45, 0.65 ,'***','FontSize', 18)
text(1.3, 0.6 ,sprintf('p = %s',p15),'FontSize', 12)
title 'R2'

%% R3
figure
hold on;
% subplot(1,3,3);
bar(1:2,[mean(FA90_p),mean(FA90_h)],0.3)
errorbar(1:2,[mean(FA90_p),mean(FA90_h)],[std(FA90_p), std(FA90_h)],'.')

set(gca,'XTick',[1,2],'XTickLabel',{'Patient', 'Healthy'})
set(gca,'YLim', [0 .7] , 'YTick',[0 .7])
ylabel 'FA'
% text(1.45, 0.65 ,'***','FontSize', 18)
text(1.30, 0.6 ,sprintf('p = %s',p90),'FontSize', 12)
title 'R3'

%% group bar plot would be better

figure
hold on
hBar = bar(1:2, [mean(FA03_p),mean(FA03_h); mean(FA15_p),mean(FA15_h);...
 mean(FA90_p),mean(FA90_h)],0.3);

for k1 = 1:2
    ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
    ydt(k1,:) = hBar(k1).YData;
end


errorbar(ctr,ydt, [std(FA03_p),std(FA03_h); std(FA15_p),std(FA15_h);...
 std(FA90_p),std(FA90_h)],'.')

set(gca,'XTick',[1,2],'XTickLabel',{'Patient', 'Healthy'})
set(gca,'YLim', [0 .7] , 'YTick',[0 .7])
ylabel 'FA'





