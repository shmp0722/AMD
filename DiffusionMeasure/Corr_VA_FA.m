%% FA and VA in

load 'FA03.mat'
load 'FA15.mat'
load 'FA90.mat'

R_VA = [-0.08, -0.19, 0.82, 1.22, 0.7, 1.22,1.1,0.1 ];
L_VA = [0 , 0.05, 0.82, 1, 1.05, 0.7, 1, -0.18];

Ave_VA = R_VA + L_VA;

[R, P] = corrcoef( mean( FA03(1:8 , :),2), Ave_VA')

[R, P] = corrcoef( mean( FA15(1:8 , :),2), Ave_VA')

[R, P] = corrcoef( mean( FA90(1:8 , :),2), Ave_VA')