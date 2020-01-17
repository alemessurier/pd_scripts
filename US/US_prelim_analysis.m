% load in raw fluorescence files
load('') %path to Fall.mat
%%
% subtract neuropil signal
F_np_corr=F-0.7.*Fneu;

% look through all cells
[inds_ex]=check_rawROIs_suite2p( F,Fneu,F_np_corr );
F_include=F_np_corr(~inds_ex,:);

% filter data w/moving median filter
filtF=zeros(size(F_include));
for i=1:size(filtF,1)
    cellName=['cell',num2str(i)];
    [ filtTrace.(cellName) ] = slidingAvg_rawF( F_np_corr(i,:),5,'median' );
    filtF(i,:)=filtTrace.(cellName);
end
% calculate dF/F from raw image traces
deltaF=deltaF_suite2p(filtF);

samp_rate=ops.fs;
spacing=10;
numCells=50;
plot_deltaF( filtTrace,samp_rate,200,numCells )
%%
plot_deltaF( deltaF,samp_rate,10,numCells )

%% get number of frames in each movie

filepaths=ops.filelist;
framesInAcq=zeros(size(filepaths,1),1);
for K=1:size(filepaths,1)
    numframes=read_numFrames_tiff(filepaths(K,:));
    framesInAcq(K)=numframes;
end

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
plot_deltaF( mean_dF,samp_rate,1,50 )
z_means=cellfun(@(x)((mean_dF.(x)-mean(mean_dF.(x)))/std(mean_dF.(x)))',cellNames,'un',0);
z_means=cat(1,z_means{:});
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
plot_US_byROI( df_byTrial_bs,30,300 )
% mean_byCell=mean(mean_df_all2,2);
% std_byCell=std(mean_df_all2,[],2);
% z_means=zeros(size(mean_df_all2));
% for i=1:length(cellNames
%     z_means(i,:)=