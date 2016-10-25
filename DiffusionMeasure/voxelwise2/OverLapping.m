function OverLapping

%%
load /home/ganka/git/AMD/DiffusionMeasure/voxelwise2/T.mat


%% setdiff rate between two facicles  
mean(T.OR03vs1530_stdf)
mean(T.OR1530vs3090_stdf)
mean(T.OR03vs3090_stdf)

ttest2(T.OR03vs1530_stdf(1:8),T.OR03vs1530_stdf(1:8))
ttest2(T.OR1530vs3090_stdf(1:8),T.OR1530vs3090_stdf(1:8))
ttest2(T.OR03vs3090_stdf(1:8),T.OR03vs3090_stdf(1:8))