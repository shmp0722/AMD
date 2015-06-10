function CompareTwoScan_JMD_AW(Pre, Post)
%
%
% 
%
%
% Example
% Post = 'Ctr-SY-20150531';
% Pre = 'Ctr-SY-20150426';

%% take two dt6 files
Pre_dir = '/home/ganka/dMRI_data/Ctr-SY-20150426/dwi_1st';
dt6_pre = dtiLoadDt6('/home/ganka/dMRI_data/Ctr-SY-20150426/dwi_1st/dt6.mat');

Post_dir = '/home/ganka/dMRI_data/Ctr-SY-20150531/dwi_1st';
dt6_post = dtiLoadDt6('/home/ganka/dMRI_data/Ctl-SY-20150531/dwi_1st/dt6.mat');

%% Just substruct Post- Pre 
dt6_substructed = dt6_post.dt6 - dt6_pre.dt6; 

% if image is needed
showMontage(dt6_substructed,[],jet(256))

%% 
Fg = '/home/ganka/dMRI_data/Ctr-SY-20150426/dwi_1st/fibers/1021_ctx-lh-pericalcarineFG.pdb';
fg = fgRead(Fg);

% calculate diffusion properties

% using  pre dt6 
[fa{1}, md{1}, rd{1}, ad{1}, cl{1}, TractProfile{1}] = AFQ_ComputeTractProperties(fg, dt6_pre, 100, 0, Pre_dir, 1, []);

% using post dt6
[fa{2}, md{2}, rd{2}, ad{2}, cl{2}, TractProfile{2}] = AFQ_ComputeTractProperties(fg, dt6_post, 100, 0, Post_dir, 1, []);

% lets render two lines
figure; hold on;
plot(1:100, fa{1}(:),'r')
plot(1:100, fa{2}(:),'b')

figure; hold on;
bar(1:100, fa{1}(:)- fa{2}(:),'r')







