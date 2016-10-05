%% load files

load ACH.mat

% detecting PC used
if exist('/home/ganka','dir')
    read_AMD_VA
elseif exist('shumpei','dir')
    read_AMD_VA2
end

%
patient =1:8;
sub_group =zeros(20,1);
sub_group(patient,1) =1;

% remind fiber ordering and give merged name
fbName = {'L-OT','R-OT','L-OR','R-OR','LOR0-3','ROR0-3','LOR15-30','ROR15-30'...
    'LOR30-90','ROR30-90'};

Merged = {'OR','OR03','OR15','OR90'};

valname = {'fa','ad','rd'};

if notDefined('fibID')
    fibID = [3,5,7,9];
end

if notDefined('savefig')
savefig =0;
end

%% merged both hemisphere
for v =1:length(fibID)
    % get values and merge both hemisphere
    for subID = 1:20; % patient (8) + healthy (12) subject is 20
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

%% fit a logistic regression model for FA
sub_group;

for Nnode = 1:length(val_OR03.fa)
    %OR03
    mdl03 = fitglm(val_OR03.fa(:,Nnode),sub_group,'Distribution','binomial','Link','logit');
    
    scores = mdl03.Fitted.Probability;
    [X03,Y03,T03,AUC03(Nnode)] = perfcurve(sub_group,scores,1);
    
    %OR15
    mdl15 = fitglm(val_OR15.fa(:,Nnode),sub_group,'Distribution','binomial','Link','logit');
    
    scores = mdl15.Fitted.Probability;
    [X15,Y15,T15,AUC15(Nnode)] = perfcurve(sub_group,scores,1);
    
    %OR90
    mdl90 = fitglm(val_OR90.fa(:,Nnode),sub_group,'Distribution','binomial','Link','logit');
    
    scores = mdl90.Fitted.Probability;
    [X90,Y90,T90,AUC90(Nnode)] = perfcurve(sub_group,scores,1);
    
end

%% See the result
figure; hold on;
C = jet(3);
l1 = plot(AUC03,'color',C(1,:),'linewidth',2);
l2 = plot(AUC15, 'color',C(2,:),'linewidth',2);
l3 = plot(AUC90,'color',C(3,:),'linewidth',2);


xlabel('Number of node')
ylabel('AUC')

ylim = get(gca,'YLim');

% remove dirst and last 10% nodes
xlim = get(gca,'XLim');
xlim = [xlim(2)*.1+1,xlim(2)-xlim(2)*.1];

plot(xlim,[.5 .5],'--','color',[.5 .5 5.5])

set(gca,'YTick',ylim,'XLim',xlim,'XTick',xlim,'TickDir','out')

legend([l1,l2,l3],'0-3','15-30','30-90')
title('AUC from FA in each node')




if savefig ==1,
    saveas(gca,'AUCfromFA.eps','epsc')
    saveas(gca,'AUCfromFA.png')
end


%% fit a logistic regression model for AD
sub_group;

for Nnode = 1:length(val_OR03.ad)
    %OR03
    mdl03 = fitglm(val_OR03.ad(:,Nnode),sub_group,'Distribution','binomial','Link','logit');
    
    scores = mdl03.Fitted.Probability;
    [~,~,~,AUC03(Nnode)] = perfcurve(sub_group,scores,1);
    clear scores
   
    %OR15
    mdl15 = fitglm(val_OR15.ad(:,Nnode),sub_group,'Distribution','binomial','Link','logit');
    
    scores = mdl15.Fitted.Probability;
    [X,Y,T,AUC15(Nnode)] = perfcurve(sub_group,scores,1);
     clear scores

    
    %OR90
    mdl90 = fitglm(val_OR90.ad(:,Nnode),sub_group,'Distribution','binomial','Link','logit');
    
    scores = mdl90.Fitted.Probability;
    [X,Y,T,AUC90(Nnode)] = perfcurve(sub_group,scores,1);
    clear scores

end
clear X Y T
%% See the result
figure; hold on;
C = jet(3);
l1 = plot(AUC03,'color',C(1,:));
l2 = plot(AUC15, 'color',C(2,:));
l3 = plot(AUC90,'color',C(3,:));

xlabel('Number of node')
ylabel('AUC')
legend([l1,l2,l3],'0-3','15-30','30-90')
title('AUC from AD')


