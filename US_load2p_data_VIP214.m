function [F_byFile,DCs,MPa,ops]=US_load2p_data_VIP214(path_2p)
%% 20200824 loads in data processed by suite2p (Fall.mat), chunks fluorescence traces by file

load([path_2p,'Fall.mat'],'F','Fneu','ops','iscell');
% filelist=char2cell(ops.filelist,[],1);
% fnames=cellfun(@(x)x((strfind(x,'\')+1):end),filelist,'un',0);
% framesPerFile=ops.frames_per_file;
cell_IDX=iscell(:,1)==1;


filelist=char2cell(ops.filelist,[],1);
idx_fnames=1+(0:450:length(filelist));
idx_fnames=idx_fnames(1:end-1);
idx_fnames=[idx_fnames,36001:36080];
files450=filelist(idx_fnames);
frames450=repmat(450,length(files450),1);
idx_750=find(ops.frames_per_file==750);
files750=filelist(idx_750);
frames750=repmat(750,length(files750),1);

fnames=[files450; files750];
F_byFile=struct();
for f=1:length(files450)
    frame_start=sum(frames450(1:(f-1)))+1;
    frame_end=frame_start+frames450(f)-1;
  
    F_byFile(f).FROI=F(cell_IDX,frame_start:frame_end);
    F_byFile(f).Fneu=Fneu(cell_IDX,frame_start:frame_end);
    F_byFile(f).name=files450{f}(1:(strfind(files450{f},'.tif')-1));
end
frameIdx=72001:(72000+750*length(idx_750));
f_750=F(:,frameIdx);
fneu_750=Fneu(:,frameIdx);
F_byFile750=struct();
for f=1:length(files750)
    frame_start=sum(frames750(1:(f-1)))+1;
    frame_end=frame_start+frames750(f)-1;
  
    F_byFile750(f).FROI=f_750(cell_IDX,frame_start:frame_end);
    F_byFile750(f).Fneu=fneu_750(cell_IDX,frame_start:frame_end);
    F_byFile750(f).name=files750{f}(1:(strfind(files750{f},'.tif')-1));
end

% append files w/450 frames
idx_450=36092:36099;
files450=filelist(idx_450);
frameIdx=80251:(80250+450*length(idx_450));
frames450=repmat(450,length(files450),1);
f_450=F(:,frameIdx);
fneu_450=Fneu(:,frameIdx);
F_byFile450=struct();
for f=1:length(files450)
    frame_start=sum(frames450(1:(f-1)))+1;
    frame_end=frame_start+frames450(f)-1;
  
    F_byFile450(f).FROI=f_450(cell_IDX,frame_start:frame_end);
    F_byFile450(f).Fneu=fneu_450(cell_IDX,frame_start:frame_end);
    F_byFile450(f).name=files450{f}(1:(strfind(files450{f},'.tif')-1));
end




F_byFile=[F_byFile,F_byFile750,F_byFile450];
fnames=[fnames;files450];

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
    