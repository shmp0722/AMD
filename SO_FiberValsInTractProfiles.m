function TractProfile = SO_FiberValsInTractProfiles(fg,dt,fiberDirection,Nnodes,weight)
%
% [TractProfile] = SO_FiberValsInTractProfiles(fg,dt,fiberDirection,Nnodes,weight)
%
% Calculate diffusion properties along the tract and keep the result in
% Tractprofile structure
%
% Example
% fg = fgRead('fg');
% dt = dtiLoadDt6('dt6.mat');
% fiberDirection = 'AP','LR'or 'SI';
% Nnodes =100;% default
% weight = 1;
%
% [TractProfile] = SO_FiberValsInTractProfiles(fg,dt,fiberDirection,Nnodes,weight) 
%
% SO @Vista lab 2014

%% argument check
if ~exist('Nnodes','var'); Nnodes = 100; end;
if ~exist('weight','var') || isempty(weight);
    weight = 1;end
if ~exist('fiberDirection','var') || isempty(fiberDirection);
    fiberDirection = 'AP';end
%%
if ~exist('fg','var') || isempty(fg.fibers);
    sprintf('fg is empty. Please make sure the fg eixst and fg has fg.fibers')
    TractProfile = AFQ_CreateTractProfile;
else
    %% Align fiber direction
    fg = SO_AlignFiberDirection(fg,fiberDirection);
    
    %% Create Tract Profile structure
    % Pre allocate data arrays
    fa=nan(Nnodes,1);
    md=nan(Nnodes,1);
    rd=nan(Nnodes,1);
    ad=nan(Nnodes,1);
    cl=nan(Nnodes,1);
    cs=nan(Nnodes,1);
    cp=nan(Nnodes,1);
    volume=nan(Nnodes,1);
    
    %% get diffusion properties
    [fa,md,rd,ad,cl,...
        SuperFibersGroup,~,cp,cs,fgResampled]=...
        dtiComputeDiffusionPropertiesAlongFG(fg, dt, [], [], Nnodes, weight);
    % Compute tract volume at each node
    volume = AFQ_TractProfileVolume(fgResampled);
    % Put mean fiber into Tract Profile structure
    TractProfile = SO_CreateTractProfile('name',fg.name,'superfiber',SuperFibersGroup);
    % Add the volume measurement
    TractProfile.fiberVolume = volume';
    % Add the length measurement
    Length=cellfun('length',fg.fibers);
    TractProfile.figberLength = Length';
    
    % Add planarity and sphericity measures to the tract profile. We
    % could return them as outputs from the main function but the list
    % of outputs keeps growing...
    TractProfile = AFQ_TractProfileSet(TractProfile,'vals','fa',fa');
    TractProfile = AFQ_TractProfileSet(TractProfile,'vals','md',md');
    TractProfile = AFQ_TractProfileSet(TractProfile,'vals','ad',ad');
    TractProfile = AFQ_TractProfileSet(TractProfile,'vals','rd',rd');
    TractProfile = AFQ_TractProfileSet(TractProfile,'vals','cl',cl');
    TractProfile = AFQ_TractProfileSet(TractProfile,'vals','planarity',cp');
    TractProfile = AFQ_TractProfileSet(TractProfile,'vals','sphericity',cs');
end
return
