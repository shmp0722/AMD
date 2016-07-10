fileNameList ='/media/HDPC-UT/dMRI_data/LHON10-RK-IDBN-2016-5-22/t1.nii.gz';

outFileName  ='/media/HDPC-UT/dMRI_data/LHON10-RK-IDBN-2016-5-22/t1_average.nii.gz';

alignLandmarks = [     95     135     149;   95     106     141;98     103     208];

[outImg] = mrAnatAverageAcpcNifti(fileNameList, outFileName, alignLandmarks, [1 1 1],1);