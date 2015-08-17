function Run_CutV1Roi
%
%

%% Dir and List
[homeDir , List] = SubJect;
%  NotYet = zeros(size( List));

% run CutV1Roi
for ii =  1:length(List)
    subID = List{ii};
    
    CutV1Roi(fullfile(homeDir,subID))
end
return