%% fit a logistic regression model for RD
sub_group;

for Nnode = 1:length(val_OR03.rd)
    %OR03
    mdl03 = fitglm(val_OR03.rd(:,Nnode),sub_group,'Distribution','binomial','Link','logit');
    
    scores = mdl03.Fitted.Probability;
    [~,~,~,AUC03(Nnode)] = perfcurve(sub_group,scores,1);
    clear scores
   
    %OR15
    mdl15 = fitglm(val_OR15.rd(:,Nnode),sub_group,'Distribution','binomial','Link','logit');
    
    scores = mdl15.Fitted.Probability;
    [X,Y,T,AUC15(Nnode)] = perfcurve(sub_group,scores,1);
     clear scores

    
    %OR90
    mdl90 = fitglm(val_OR90.rd(:,Nnode),sub_group,'Distribution','binomial','Link','logit');
    
    scores = mdl90.Fitted.Probability;
    [X,Y,T,AUC90(Nnode)] = perfcurve(sub_group,scores,1);
    clear scores

end
clear X Y T
% See the result
figure; hold on;
C = jet(3);
l1 = plot(AUC03,'color',C(1,:));
l2 = plot(AUC15, 'color',C(2,:));
l3 = plot(AUC90,'color',C(3,:));

xlabel('Number of node')
ylabel('AUC')
legend([l1,l2,l3],'0-3','15-30','30-90')
title('AUC from RD')


return
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fit a logistic regression
mdl03 = fitglm(val_OR03.fa,sub_group,'Distribution','binomial','Link','logit');
score_log = mdl03.Fitted.Probability; % Probability estimates

% compute the standard ROC
[Xlog,Ylog,Tlog,AUClog] = perfcurve(sub_group,score_log,1);

% Train an SVM classifier
mdlSVM = fitcsvm(val_OR03.fa,sub_group,'Standardize',true);
mdlSVM = fitPosterior(mdlSVM);

% compute the posterior probabilities (scores)
[~,score_svm] = resubPredict(mdlSVM);

% comupute the standard ROC using the score from SVM
[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(sub_group,score_svm(:,mdlSVM.ClassNames),1);

% fit naive Bayes classifier
mdlNB = fitcnb(val_OR03.fa,sub_group);

% compute the scores
[~,score_nb] = resubPredict(mdlNB);

% compute the standard ROC using scores from NB
[Xnb,Ynb,Tnb,AUCnb] = perfcurve(sub_group,score_nb,1);

% plot the ROC curves
plot(Xlog,Ylog)
hold on
plot(Xsvm,Ysvm)
plot(Xnb,Ynb)
legend('Logistic Regression','Support Vector Machines','Naive Bayes','Location','Best')
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC Curves for Logistic Regression, SVM, and Naive Bayes Classification')
hold off




%% sample code form mathworks
load ionosphere
resp = strcmp(Y,'b'); % resp = 1, if Y = 'b', or 0 if Y = 'g'
pred = X(:,3:34);

% fit a logistic regression
mdl03 = fitglm(pred,resp,'Distribution','binomial','Link','logit');
score_log = mdl03.Fitted.Probability; % Probability estimates

% compute the standard ROC
[Xlog,Ylog,Tlog,AUClog] = perfcurve(resp,score_log,'true');

% Train an SVM classifier
mdlSVM = fitcsvm(pred,resp,'Standardize',true);
mdlSVM = fitPosterior(mdlSVM);

% compute the posterior probabilities (scores)
[~,score_svm] = resubPredict(mdlSVM);

% comupute the standard ROC using the score from SVM
[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(resp,score_svm(:,mdlSVM.ClassNames),'true');

% fit naive Bayes classifier
mdlNB = fitcnb(pred,resp);

% compute the scores
[~,score_nb] = resubPredict(mdlNB);

% compute the standard ROC using scores from NB
[Xnb,Ynb,Tnb,AUCnb] = perfcurve(resp,score_nb(:,mdlNB.ClassNames),'true');

% plot the ROC curves
figure; hold on ; 
plot(Xlog,Ylog)
plot(Xsvm,Ysvm)
plot(Xnb,Ynb)
legend('Logistic Regression','Support Vector Machines','Naive Bayes','Location','Best')
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC Curves for Logistic Regression, SVM, and Naive Bayes Classification')
hold off

