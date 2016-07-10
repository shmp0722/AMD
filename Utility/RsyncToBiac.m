function RsyncToBiac

% this function is moving files from a directory on Biac to ACH. If there
% is same name directory.

%%

[p,f,e] = fileparts(pwd);



Sourse = fullfile(p,f);
[~,Path]   = fileparts(p);

%%
cmd = sprintf('rsync -ave ssh /biac4/wandell/biac2/wandell/data/DWI-Tamagawa-Japan/ atsugi:/media/HDPC-UT/dMRI_data/%s',Sourse,f);

%% 
system(cmd)


