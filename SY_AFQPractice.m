function SY_AFQPractice
%
% Practicing AFQ codes
%
%
%
%



%%
% Get the path to the AFQ directories
  
% set home dir and individual subject
  baseDir = '/home/ganka/dMRI_data';    
  SubDirs = {'Ctl-RT-20150426','Ctl-YM-20150426','Ctl-SO-20150426'};
  
  % create full path (homedir + indv ID)
  for ii = 1:length(SubDirs)
    sub_dirs{ii} = fullfile(baseDir,SubDirs{ii},'dwi_1st');
  end  

%   % Create a vector of 0s and 1s defining who is a patient and a control
  sub_group = [0, 0, 0]; 
%   zeros(1,length(SubDirs))  
  
%   % Run AFQ in test mode to save time. No inputs are needed to run AFQ 
%   % with the default settings. AFQ_Create builds the afq structure. This
%   % will also be done automatically by AFQ_run if the user does not wish 
%   % to modify any parameters
  afq = AFQ_Create( 'sub_dirs', sub_dirs, 'sub_group', sub_group); 
  
  [afq] = AFQ_run(sub_dirs, sub_group, afq)