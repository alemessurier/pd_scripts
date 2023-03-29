function [F_calls_2sec,F_calls_5sec,F_calls_10sec,F_byToneRep_3sec,F_byToneRep_5sec,ops,inds_ex,Fcell]=load2p_data_pupcalls_multiISI(path_2p)
%% 20200824 loads in data processed by suite2p (Fall.mat), chunks fluorescence traces by file

load([path_2p,'Fall.mat'],'F','Fneu','ops','iscell');
filelist=char2cell(ops.filelist,[],1);
fnames=cellfun(@(x)x((strfind(x,filesep)+1):end),filelist,'un',0);
framesPerFile=ops.frames_per_file;
cell_IDX=iscell(:,1)==1;
xoff=ops.xoff;
yoff=ops.yoff;

Fcell=F(cell_IDX,:);
Fcell_neu=Fneu(cell_IDX,:);
F_np_corr=Fcell-0.7.*Fcell_neu;

%% look through all cells

%first check if this step has been done
cd(path_2p)
tmp=dir('F_byFile.mat');
if isempty(tmp)
    inds_ex=[];
    [inds_ex]=check_rawROIs_suite2p( Fcell,Fneu,F_np_corr );
    
else
    load([path_2p,'F_byFile.mat'],'inds_ex');
end
F_include=Fcell(~inds_ex,:);
Fneu_include=Fcell_neu(~inds_ex,:);



%% break fluorescence time series and registration shifts into files
F_byFile=struct();
for f=1:length(fnames)
    frame_start=sum(framesPerFile(1:(f-1)))+1;
    frame_end=frame_start+framesPerFile(f)-1;
    
    F_byFile(f).FROI=F_include(:,frame_start:frame_end);
    F_byFile(f).Fneu=Fneu_include(:,frame_start:frame_end);
    F_byFile(f).name=fnames{f}(1:(strfind(fnames{f},'.tif')-1));
    F_byFile(f).xoff=xoff(frame_start:frame_end);
    F_byFile(f).yoff=yoff(frame_start:frame_end);
end

% remove files that are the wrong length - commented out 20220727
% lengths=arrayfun(@(x)size(x.FROI,2),F_byFile);
% exc=lengths<1000;
% F_byFile=F_byFile(~exc);
% fnames=fnames(~exc);

% index by call sets
idx_calls1=cellfun(@(x)contains(x,'61f','IgnoreCase',true),fnames);
idx_calls2=cellfun(@(x)contains(x,'j5b'),fnames);
idx_calls3=cellfun(@(x)contains(x,'jan1','IgnoreCase',true),fnames);
idx_tones=cellfun(@(x)contains(x,'halfOct','IgnoreCase',true) || contains(x,'tones','IgnoreCase',true),fnames);
fnames_tones=fnames(idx_tones);

%index by ISI
idx_2sec=cellfun(@(x)contains(x,'2sec','IgnoreCase',true),fnames);
idx_3sec=cellfun(@(x)contains(x,'3sec','IgnoreCase',true),fnames);
idx_5sec=cellfun(@(x)contains(x,'5sec','IgnoreCase',true),fnames);
idx_10sec=cellfun(@(x)contains(x,'10sec','IgnoreCase',true),fnames);

if sum(idx_calls1)>0
    F_calls_2sec{1}=F_byFile(idx_calls1 & idx_2sec);
    F_calls_5sec{1}=F_byFile(idx_calls1 & idx_5sec);
    F_calls_10sec{1}=F_byFile(idx_calls1 & idx_10sec);
else
    F_calls={};
end
if sum(idx_calls2)>0
    
    F_calls_2sec{2}=F_byFile(idx_calls2 & idx_2sec);
    F_calls_5sec{2}=F_byFile(idx_calls2 & idx_5sec);
    F_calls_10sec{2}=F_byFile(idx_calls2 & idx_10sec);
else
end
if sum(idx_calls3)>0
    F_calls{3}=F_byFile(idx_calls3);
else
end


F_byToneRep_3sec=F_byFile(idx_tones' & idx_3sec');
F_byToneRep_5sec=F_byFile(idx_tones' & idx_5sec');

save([path_2p,'F_byFile.mat'],'F_calls_2sec','F_calls_5sec','F_calls_10sec','F_byToneRep_3sec','F_byToneRep_5sec','ops','inds_ex');
% frames_disc=framesPerFile(idx_disc);end
