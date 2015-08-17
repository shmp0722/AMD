function CheckROI


%%
[homeDir , List] = SubJect;

NotYet = zeros(2,length( List));
NotYet2 = NotYet;
NotYet3 = NotYet;


LGN = {'Lt-LGN4.mat','Rt-LGN4.mat'};
% run CutV1Roi
for ii =  1:length(List)
    ROIdir = fullfile(homeDir ,List{ii},'ROIs');
    ROIdir2 = fullfile(homeDir ,List{ii},'/dwi_2nd/ROIs');
    ROIdir3 = fullfile(homeDir ,List{ii},'/dwi_1st/ROIs');


    if exist(fullfile(ROIdir,LGN{1}))
        NotYet(1,ii) = 1;   
        cmd = sprintf('!cp %s/Lt-LGN4.mat %s/%s',ROIdir, ROIdir2,LGN{1});
        eval(cmd)
        cmd = sprintf('!cp %s/Lt-LGN4.mat %s/%s',ROIdir, ROIdir3,LGN{1});
        eval(cmd)
    elseif exist(fullfile(ROIdir,LGN{2}))
        NotYet(2,ii) = 1;
        cmd = sprintf('!cp %s/Lt-LGN4.mat %s/%s',ROIdir, ROIdir2,LGN{2});
        eval(cmd)
        cmd = sprintf('!cp %s/Lt-LGN4.mat %s/%s',ROIdir, ROIdir3,LGN{2});
        eval(cmd)
    end;
    
    if exist(fullfile(ROIdir2,LGN{1}))
        NotYet2(1,ii) = 1;
        cmd = sprintf('!cp %s/Lt-LGN4.mat %s/%s',ROIdir2, ROIdir,LGN{1});
        eval(cmd)
    elseif exist(fullfile(ROIdir2,LGN{2}))
        NotYet2(2,ii) = 1;
        cmd = sprintf('!cp %s/Lt-LGN4.mat %s/%s',ROIdir2, ROIdir,LGN{2});
        eval(cmd)
    end;
    
    if exist(fullfile(ROIdir3,LGN{1}))
        NotYet3(1,ii) = 1;
        cmd = sprintf('!cp %s/Lt-LGN4.mat %s/%s',ROIdir3, ROIdir,LGN{1});
        eval(cmd)
    elseif exist(fullfile(ROIdir3,LGN{2}))
        NotYet3(2,ii) = 1;
        cmd = sprintf('!cp %s/Lt-LGN4.mat %s/%s',ROIdir3, ROIdir,LGN{2});
        eval(cmd)
    end;
    
end

return
%%

[homeDir , List] = SubJect;

NotYet = zeros(2,length( List));
NotYet2 = NotYet;
NotYet3 = NotYet;

LGN = {'lh_V1_smooth3mm_Half.mat','rh_V1_smooth3mm_Half.mat'};


if exist(fullfile(ROIdir,LGN{1}))
        NotYet(1,ii) = 1;   
        cmd = sprintf('!cp %s/Lt-LGN4.mat %s/%s',ROIdir, ROIdir2,LGN{1});
        eval(cmd)
        cmd = sprintf('!cp %s/Lt-LGN4.mat %s/%s',ROIdir, ROIdir3,LGN{1});
        eval(cmd)
    elseif exist(fullfile(ROIdir,LGN{2}))
        NotYet(2,ii) = 1;
        cmd = sprintf('!cp %s/Lt-LGN4.mat %s/%s',ROIdir, ROIdir2,LGN{2});
        eval(cmd)
        cmd = sprintf('!cp %s/Lt-LGN4.mat %s/%s',ROIdir, ROIdir3,LGN{2});
        eval(cmd)
    end;
