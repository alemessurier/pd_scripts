% load in raw fluorescence files
load('') %path to Fall.mat
%%
%only include ROIs classified as cells
idxCell=find(iscell(:,1));
Fcell=F(idxCell,:);
Fneu=Fneu(idxCell,:);
% subtract neuropil signal
F_np_corr=Fcell-0.7.*Fneu;

% look through all cells
% [inds_ex]=check_rawROIs_suite2p( Fcell,Fneu,F_np_corr );
% F_include=F_np_corr(~inds_ex,:);
F_include=F_np_corr;
% 
% filter data w/moving median filter
filtF=zeros(size(F_include));
for i=1:size(filtF,1)
    cellName=['cell',num2str(i)];
    [ filtTrace.(cellName) ] = slidingAvg_rawF( F_np_corr(i,:),5,'median' );
    filtF(i,:)=filtTrace.(cellName);
    rawF.(cellName)=F_np_corr(i,:);
    
end
% calculate dF/F from raw image traces
deltaF=deltaF_suite2p(filtF);

samp_rate=ops.fs;
spacing=.5;
numCells=50;
plot_deltaF( rawF,samp_rate,10,15,0.75 )
%%
plot_deltaF( deltaF,samp_rate,1,50,0.75 )

%% get number of frames in each movie

filepaths=ops.filelist;
framesInAcq=zeros(size(filepaths,1),1);
for K=1:size(filepaths,1)
    numframes=read_numFrames_tiff(filepaths(K,:));
    framesInAcq(K)=numframes;
end
framesInAcq=repmat(600,size(filepaths,1),1)
%% reshape deltaF/F for each cell into acquisitions

cellNames=fieldnames(deltaF);
% idx_300=zeros(length(deltaF.(cellNames{1})),1);
% idx_1200=idx_300;
% idx_600=idx_300;
% 
% acqs_300=find(framesInAcq==300);
% acqs_600=find(framesInAcq==600);
% acqs_1200=find(framesInAcq==1200);
% 
% idx_300(1:acqs_300(end)*300)=1;
% idx_600(acqs_300(end)*300:(acqs_300(end)*300+acqs_600(end)*600)

for cell=1:length(cellNames)
    dF=deltaF.(cellNames{cell});
    df_blocks=reshape(dF,framesInAcq(1),length(framesInAcq));
    df_byTrial.(cellNames{cell})=df_blocks;
    mean_dF.(cellNames{cell})=mean(df_blocks,2);
end
plot_deltaF( mean_dF,samp_rate,1,15,0.5 )
stimFrames=300;
vline(stimFrames)
z_means=cellfun(@(x)((mean_dF.(x)-mean(mean_dF.(x)))/std(mean_dF.(x)))',cellNames,'un',0);
z_means=cat(1,z_means{:});
raw_means=cellfun(@(x)mean_dF.(x)',cellNames,'un',0);
raw_means=cat(1,raw_means{:});
figure; imagesc(raw_means);

figure; imagesc(z_means);
colormap gray
hold on
tmp=gca;
tmp.YTick=[];
tmp.XTick=(1:framesInAcq(1)/30)*30;
tmp.XTickLabel=1:framesInAcq(1)/30;
vline(300);
xlabel('time (s)');
ylabel('ROI')
title('mean Z-scored dF/F by ROI, duty cycle 50%')
mean_df_all=cellfun(@(x)mean_dF.(x)',cellNames,'un',0);
mean_df_all2=cat(1,mean_df_all{:});

stimFrame=300;
%baseline subtract
for cell=1:length(cellNames);
    df=df_byTrial.(cellNames{cell});
    bs_df=zeros(size(df));
    for i=1:size(df,2)
        mean_bs=mean(df(1:stimFrame,i));
        bs_df(:,i)=df(:,i)-mean_bs;
    end
    df_byTrial_bs.(cellNames{cell})=bs_df;
end
plot_US_byROI( df_byTrial_bs,30,300,[] )

%% calculate modulation amplitude by cell and re-order
stimFrame=300
prestim=(stimFrame-60):stimFrame;
poststim=stimFrame:(stimFrame+60);

preStim_Z=mean(z_means(:,prestim),2);
postStim_Z=mean(z_means(:,poststim),2);
mean_response=postStim_Z-preStim_Z;
[mean_response, inds_sorted]=sort(mean_response,'descend');
z_means_sorted=z_means(inds_sorted,:);
figure; imagesc(z_means_sorted)
colormap gray

tmp=gca;
tmp.XTick=(((0:150:framesInAcq(1)))/30)*30;
tmp.XTickLabel=((0:150:framesInAcq(1))-stimFrame)/30;
vline(stimFrame);
xlabel('time from stim onset (s)');
ylabel('ROI')
title('mean Z-scored dF/F by ROI')
mean_df_all=cellfun(@(x)mean_dF.(x)',cellNames,'un',0);
mean_df_all2=cat(1,mean_df_all{:});

cells_sorted=cellNames(inds_sorted);

plot_US_byROI( df_byTrial_bs,30,stimFrame,cells_sorted)
order=fliplr(1:262);
plot_US_byROI( df_byTrial_bs,30,300,cells_sorted(order))


