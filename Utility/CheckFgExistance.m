function [OR_NotYet, OT_NotYet,NotYet,List] = CheckFgExistance


%%
[homeDir , List] = SubJect;
NotYet = zeros(2,length(List));

%
ORdir = '/dwi_1st/fibers/conTrack/OR_100K';
OTdir = '/dwi_1st/fibers/conTrack/OT_5K';

% run CutV1Roi
for ii =  1:length(List)
    
    OR_Dir = fullfile(homeDir,List{ii},ORdir,'*.pdb');
    OT_Dir = fullfile(homeDir,List{ii},OTdir,'*.pdb');
    
    OR_FG = dir(OR_Dir);
    OT_FG = dir(OT_Dir);
    
    NotYet(1,ii) = length(OR_FG);
    NotYet(2,ii) = length(OT_FG);
    
end

%% find out who does not have fiber.pdb
OR_NotYet = find(~NotYet(1,:));
OT_NotYet = find(~NotYet(2,:));
return
%%
