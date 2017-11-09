function ACH_V1RoiCutEccentricity(subID, MinDegree, MaxDegree)
% z
%
% You need to run fs_retinotopicTemplate and get eccecntricity map before this function.  
% See; fs_retinotopicTemplate
%
% Example
%
% [homeDir ,subDir] = SubJect;
%
% subID = 9; % = subDir{9}
% MinDegree = 0;
% MaxDegree = 15;
% ACH_V1RoiCutEccentricity(subID, MinDegree, MaxDegree)
%
% SO@ACH 2015.8
%
%% Set the path to data directory

[homeDir ,~] = SubJect;

if ~exist('subID', 'var')
    warning('Subject ID is required input'); %#ok<WNTAG>
%     eval('help fs_autosegmentToITK');
    return
end
%% Divide V1 ROI based on eccentricity
% for ii = subID;    
    eccDir  = fullfile(homeDir,subID,'fs_Retinotopy2');    
    hemi ={'lh','rh'};
    for j =  1 : length(hemi)
        %% Load ecc or pol nii.gz
        ni =niftiRead(fullfile(eccDir,sprintf('%s_%s_ecc.nii.gz',subID,hemi{j})));        
        %% select voxels has less than Maximum
        % foveal ROL
        EccROI = ni;
        EccROI.data(EccROI.data >= MaxDegree)=0;
        EccROI.data(EccROI.data < MinDegree)=0;
        EccROI.data(EccROI.data >0) = 1;
        
        % ROI name
        EccROI.fname = fullfile(fileparts(ni.fname),sprintf('%s_Ecc%dto%d',hemi{j},MinDegree,MaxDegree));

        %% save the ROI
        % nii.gz
        niiName =  [EccROI.fname,'.nii.gz'];
        niftiWrite(EccROI,niiName)
        
        % mat
        matName =  [EccROI.fname,'.mat'];
        binary = true; save = true;
        dtiRoiFromNifti(niiName,0,matName,'mat',binary,save);                
       
    end
% end

return