function ACH_CleanUpTract_ORdivided(subject)

%% MergeROis_NOTROI.m
% merge ROIs to create Big NOT ROI.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ctl HT does not have cerebellum segmentation file!
% If you want to creat ROI which include cerebelum,
% You should exclude HT, and create HT's ROI by hand.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set directory
[homeDir ,subDir] = SubJect;

if notDefined('subject');
    [~, subject] = fileparts(pwd);
end;

%% remove fibers from raw conTrack fibers
% for ii = subject
SubDir = fullfile(homeDir,subject);
fgDir  = fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_divided');
% fgDir  = fullfile(SubDir,'/dwi_2nd/fibers/conTrack/OR_divided');
roiDir = fullfile(SubDir,'/ROIs');

% ROI file names you want to merge
for hemisphere = 1:2
    
    fgF = {'*Rt-LGN*.pdb'
        '*Lt-LGN4*.pdb'};
    
    % load fg and ROI
    fgs  = dir(fullfile(fgDir,fgF{hemisphere}));
    for jj = 1:length(fgs)
        fg  = fgRead(fullfile(fgDir,fgs(jj).name));
        
        % Load a waypoint ROI
        ROIname = {'Lh_NOT.mat','Rh_NOT.mat'};
        ROIf = fullfile(roiDir, ROIname{hemisphere});
        ROI = dtiReadRoi(ROIf);
        
        % Remove fibers going through a waypoint ROI
        [fgOut1,~, keep1, ~] = dtiIntersectFibersWithRoi([], 'not', [], ROI, fg);
        keep = ~keep1;
        for l =1:length(fgOut1.params)
            fgOut1.params{1,l}.stat=fgOut1.params{1,l}.stat(keep);
        end
        fgOut1.pathwayInfo = fgOut1.pathwayInfo(keep);
        
        % correct fiber direction anterior to posteror
        [fgOut1] = SO_AlignFiberDirection(fgOut1,'AP');
        
        % remove outlier fiber
         % max distance
        for k=2:4
            maxDist = k;
            maxLen = 4;
            numNodes = 25;
            M = 'mean';
            count = 1;
            show = 1;
            
            [fgclean ,keep] =  AFQ_removeFiberOutliers(fgOut1,maxDist,maxLen,numNodes,M,count,show);
            
            for l =1:length(fgclean.params)
                fgclean.params{1,l}.stat=fgclean.params{1,l}.stat(keep);
            end
            fgclean.pathwayInfo = fgclean.pathwayInfo(keep);
            
            % save new fg.pdb file
            fibername       = sprintf('%s_MD%d.pdb',fgclean.name,maxDist);
            mtrExportFibers(fgclean,fullfile(fgDir,fibername),[],[],[],2);
            clear fgclean
        end
    end
end

delete *NOT*NOT*;
return


%% Rended fibers

SubDir = fullfile(homeDir,subject);
fgDir  = fullfile(SubDir,'/dwi_1st/fibers/conTrack/OR_divided');
dt6    = dtiLoadDt6(fullfile(SubDir,'/dwi_1st/dt6.mat'));
FG = dir(fullfile(fgDir,'*_MD4.pdb'));


figure; hold on;

% load 
c = jet(6);
for kk = 1:length(FG)
    fg{kk}= fgRead(fullfile(fgDir,FG(kk).name));
%     AFQ_RenderFibers(fg{kk},'dt',dt6,'numfibers',100,'newfig',0,'color',c(kk,:))
    AFQ_RenderFibers(fg{kk},'numfibers',100,'newfig',0,'color',c(kk,:))

end

