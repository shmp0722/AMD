function Smooth3ROi

%
% Smoothing a ROI in 3mm
%

%%

[dMRI, List, AMD, AMD_Ctl, RP, Ctl] = SubJect;

for ii = 21:length(List);
    ROIdir = fullfile(dMRI,List{ii},'fs_Retinotopy2');
    if exist(ROIdir)
        cd(ROIdir)
        %%
        niftiRoiName = ...
            {'lh_Ecc0to3','lh_Ecc15to30','lh_Ecc30to90',...
            'rh_Ecc0to3','rh_Ecc15to30','rh_Ecc30to90'};
        for kk = 1:length(niftiRoiName)
            if exist([niftiRoiName{kk},'.nii.gz'])
                % smoothing in 3mm
                smoothingKernel =3;
                niftiRoi       = niftiRead([niftiRoiName{kk},'.nii.gz']);
                niftiRoi.data  = single(dtiCleanImageMask(niftiRoi.data,smoothingKernel));
                niftiRoi.fname = sprintf('%s_smooth%imm', niftiRoiName{kk}, smoothingKernel);
                
                niftiWrite(niftiRoi);
                
                % create a mat roi from nifti
                outName     = [niftiRoi.fname,'.mat'];
                maskValue   =  0;
                outType     = 'mat';
                binary      = true;
                save        = true;
                roi = dtiRoiFromNifti(fullfile(pwd,[niftiRoi.fname,'.nii.gz']),maskValue,outName,outType,binary,save);
                
                % clean a roi
                roi    = dtiRoiClean(roi,3,[1, 0, 0]);
                dtiWriteRoi(roi,[roi.name,'_cleaned.mat'])
            end
        end
    end
end

%%

