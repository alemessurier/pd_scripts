function [F_byFile,DCs,MPa,ops]=US_load2p_data_SST130(path_2p)
%% 20200824 loads in data processed by suite2p (Fall.mat), chunks fluorescence traces by file

load([path_2p,'Fall.mat'],'F','Fneu','ops','iscell');
filelist=char2cell(ops.filelist,[],1);
fnames=cellfun(@(x)x((strfind(x,'\')+1):end),filelist,'un',0);
load('E:\US\SST130\reduced\analysis_05-Mar-2020.mat','framesInAcq')

framesPerFile=framesInAcq
cell_IDX=iscell(:,1)==1;

F_byFile=struct();
for f=1:length(fnames)
    frame_start=sum(framesPerFile(1:(f-1)))+1;
    frame_end=frame_start+framesPerFile(f)-1;
  
    F_byFile(f).FROI=F(cell_IDX,frame_start:frame_end);
    F_byFile(f).Fneu=Fneu(cell_IDX,frame_start:frame_end);
    F_byFile(f).name=fnames{f}(1:(strfind(fnames{f},'.tif')-1));
end


% DCs=zeros(length(fnames),1);
% MPa=DCs;
% 
% for i=1:length(fnames)
%     fname=fnames{i};
%     DC=fname((strfind(fname,'DC')-2):(strfind(fname,'DC')-1));
%     DC(strfind(DC,'_'))='';
%     DCs(i)=str2double(DC);
%     
%     pr=fname((strfind(fname,'MPa')

DCs=cellfun(@(x)nominal(x((strfind(x,'DC')-2):(strfind(x,'DC')-1))),fnames,'un',1);
MPa=cellfun(@(x)nominal(x((strfind(x,'MPa')-2):(strfind(x,'MPa')-1))),fnames,'un',1);
% idx_disc=cellfun(@(x)contains(x,'isc') & contains(x,date),fnames);
% idx_tones=cellfun(@(x)contains(x,'tones') & contains(x,date),fnames);
% fnames_disc=fnames(idx_disc);
% fnames_tones=fnames(idx_tones);
% F_bySession=F_byFile(idx_disc);
% F_byToneRep=F_byFile(idx_tones);


% frames_disc=framesPerFile(idx_disc);
% frames_tones=framesPerFile(idx_tones);
end
    