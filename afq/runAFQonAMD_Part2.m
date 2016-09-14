function runAFQonAMD_Part2
%
% run AFQ pipeline on AMD and AMD controls
%
% SO@ACH 2016/09/13


%% Load afq structure
load /home/ganka/git/AMD/afq/afq.mat

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

%%
outname = fullfile(AFQ_get(afq,'outdir'),['afq_' date]);
save(outname,'afq');

