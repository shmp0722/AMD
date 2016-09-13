function ACH_CleanUpTract_OT5K_2(subID)
% To get the Optic Tract is able to analyse.

%%
[homeDir ,subDir, AMD, AMD_Ctl, RP, Ctl] = SubJect;

if notDefined('subID'),
    subID = 1:length(subDir);
end


%% dtiIntersectFibers
% exclude fibers using waypoint ROI
for ii = subID
    % INPUTS
    SubDir=fullfile(homeDir,subDir{ii});
    fgDir = (fullfile(SubDir,'/dwi_1st/fibers/conTrack/OT_5K'));
    roiDir = fullfile(SubDir,'ROIs');
    
    % load fg
    fgf = {'*fg_OT_5K_*Lt*.pdb', '*fg_OT_5K_*Rt*.pdb'};
    % way point ROI. Oposit side WM
    roif= {'41_Right-Cerebral-White-Matter','2_Left-Cerebral-White-Matter'};
    
    for j = 1:2
        % load roi
        roi = dtiReadRoi(fullfile(roiDir,roif{j}));
        % load fg
        fgF = dir(fullfile(fgDir,fgf{j}));
        if length(fgF)==1,
            fg = fgRead(fullfile(fgDir,fgF.name));
        else
            fg = fgRead(fullfile(fgDir,fgF(end).name));
        end
        
        % remove fibers using waypoit ROI 
        [fgOut,~,keep,~] = dtiIntersectFibersWithRoi([],'not',[],roi,fg);
        
        % keep pathwayInfo and Params.stat for contrack scoring
        keep = ~keep;
        for l = 1:length(fgOut.params)
            fgOut.params{1,l}.stat=fgOut.params{1,l}.stat(keep);
        end
        fgOut.pathwayInfo = fgOut.pathwayInfo(keep);
        
        % save the fiber tract
        fgOutname = sprintf('%s.pdb',fgOut.name);
        mtrExportFibers(fgOut, fullfile(fgDir,fgOutname),[],[],[],2)      
        fgWrite(fgOut,fullfile(fgDir,[fgOut.name,'.mat']),'mat')

        
        % Pick .txt and .pdb filename
        dTxtF = {'*ctrSampler_OT_5K*Lt-LGN4*.txt'
            '*ctrSampler_OT_5K_*Rt-LGN4*.txt'};
        dTxt = dir(fullfile(fgDir,  dTxtF{j}));
        dTxt = fullfile(fgDir,dTxt(1).name);
        dPdb = fullfile(fgDir,fgOutname);
        
        % give a filename to the output fiber group
        nFiber=100;
        outputfibername = fullfile(fgDir, sprintf('%s_Ctrk%d.pdb',fgOut.name,nFiber));
        
        % score the fibers to particular number
        ContCommand = sprintf('contrack_score.glxa64 -i %s -p %s --thresh %d --sort %s', ...
            dTxt, outputfibername, nFiber, dPdb);
        %         contrack_score.glxa64 -i ctrSampler.txt -p scoredFgOut_top5000.pdb --thresh 5000 --sort fgIn.pdb
        % run contrack
        system(ContCommand);
        %     end
        % end
        clear fg;
        
        %% AFQ_removeoutlier       
        fgfiles = {...
            '*fg_OT_5K*Lt*_Ctrk100.pdb'
            '*fg_OT_5K*Rt*_Ctrk100.pdb'};
        fgF = dir(fullfile(fgDir,fgfiles{j}));
        fg  = fgRead(fullfile(fgDir,fgF.name));
        
        if ~isempty(fg.fibers)
            % remove outlier
            [fgclean, ~] = AFQ_removeFiberOutliers(fg,2,2,25,'mean',1, 5,[]);   
            fgclean = SO_AlignFiberDirection(fgclean,'AP');
            
            P = {'LOT', 'ROT'};
            fgclean.name = sprintf('%s_MD22_%d',P{j},length(fgclean.fibers));
                        
            % save final fg
            NewfgDir = (fullfile(SubDir,'/dwi_1st/fibers/OT_MD22'));
            if ~exist(NewfgDir,'dir');mkdir(NewfgDir);end
 
            fgWrite(fgclean,fullfile(NewfgDir,[fgclean.name,'.mat']),'mat')
        end
        clear fg fgclean;
    end
end
