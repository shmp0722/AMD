function Run_ShFiles

cmds = dir('*.sh');

parfor ii = 1:length(cmds)
    
    cmd = sprintf('./%s',cmds(ii).name);
    system(cmd)
end