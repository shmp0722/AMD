function V1ECC_smooth


%%

%% 
ROIdir1 = '/media/HDPC-UT/dMRI_data/JMD-Ctl-SY-20130222DWI/fs_Retinotopy2';
ROIdir2 = '/media/HDPC-UT/dMRI_data/JMD-Ctl-SY-20130222DWI/ROIs';

ROIs = {'lh_Ecc0to3.mat','lh_Ecc15to30.mat','lh_Ecc30to90.mat',...
    'rh_Ecc0to3.mat','rh_Ecc15to30.mat','rh_Ecc30to90.mat'};

V1 = dtiReadRoi(fullfile(ROIdir2,'lh_V1_smooth3mm.mat'));

for ii = 1:length(ROIs);
    Cur_ROI = dtiReadRoi(fullfile(ROIdir1,ROIs{ii}));
    Ymax = max(Cur_ROI.coords(:,2));
    Ymin = min(Cur_ROI.coords(:,2));

    
    %% Clip
    newV1 = V1;
    switch ii
        case {1,4}
            apClip = [Ymax, 80];
            [roi, ~] = dtiRoiClip(newV1, [], apClip, []);

        case {2,3,5,6}
            apClip = [Ymax, 80];
            [roi, ~] = dtiRoiClip(newV1, [], apClip, []);
            apClip = [-120, Ymin];            
            [roi, ~] = dtiRoiClip(roi, [], apClip, []);
    end

    [~,n]  = fileparts(ROIs{ii});
    roi.name = [n,'_smooth3mm'];
    dtiWriteRoi(roi, fullfile(ROIdir1,roi.name))
    dtiWriteRoi(roi, fullfile(ROIdir2,roi.name))
end


% 
% SelectedVnum =  newV1.coords(:,2)<= Ymax;
% newV1.coords(SelectedVnum)
% 
% Box =nan(sum(SelectedVnum),3);
% New = sub2ind(Box, newV1.coords(SelectedVnum,1),newV1.coords(SelectedVnum,2),newV1.coords(SelectedVnum,3));
% 
% ind = sub2ind(size(fa), img_coords(:,1), img_coords(:,2),img_coords(:,3));
% 
% 
% 
% 
% [coords(:,1), coords(:,2), coords(:,3)] = ind2sub(size(roiImg), find(roiImg));



