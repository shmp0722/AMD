function Hiromasa_Noah_retinotopicTemplate_SingleSubj

%%
fsDir = getenv('SUBJECTS_DIR');

[~,subjid]=fileparts(pwd);

% for ii = 1:length(list)
%     subjid = list{ii};

%%
if ~exist(fullfile(fsDir,subjid,'xhemi'),'dir')
    % Invert the right hemisphere
    cmd = sprintf('!xhemireg --s %s',subjid);
    eval(cmd)
    
    % Register the left hemisphere to fsaverage_sym
    cmd = sprintf( '!surfreg --s %s --t fsaverage_sym --lh',subjid);
    eval(cmd)
    
    % Register the inverted right hemisphere to fsaverage_sym
    cmd = sprintf('!surfreg --s %s --t fsaverage_sym --lh --xhemi',subjid);
    eval(cmd)
end
%% Making V1, V2, V3 ecc and polar angle
if ~exist(fullfile(fsDir,subjid,'surf/lh.template*'),'file')
    cmd = sprintf('!sudo docker run -ti --rm -v %s:/input nben/occipital_atlas:latest', fullfile(fsDir,subjid));
    
    eval(cmd)
    % end
end
%% outputs is in '/subjid/surf/' and '/sujid/mri/'
% The volume files are labeled native because they are oriented
% in FreeSurfer's native LIA orientation (like the orig.mgz volume).
% Both the angle and eccentricity are measured in degrees
% (for both hemispheres polar angle is between 0 and 180 (0 is the upper vertical meridian)
% and eccentricity is between 0 and 90).
% The areas template specifies visual areas V1, V2, and V3 as the numbers 1, 2,
% and 3, respectively, and is 0 everywhere else.
% The angle and eccentricity templates are also 0 outside of V1, V2, and V3.

cmd = sprintf('!mri_convert -rl "$SUBJECTS_DIR/%s/mri/rawavg.mgz" "$SUBJECTS_DIR/%s/mri/native.template_angle.mgz" "$SUBJECTS_DIR/%s/mri/scanner.template_angle.mgz"',subjid,subjid,subjid);
eval(cmd)

% end
%%Warning: Some users have noticed that using FreeSurfer's mri_convert utility to transform the volumes results in blurring or noise in the results. We suspect that this is because the conversion routine performs a heuristic resampling rather than simply reslicing the volume in some cases. Be sure to check your 'scanner' volumes against the 'native' volumes for accuracy.

%% Hiromasa's contribution

roiname_array={'V1v','V1d','V2v','V2d','V3v','V3d','hV4','VO1', 'VO2', 'PHC1', 'PHC2' ,...
    'TO2' 'TO1' 'LO2' 'LO1' 'V3B' 'V3A' 'IPS0' 'IPS1' 'IPS2' 'IPS3' 'IPS4' ,...
    'IPS5' 'SPL1' 'FEF'};

for i = 1:length(roiname_array)
    cmd = sprintf('!mri_cor2label --i "${SUBJECTS_DIR}/%s/surf/lh.wang2015_atlas.mgz" --id %d --l lh.wang2015atlas.%s.label --surf %s lh inflated',subjid,i, roiname_array{i},subjid);
    eval(cmd)
end
return
