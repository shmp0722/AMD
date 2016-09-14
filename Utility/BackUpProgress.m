function BackUpProgress

% rsync -av sourse direction
% 
% Example
% rsync -av dir1/ backup/
%
%


% %% All back up
% cmd = '!rsync -av /media/HDPC-UT/rsync_test/ /media/HDPC-UT_/rsync_test/';
% eval(cmd)

%% only added or vhanged files -u
% dMRI

cmd = '!rsync -auv /media/HDPC-UT/dMRI_data/ /media/HDPC-UT_/dMRI_data/';

% if backup HDD is almost full. Use --delete option. This will delete
% deleted sourse files. 
% cmd = '!rsync -auv --delete /media/HDPC-UT/dMRI_data/ /media/HDPC-UT_/dMRI_data/';

eval(cmd)

% qMRI
cmd = '!rsync -auv /media/HDPC-UT/qMRI_data/ /media/HDPC-UT_/qMRI_data/';
eval(cmd)
