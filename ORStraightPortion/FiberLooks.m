function FiberLooks(fg)
%
% 
% FC = dtiComputeFiberCurvature(fg);
%
% Example
% FG = '.mat' or '.pdb';
% fg = fgRead(FG)
% FiberLooks(fg)
%
% 


%%
%  fg = dtiNewFiberGroup([name='FG-1'], [color=[20 90 200]], ...
%                [thickness=-0.5], [visibleFlag=1], [fibers=[]])

% Load an OR  

FgPath = fullfile('/media/HDPC-UT/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/dwi_1st/fibers/conTrack/OR_100K',...
    'fg_OR_100K_Rt-LGN4_rh_V1_smooth3mm_Half_2015-06-24_19.34.09-Lh_NOT_MD4.pdb');

fg = fgRead(FgPath);

%% Create New fg and choose 100 fibers from fg

fg2 = dtiNewFiberGroup;

for ii = 1:100;
    fg2.fibers{ii} = fg.fibers{ii};
end

fg2.fibers = fg2.fibers';

% clear fg;
%% caliculate fuber curvetures

FC = dtiComputeFiberCurvature(fg2);

%%
figure; hold('on');

% default settings
color = [0.7 0.7 0.7]; %default color for fiber group is gray
js = .2; %default amount of jitter in the coloring
jf = 0; %default amount of jitter in the coloring

% Render each fiber as a line 
for ii = 1:length(fg2.fibers)
    figure; hold('on');

        % X, Y and Z coordinates for the fiber
        x = fg2.fibers{ii}(1,:)';
        y = fg2.fibers{ii}(2,:)';
        z = fg2.fibers{ii}(3,:)';
        % Jitter color and shading
        C = color + [rand(1,3).*2 - 1].*jf+[rand(1).*2 - 1].*js;
        % Make sure that after adding the jitter the colors don't exceed the
        % range of 0 to 1
        C(C > 1) = 1;
        C(C < 0) = 0;
        % plot the fibers as lines
        plot3(x,y,z,'-','color',C);
        
        % Collect fiber coordinates to be returned
        if nargout > 1
            fiberMesh.X{ii} = x;
            fiberMesh.Y{ii} = y;
            fiberMesh.Z{ii} = z;
            fiberMesh.C{ii} = C;
        end
        axis equal
end



%% Check FC

for kk = 1:length(fg2.fibers)
    figure; hold on;
    plot(1:length(FC{kk}), FC{kk})
end
%% cut at highest curveture close to anterior hone
fg3 = dtiNewFiberGroup;

for kk = 1:length(fg2.fibers)    
hFCpoint = find(FC{kk} ==max(FC{kk}(10:30))); % based on location of loop
fg3.fibers{kk} = fg2.fibers{kk}(:,hFCpoint+1:end);
end

AFQ_RenderFibers(fg3,'tubes', 0)
roiPath = '/media/HDPC-UT/dMRI_data/AMD-01-dMRI-Anatomy-dMRI/ROIs/43_Right-Lateral-Ventricle.mat';
roi = dtiReadRoi(roiPath);

AFQ_RenderRoi(roi)
fgWrite(fg3,fg3.name,'mat')

%% lets divide the resuidal OR in three
fgA = dtiNewFiberGroup;
fgM = dtiNewFiberGroup;
fgP = dtiNewFiberGroup;

for kk = 1:length(fg3.fibers)    
PartsLength = round((length(fg3.fibers{kk}))/3); % based on location of loop

fgA.fibers{kk} = fg3.fibers{kk}(:,1:PartsLength);
fgM.fibers{kk} = fg3.fibers{kk}(:,PartsLength+1:PartsLength*2);
fgP.fibers{kk} = fg3.fibers{kk}(:,PartsLength*2+1:end);

end

%%
AFQ_RenderFibers(fgA,'tubes', 0)
AFQ_RenderFibers(fgM,'tubes', 0)
AFQ_RenderFibers(fgP,'tubes', 0)

fgA.name = 'Anterior';
fgM.name = 'Middle';
fgP.name = 'Posterior';


fgWrite(fgA,'fgA','mat')
fgWrite(fgM,'fgM','mat')
fgWrite(fgP,'fgP','mat')










