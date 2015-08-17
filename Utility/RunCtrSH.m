% RunCtrSH

SH  = dir('*.sh');


if ~isempty(SH)
    for ii = length(SH)
        cmd = sprintf('./%s',SH(ii).name);
        system(cmd)
    end
end
    
    
%     % Helper function: throw an error if the system call doesn't work as
% % expected:
%     function [status, result] = syscall(cmd_str)
%         % Allow for noops:
%         if strcmp(cmd_str, '')
%             return
%         end
%         fprintf('[%s]: Executing "%s" \n', mfilename, cmd_str);
%         [status, result] = system(cmd_str);
%         if status~=0
%             error(result);
%         end
%     end
% 
% 
%     