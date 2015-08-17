function VistaSoftVer(Ver)

%
% Changing vistasoft branch to avoid GUI errors.
%
% SO @ACH 2015
%

% argument check
if notDefined('Ver'),
    Ver = '';
end

%switch vistasoft branch based on matlab ver
Ver = lower(Ver);
cd('/home/ganka/git/vistasoft')

switch Ver
    case {'2015','r2015a','r2015'}
      
        cmd = sprintf('!git checkout R2015a');

    case {'','2013'}
        
        cmd = sprintf('!git checkout master');
end
 
% run a cmd on command line
eval(cmd)