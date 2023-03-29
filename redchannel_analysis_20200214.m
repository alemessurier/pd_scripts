%% set directories to load and save data
dir_raw='' %location of registered tifs
dir_processed='' %location of suite2p processed data
dir_reduced='' % location to save reduced data

%%

%load in redcells, F_chan2, Fall
redcell=readNPY([dir_processed,'redcell.npy']);
F_chan2=readNPY([dir_processed,'F_chan2.npy']);
load([dir_processed,'Fall.mat']);

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

stdRed=std(F_red,[],2);
stdGreen=std(F_green,[],2);
figure; plot(stdGreen,stdRed,'ko');
hold on
plot(stdGreen(idxred),stdRed(idxred),'ro');


figure; histogram(meanRed,20)
figure; histogram(meanGreen,20)

minG=min(meanGreen);
maxG=max(meanGreen);
minR=min(meanRed);
maxR=max(meanRed);
binsG=minG:((maxG-minG)/20):maxG;
binsR=minR:((maxR-minR)/20):maxR;
[f,ax,binsG,binsR] = scatterPlot_marginals_2020( meanGreen,meanRed,[],binsG,binsR );

scatterPlot_marginals_2020( meanGreen(idxred),meanRed(idxred),[],binsG,binsR );

%%
filetif='R:\froemkelab\froemkelabspace\Amy\imaging\US\SST4\20200109\f1\reg_tif\file011_chan0.tif';

red_masks=plotROImasks_red( ops,stat,iscell,filetif,redcell );
%%

% figure; histogram(redcell(:,2))
redscore=redcell(idxCell,2);
[inds_red]=view_redGreenF_suite2p( F_red,F_green,redscore );