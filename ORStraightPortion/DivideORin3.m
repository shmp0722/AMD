function [MeyersLoop ,fgA, fgM, fgP] = DivideORin3(fg)

%
%
%
% Example
%
% fg = fgRead(FG);  
% [MeyersLoop ,fgA, fgM, fgP] = DivideORin3(fg)
%
%

%% Argument checking
if isempty(fg.fibers) || isempty(fg.fibers)
    fprintf('Fiber group is empty\n');
    return
end

%% caliculate fuber curvetures

FC = dtiComputeFiberCurvature(fg);

%% identify the anterial hone in Meyers Loop

fg2 = dtiNewFiberGroup;
MeyersLoop = dtiNewFiberGroup;
MeyersLoop.name = 'MeyersLoop';

for kk = 1:length(fg.fibers)
    hFCpoint = find(FC{kk} ==max(FC{kk}(10:30))); % based on location of loop
    fg2.fibers{kk} = fg.fibers{kk}(:,hFCpoint+1:end);
    
    MeyersLoop.fibers{kk} = fg.fibers{kk}(:,1:hFCpoint);
end

%% lets divide the resuidal OR in three
fgA = dtiNewFiberGroup;
fgM = dtiNewFiberGroup;
fgP = dtiNewFiberGroup;

for kk = 1:length(fg2.fibers)
    PartsLength = round((length(fg2.fibers{kk}))/3); % based on location of loop
    
    fgA.fibers{kk} = fg2.fibers{kk}(:,1:PartsLength);
    fgM.fibers{kk} = fg2.fibers{kk}(:,PartsLength+1:PartsLength*2);
    fgP.fibers{kk} = fg2.fibers{kk}(:,PartsLength*2+1:end);    
end

%%


fgA.name = 'Anterior';
fgM.name = 'Middle';
fgP.name = 'Posterior';

return

%%
AFQ_RenderFibers(fgA,'tubes', 0);
AFQ_RenderFibers(fgM,'tubes', 0);
AFQ_RenderFibers(fgP,'tubes', 0);


fgWrite(fgA,'fgA','mat')
fgWrite(fgM,'fgM','mat')
fgWrite(fgP,'fgP','mat')


