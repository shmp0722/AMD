
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

% 2 usb 1Tb 
% cmd = '!rsync -auv /media/HDPC-UT/dMRI_data/ /media/HDPC-UT_/dMRI_data/';


cmd = '!rsync -auv /media/USB_HDD1/ /media/USB_HDD2/';
% cmd = '!rsync --delete -auv /media/USB_HDD1/ /media/USB_HDD2/';


% if backup HDD is almost full. Use --delete option. This will delete
% deleted sourse files. 
% cmd = '!rsync -auv --delete /media/HDPC-UT/dMRI_data/ /media/HDPC-UT_/dMRI_data/';

eval(cmd)

% % qMRI
% cmd = '!rsync -auv /media/USB_HDD1/qMRI_data/ /media/USB_HDD2/qMRI_data/';
% 
% % cmd = '!rsync -auv /media/HDPC-UT/qMRI_data/ /media/HDPC-UT_/qMRI_data/';
% eval(cmd)
