function [Bad2nd,List] = Rerun_Dwi2nd



%% Check if ACH_CreatNifti ran correctly

% take subject list 
[homeDir , List] = SubJect;

% new list
Bad2nd = zeros(1,length(List));

%% loop for all subjects
for ii = 1:length(List)
    rawDir = fullfile(homeDir,List{ii},'raw');    
    NI = dir(fullfile(rawDir,'*dwi2nd.nii.gz'));   
    
    
    % choose a file has less than 10^7 bytes dwi2nd
    if  NI.bytes < 10^7,
        
        % keep this subect to correct the data
        Bad2nd(1,ii) = 1;
        dwi2ndDir = fullfile(homeDir,List{ii},'dwi2nd');
        
        Bvec = dir(fullfile(dwi2ndDir,'*.bvec'));
        Bval = dir(fullfile(dwi2ndDir,'*.bval'));
        Dwi2nd = dir(fullfile(dwi2ndDir,'*iso.nii.gz'));
        copyfile(fullfile(dwi2ndDir,Bvec.name),fullfile(rawDir,'dwi2nd.bvec'));
        copyfile(fullfile(dwi2ndDir,Bval.name),fullfile(rawDir,'dwi2nd.bval'));
        copyfile(fullfile(dwi2ndDir,Dwi2nd.name),fullfile(rawDir,'dwi2nd.nii.gz'));
        clear Bval Bvec
            
    end
end

