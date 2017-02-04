function runAFQonAMD_Part2
%
% run AFQ pipeline on AMD and AMD controls
%
% SO@ACH 2016/09/13


%% Load afq structure
% load '/home/ganka/git/AMD/afq/afq_13-Sep-2016.mat';
Git
cd AMD/afq
load 'afq_29-Jan-2017.mat';
 
%% Add new fibers

fgName = 'LOT_MD32';
roi1Name = '85_Optic-Chiasm';
roi2Name = 'Lt-LGN4';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

fgName = 'ROT_MD32';
roi1Name = '85_Optic-Chiasm';
roi2Name = 'Rt-LGN4';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

%% Add optic radiation
fgName = 'LOR_MD4';
roi1Name = 'Lt-LGN4';
roi2Name = 'lh_V1_smooth3mm_Half';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

fgName = 'ROR_MD4';
roi1Name = 'Rt-LGN4';
roi2Name = 'rh_V1_smooth3mm_Half';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

fgName = 'LORC_MD4';
roi1Name = 'Lt-LGN4';
roi2Name = 'lh_Ecc0to3';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

fgName = 'RORC_MD4';
roi1Name = 'Rt-LGN4';
roi2Name = 'rh_Ecc0to3';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

fgName = 'LORP_MD4';
roi1Name = 'Lt-LGN4';
roi2Name = 'lh_Ecc30to90';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

fgName = 'RORP_MD4';
roi1Name = 'Rt-LGN4';
roi2Name = 'rh_Ecc30to90';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

%%

fgName = 'LORMP_MD3';
roi1Name = 'Lt-LGN4';
roi2Name = 'lh_Ecc15to30';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);

fgName = 'RORMP_MD3';
roi1Name = 'Rt-LGN4';
roi2Name = 'rh_Ecc15to30';
cleanFibers =0;
computeVals =1;
afq.params.clip2rois = 0;
afq = AFQ_AddNewFiberGroup(afq, fgName, roi1Name, roi2Name, cleanFibers);


%%
outname = fullfile(AFQ_get(afq,'outdir'),['afq_' date]);
save(outname,'afq');

