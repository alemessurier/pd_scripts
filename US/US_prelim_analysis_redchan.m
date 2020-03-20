%% set directories to load and save data
dir_raw='R:\froemkelab\froemkelabspace\Amy\imaging\US\SST131\reduced\suite2p\plane0\reg_tif\'; %location of registered tifs
dir_processed='R:\froemkelab\froemkelabspace\Amy\imaging\US\SST131\reduced\suite2p\plane0\'; %location of suite2p processed data
dir_reduced='R:\froemkelab\froemkelabspace\Amy\imaging\US\VIP212\US\reduced\'; % location to save reduced data

load([dir_processed,'Fall.mat']);
%%
%only include ROIs classified as cells
idxCell=find(iscell(:,1));
Fcell=F(idxCell,:);
Fneu=Fneu(idxCell,:);
% subtract neuropil signal
F_np_corr=Fcell-0.7.*Fneu;

% look through all cells
inds_ex=zeros(size(idxCell));
[inds_ex]=check_rawROIs_suite2p( Fcell,Fneu,F_np_corr );
F_include=F_np_corr(~inds_ex,:);
% F_include=F_np_corr;
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
% for K=1:size(filepaths,1)
%     numframes=read_numFrames_tiff(filepaths(K,:));
%     framesInAcq(K)=numframes;
% end
framesInAcq=repmat(750,size(filepaths,1),1);
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
stimFrames=150;
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
vline(150);
xlabel('time (s)');
ylabel('ROI')
title('mean Z-scored dF/F by ROI, duty cycle 50%')
mean_df_all=cellfun(@(x)mean_dF.(x)',cellNames,'un',0);
mean_df_all2=cat(1,mean_df_all{:});

stimFrame=150;
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
plot_US_byROI( df_byTrial_bs,30,150,[] )

%% calculate modulation amplitude by cell and re-order
stimFrame=150
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
order=fliplr(1:length(cellNames));
plot_US_byROI( df_byTrial_bs,30,300,cells_sorted(order))


%% only plot red cells
redcell=readNPY([dir_processed,'redcell.npy']);
idxred=logical(redcell(idxCell,1));
z_means_red=z_means(idxred,:);

figure; imagesc(z_means_red)
colormap gray

tmp=gca;
tmp.XTick=(((0:150:framesInAcq(1)))/30)*30;
tmp.XTickLabel=((0:150:framesInAcq(1))-stimFrame)/30;
vline(stimFrame);
xlabel('time from stim onset (s)');
ylabel('ROI')
title('mean Z-scored dF/F by ROI')

cells_red=cellNames(idxred);

plot_US_byROI( df_byTrial_bs,30,stimFrame,cells_red)
%% histogram of mean response
% figure; h_all=histogram(mean_response,'BinWidth',0.25)
figure; hold on
mean_response_red=mean_response(idxred);
pval=plot_2cdfs(mean_response,mean_response_red);
title(['p<',num2str(pval)])
xlabel('mean response')
ylabel('cumulative fraction of cells')
legend('all cells','SST cells')


%%

%load in redcells, F_chan2, Fall
redcell=readNPY([dir_processed,'redcell.npy']);
F_chan2=readNPY([dir_processed,'F_chan2.npy']);

idxCell=find(iscell(:,1));
F_green=F(idxCell,:);
F_red=F_chan2(idxCell,:);


for i=1:size(F_green,1)
    corr=corrcoef(F_green(i,:),F_red(i,:));
    channel_corr(i)=corr(2,1);
end

figure; histogram(channel_corr)
allcells=1:length(channel_corr);
figure; plot(allcells,channel_corr,'ko')
hold on

idxred=logical(redcell(idxCell,1));
plot(allcells(idxred),channel_corr(idxred),'ro')

%% 

meanRed=mean(F_red,2);
meanGreen=mean(F_green,2);
figure; plot(meanGreen,meanRed,'ko');
hold on
plot(meanGreen(idxred),meanRed(idxred),'ro');
xlabel('mean F, green');
ylabel('mean F, red');
legend('all cells','SST')

% stdRed=std(F_red,[],2);
% stdGreen=std(F_green,[],2);
% figure; plot(stdGreen,stdRed,'ko');
% hold on
% plot(stdGreen(idxred),stdRed(idxred),'ro');
% 
% 
% figure; histogram(meanRed,20)
% figure; histogram(meanGreen,20)
% 
% minG=min(meanGreen);
% maxG=max(meanGreen);
% minR=min(meanRed);
% maxR=max(meanRed);
% binsG=minG:((maxG-minG)/20):maxG;
% binsR=minR:((maxR-minR)/20):maxR;
% [f,ax,binsG,binsR] = scatterPlot_marginals_2020( meanGreen,meanRed,[],binsG,binsR );
% 
% scatterPlot_marginals_2020( meanGreen(idxred),meanRed(idxred),[],binsG,binsR );
% 
%%
filetif=[dir_raw,'file011_chan0.tif'];
% filetif='R:\froemkelab\froemkelabspace\Amy\imaging\US\SST130\2p\20200302_06MPa_50DC_00011.tif';
cell_masks=plotROImasks_red( ops,stat,iscell,filetif,iscell );
%%

% figure; histogram(redcell(:,2))
redscore=redcell(idxCell,2);
[inds_red]=view_redGreenF_suite2p( F_red,F_green,redscore );

%% save out some variables

save([dir_reduced,'analysis_',date,'.mat'],'inds_ex','F_include','deltaF','framesInAcq','filtTrace','df_byTrial_bs','mean_response','stimFrame')