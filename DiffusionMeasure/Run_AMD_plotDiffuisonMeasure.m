function Run_AMD_plotDiffuisonMeasure(ShowFlag)

%
% Well , lets get the diffusivity plots!
% THis work is about to finish. 
%
% SO @ACH 2015.9


%%
vals = {'fa','md','ad','rd'};
SavePath = '/media/HDPC-UT/dMRI_data/Results/AMD_plots';
fibID = 1:10;

for ii = fibID
    for kk = 1:4;       
        AMD_plotDiffuisonMeasure(vals{kk},ii,SavePath)
    end
end

% delete all figures, if you want to see these, ShowFlag should be '1'.
if or(isempty(ShowFlag),ShowFlag==0), close all;end


return
