function DownSizeNii(ni,Max)

% Purpose; is function name
%
% Example
% %% 
% cd /media/HDPC-UT/dMRI_data/JMD-Ctl-SY-20130222DWI/17100000
% 
% files = dir(pwd)
% 
% for ii = 3: length(files)
% 
% [Di,map] = dicomread(files(ii).name);
% M(ii) =  max(Di(:));
% end
% 
% figure;
% montage(Di, map)%, 'Size', [2 5]);
% 
% 
% % Now we already know the highest number in DICOM was 1000
% max(M);
% 
% %% So Downgrade nii 
% cd /media/HDPC-UT/dMRI_data/JMD-Ctl-SY-20130222DWI
% gunzip('t1.nii.gz')
% ni = niftiRead('/media/HDPC-UT/dMRI_data/JMD-Ctl-SY-20130222DWI/t1.nii');
% Bunbo = max(ni.data(:));
% 
% %
% Bunshi =ni.data;
% OneTo1000 = round(Bunshi/Bunbo*1000);
% OneTo3000 = round(Bunshi/Bunbo*3000);
% OneTo5000 = round(Bunshi/Bunbo*5000);
% % showMontage(OneTo5000)
% 
% % get bach the data to New T1
%  NewT1 = ni;
%  
%  NewT1.data = OneTo1000;
%  niftiWrite(NewT1,'New1to1000T1.nii')
%  
%  NewT1.data = OneTo3000;
%  niftiWrite(NewT1,'New1to3000T1.nii')
%  
%  NewT1.data = OneTo5000;
%  niftiWrite(NewT1,'New1to5000T1.nii')
%  

%%
if notDefined('ni')
    return
end

if ischar(ni)
    ni = niftiRead(ni);
end

% isequal(Bunbo, intmax('int16')) 
Bunbo = max(ni.data(:));

Bunshi =ni.data;
mydata = round(Bunshi/Bunbo*Max);

% showMontage(OneTo5000)

% get bach the data to New T1
 NewT1 = ni;
 
 NewT1.data = mydata;
 niftiWrite(NewT1,sprintf('NewT1_%s.nii',Max))
 
%% one other concept is using uint8
bit8 =  uint8(Bunshi);

% get bach the data to New T1
 NewT1 = ni; 
 NewT1.data = bit8;
 niftiWrite(NewT1,sprintf('NewT1_%s.nii','8bit'))

 
%% resample
refImg = niftiRead('/media/HDPC-UT/dMRI_data/JMD-Ctl-SY-20130222DWI/raw/dwi1st.nii.gz');
a =  size(refImg.data);
NewDimension = a(1:3)

