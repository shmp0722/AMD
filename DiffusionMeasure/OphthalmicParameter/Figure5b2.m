function Figure5b2
%
% Make Figure6b
%  
%

% SO@ACH 2016.9.30

%% Make sure you are under OphthalmicParameter

load R
fgCore = fgRead('LORC_MD4_SuperFiber.mat');

%%
figure; hold on;
    AFQ_RenderTractProfile(fgCore.fibers{1},5,R.OR03,30,[],[0.3 1]);

   axis off
   title('r value along with OR 0-3degree')
   axis equal 
    
%% Highest

M03 =  max(R.OR03);
find(R.OR03 ==M03)
size(R.OR03)

M15 =  max(R.OR15);
find(R.OR15 ==M15)
size(R.OR15)






%%
   saveas(gca,'Figure6b.eps','epsc')
   saveas(gca,'Figure6b.png')
 