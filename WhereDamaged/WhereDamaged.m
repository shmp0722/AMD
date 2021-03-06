function WhereDamaged

% Basic Ideda
%
%
%
%

%%  difine and read ORs

[homeDir, List] = SubJect;

%%
% for ii = (1:20)
ii = 1;

Full_fbDir =fullfile(homeDir, List{ii}, '/dwi_1st/fibers/conTrack/OR_100K');

L_FullfbName = dir(fullfile(Full_fbDir, '*Lt-LGN4_lh_V1_smooth3mm_Half*Rh_NOT_MD4.pdb'));
R_FullfgName = dir(fullfile(Full_fbDir,'*Rt-LGN4_rh_V1_smooth3mm_Half*Lh_NOT_MD4.pdb'));

F_fgL = fgRead(fullfile(Full_fbDir,L_FullfbName.name));
F_fgR = fgRead(fullfile(Full_fbDir,R_FullfgName.name));

DivfbDir = fullfile(homeDir,List{ii},'dwi_1st/fibers/conTrack/OR_divided');
L_PerifbName = dir(fullfile(DivfbDir,'*Lt-LGN4_lh_Ecc30to90*Rh_NOT_MD4.pdb'));
L_midfgName  = dir(fullfile(DivfbDir,'*Lt-LGN4_lh_Ecc15to30*Rh_NOT_MD3.pdb'));
L_CorefbName = dir(fullfile(DivfbDir,'*Lt-LGN4_lh_Ecc0to3*Rh_NOT_MD4.pdb'));

R_PerifbName = dir(fullfile(DivfbDir,'*Rt-LGN4_rh_Ecc30to90*Lh_NOT_MD4.pdb'));
R_midfgName  = dir(fullfile(DivfbDir,'*Rt-LGN4_rh_Ecc15to30*Lh_NOT_MD3.pdb'));
R_CorefbName = dir(fullfile(DivfbDir,'*Rt-LGN4_rh_Ecc0to3*Lh_NOT_MD4.pdb'));

L_FgFull     = fgRead(fullfile(Full_fbDir,L_FullfbName.name));
L_FgDiv3090  = fgRead(fullfile(DivfbDir,L_PerifbName.name));
L_FgDiv03    = fgRead(fullfile(DivfbDir,L_CorefbName.name));
L_FgMid      = fgRead(fullfile(DivfbDir,L_midfgName.name));

R_FgFull = fgRead(fullfile(Full_fbDir,R_FullfgName.name));
R_FgDiv3090  = fgRead(fullfile(DivfbDir,R_PerifbName.name));
R_FgDiv03  = fgRead(fullfile(DivfbDir,R_CorefbName.name));
R_FgMid      = fgRead(fullfile(DivfbDir,R_midfgName(1).name));


%
dt = dtiLoadDt6( fullfile(homeDir, List{ii}, '/dwi_1st/dt6.mat'));
fg= {L_FgDiv03,R_FgDiv03,L_FgDiv3090,R_FgDiv3090,L_FgMid,R_FgMid};

%%
figure; hold on;
for jj = 1:2
    vals = dtiGetValFromFibers(dt.dt6,fg{jj},inv(dt.xformToAcpc),'fa');
    
    %% nodes found significant difference
    
    % see Merged_AMD_plot_ttest
    switch jj
        case {1,2}
            node_sdif = [24:37]*2;
        case {3,4}
            node_sdif = [12,13]*2;
    end
    for KK = 1:length(vals)
        box = size(vals{KK});
        
        r_node = box(1);
        node_affected = floor([r_node/100*node_sdif(1), r_node/100*node_sdif(end)]);
        
        vals{KK} =zeros(box);
        vals{KK}(node_affected(1):node_affected(2))=0.3;
    end
    
    rgb = vals2colormap(vals);
    AFQ_RenderFibers(fg{jj},'color',rgb,'numfibers',100,'newfig',0);
    
       
end
axis auto
axis off
camlight left

title 'Damaged Central OR'
%%
figure; hold on;
for jj = 3:4
    vals = dtiGetValFromFibers(dt.dt6,fg{jj},inv(dt.xformToAcpc),'fa');
    
    %% nodes found significant difference
    
    % see Merged_AMD_plot_ttest
    switch jj
        case {1,2}
            node_sdif = [24:37]*2;
        case {3,4}
            node_sdif = [12,13]*2;
    end
    for KK = 1:length(vals)
        box = size(vals{KK});
        
        r_node = box(1);
        node_affected = floor([r_node/100*node_sdif(1), r_node/100*node_sdif(end)]);
        
        vals{KK} =zeros(box);
        vals{KK}(node_affected(1):node_affected(2))=0.3;
    end
    
    rgb = vals2colormap(vals);
    AFQ_RenderFibers(fg{jj},'color',rgb,'numfibers',100,'newfig',0);
    
       
end
axis auto
axis off
camlight left

title 'Damaged Peripheral OR'
%%
t1 = niftiRead(dt.files.t1);

AFQ_AddImageTo3dPlot(t1,[0,0,-25])
AFQ_AddImageTo3dPlot(t1,[-3,0,0])

%%
figure; hold on;
for jj = 5:6
    vals = dtiGetValFromFibers(dt.dt6,fg{jj},inv(dt.xformToAcpc),'fa');
    
    %% nodes found significant difference
    
    % see Merged_AMD_plot_ttest
    switch jj
        case {1,2}
            node_sdif = [24:37]*2;
        case {3,4}
            node_sdif = [12,13]*2;
        case {5,6}   
            node_sdif = [30,34]*2;         
    end
    for KK = 1:length(vals)
        box = size(vals{KK});
        
        r_node = box(1);
        node_affected = floor([r_node/100*node_sdif(1), r_node/100*node_sdif(end)]);
        
        vals{KK} =zeros(box);
        vals{KK}(node_affected(1):node_affected(2))=0.3;
    end
    
    rgb = vals2colormap(vals);
    AFQ_RenderFibers(fg{jj},'color',rgb,'numfibers',100,'newfig',0);
    
       
end
axis auto
axis off
camlight left

title 'Damaged Mid OR'