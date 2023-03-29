%% set directories to load and save data
dir_raw='E:\s2p\SST131\reduced\20200328\suite2p\plane0\reg_tif\' %location of registered tifs
dir_processed='E:\s2p\SST131\reduced\20200328\suite2p\plane0\' %location of suite2p processed data
dir_reduced='E:\s2p\SST131\reduced\20200328\suite2p\plane0\' % location to save reduced data

load([dir_reduced,'Fall.mat']);

%% load in cell masks from suite2p, define ROIs


%only include ROIs classified as cells
idxCell=find(iscell(:,1));
stat_cells=stat(idxCell);
ROI_masks=makeROImasks_suite2p( ops,stat_cells);

%% label red ROIs
dir_redchan='E:\s2p\SST131\reduced\suite2p\plane0\reg_tif_chan2\'
[Red_ROIs,npMasks_red]=label_ROIs_SI2019(dir_redchan,[],10,2);
save([dir_reduced,'Red_masks.mat'],'Red_ROIs','npMasks_red')

%% determine which cells are red based on ROI overlap

ROI_masks_all=cat(3,ROI_masks,Red_ROIs);
ROIcheck=squeeze(sum(sum(ROI_masks_all)))==0;
ROI_masks_all=ROI_masks_all(:,:,~ROIcheck);
rawTimeSeries = getFluoTimeSeries_wrapper_SI2019( dir_raw,  ROI_masks_all);
    save(strcat(dir_reduced,'ROI_timeSeries.mat'),'rawTimeSeries');
rawTimeSeries=cat(2,rawTimeSeries{:});
%% transform rawTimeSeries into ROI-based structure

for i=1:size(rawTimeSeries,1)
    cellName=['cell',num2str(i)];
    raw=cat(1,rawTimeSeries{i,:})';
    filt=zeros(size(raw));
    for j=1:size(filt,2)
        filt(:,j)=slidingAvg_rawF(raw(:,j),2,'median');
    end
    rawF_byTrial.(cellName)=raw;
    filtF_byTrial.(cellName)=filt;
    
end

%% get names of movies, extract stimulus info
filelist=char2cell(ops.filelist,[],1); %turn into cell array
pressure=cell(length(filelist),1);
duty=pressure;
for p=1:length(pressure)
    idx_MPa=strfind(filelist{p},'MPa');
    idx_DC=strfind(filelist{p},'DC');
    press=filelist{p}((idx_MPa-2):(idx_MPa-1));
    d=filelist{p}((idx_DC-2):(idx_DC-1));
    pressure{p}=press;
    duty{p}=d;
end
pressure=categorical(pressure);
pressure(pressure=='_0')='0';
duty=categorical(duty);
duty(duty=='_5')='5';

%SST130 post-deafening: last 16 trials of 30%DC were actually 40%; relabel
% idx30=find(duty=='30');
% idx40=idx30(17:end);
% duty(idx40)='40';

%% calculate dF/F trial-by-trial
cellNames=fieldnames(filtF_byTrial);
stimFrame=150;
for c=1:length(cellNames)
%     filtTraces=filtF_byTrial.(cellNames{c});
filtTraces=rawF_byTrial.(cellNames{c});
    dF_c=zeros(size(filtTraces));
    for i=1:size(filtTraces,2)
        f_0=mean(filtTraces(1:(stimFrame-1),i));
        dF_c(:,i)=(filtTraces(:,i)-f_0)/f_0;
    end
    df_byTrial_new.(cellNames{c})=dF_c;
    meanDF_allParams.(cellNames{c})= mean(dF_c,2);
end

% zscore, plot mean zscore for each cell over all trials
z_means=cellfun(@(x)((meanDF_allParams.(x)-mean(meanDF_allParams.(x)))/std(meanDF_allParams.(x)))',cellNames,'un',0);
z_means=cat(1,z_means{:});
figure; imagesc(z_means);
colormap gray
hold on
tmp=gca;
tmp.YTick=[];
tmp.XTick=(1:size(z_means,2)/30)*30;
tmp.XTickLabel=1:size(z_means,2)/30;
vline(150);
xlabel('time (s)');
ylabel('ROI')
title('mean Z-scored dF/F by ROI, duty cycle 50%')

% calculate modulation for each trial for each cell
stimFrame=150
prestim=(stimFrame-60):stimFrame;
poststim=stimFrame:(stimFrame+60);
evokedByTrial=cellfun(@(x)mean(df_byTrial_new.(x)(poststim,:),1),cellNames,'un',0);
evokedByTrial=cat(1,evokedByTrial{:});
evokedByTrial_Z=cellfun(@(x)(mean(df_byTrial_new.(x)(poststim,:),1)...
    -mean(df_byTrial_new.(x)(1:stimFrame,:),1))./std(df_byTrial_new.(x)(1:stimFrame,:),[],1),cellNames,'un',0);
evokedByTrial_Z=cat(1,evokedByTrial_Z{:});
% evokedByTrial_pressSweep=evokedByTrial(:,pressure=='08');
%% separate df/f by trial/DC/cell

% DCs=unique(duty);
DCs=categorical([5, 10:10:50]');
meanByCell=zeros(length(cellNames),length(DCs));
stdByCell=meanByCell;
semByCell=meanByCell;

for dc=1:length(DCs)
    idx_dc=duty==DCs(dc) & pressure=='08';
    fn=['DC',char(DCs(dc))];
    DCsweep.(fn)=evokedByTrial(:,idx_dc);
    meanByCell(:,dc)=mean(evokedByTrial(:,idx_dc),2);
    stdByCell(:,dc)=std(evokedByTrial(:,idx_dc),[],2);
    semByCell(:,dc)=stdByCell(:,dc)/sqrt(size(evokedByTrial(:,idx_dc),2));
    
    for c=1:length(cellNames)
        dF_byDS.(cellNames{c}).(fn)=df_byTrial_new.(cellNames{c})(:,idx_dc);
    end
        
end
meanAll=mean(meanByCell,1);
stdAll=std(meanByCell,[],1);
semAll=stdAll/sqrt(size(meanAll,1));
DCsweep.meanByCell=meanByCell;
DCsweep.stdByCell=stdByCell;
DCsweep.semByCell=semByCell;
DCsweep.meanAll=meanAll;
DCsweep.stdAll=stdAll;
DCsweep.semAll=semAll;

%% separate df/f by trial/pressure/cell

press=categorical({'0','01','04','06','08'})'
meanByCell=zeros(length(cellNames),length(press));
stdByCell=meanByCell;
semByCell=meanByCell;

for dc=1:length(press)
    idx_dc=pressure==press(dc) & duty=='50';
    fn=['MPa',char(press(dc))];
    pressSweep.(fn)=evokedByTrial(:,idx_dc);
    meanByCell(:,dc)=mean(evokedByTrial(:,idx_dc),2);
    stdByCell(:,dc)=std(evokedByTrial(:,idx_dc),[],2);
    semByCell(:,dc)=stdByCell(:,dc)/sqrt(size(evokedByTrial(:,idx_dc),2));
    
    for c=1:length(cellNames)
        dF_byPressure.(cellNames{c}).(fn)=df_byTrial_new.(cellNames{c})(:,idx_dc);
    end
        
end
meanAll=mean(meanByCell,1);
stdAll=std(meanByCell,[],1);
semAll=stdAll/sqrt(size(meanAll,1));
pressSweep.meanByCell=meanByCell;
pressSweep.stdByCell=stdByCell;
pressSweep.semByCell=semByCell;
pressSweep.meanAll=meanAll;
pressSweep.stdAll=stdAll;
pressSweep.semAll=semAll;

%% make summary plots
DC_labels=[5,10:10:50];
pressure_labels=[0,0.1,0.4,0.6,0.8];
tif_1100='E:\s2p\SST131\reduced\20200328\suite2p\plane0\reg_tif_chan2\file160_chan1.tif';
US_summaryPlots(dF_byDS,stimFrame,dF_byPressure,DCsweep,...
    pressSweep,DC_labels,pressure_labels,ops,stat,tif_1100,ROI_masks_all)

%% separate tdtomato cells

idxRed=(length(cellNames)-size(Red_ROIs,3)+1):length(cellNames);
cellsRed=cellNames(idxRed);

tmpdF_byDS=struct2cell(dF_byDS);
dF_byDS_red=cell2struct(tmpdF_byDS(idxRed),cellsRed);

tmpdF_byP=struct2cell(dF_byPressure);
dF_byPressure_red=cell2struct(tmpdF_byP(idxRed),cellsRed);

fnsDC=fieldnames(DCsweep);
for i=1:(length(fnsDC)-3)
    DCsweep_red.(fnsDC{i})=DCsweep.(fnsDC{i})(idxRed,:);
end

meanAll=mean(DCsweep_red.meanByCell,1);
stdAll=std(DCsweep_red.meanByCell,[],1);
semAll=stdAll/sqrt(size(meanAll,1));
DCsweep_red.meanAll=meanAll;
DCsweep_red.stdAll=stdAll;
DCsweep_red.semAll=semAll;

fnsP=fieldnames(pressSweep);
for i=1:(length(fnsP)-3)
    pressSweep_red.(fnsP{i})=pressSweep.(fnsP{i})(idxRed,:);
end

meanAll=mean(pressSweep_red.meanByCell,1);
stdAll=std(pressSweep_red.meanByCell,[],1);
semAll=stdAll/sqrt(size(meanAll,1));
pressSweep_red.meanAll=meanAll;
pressSweep_red.stdAll=stdAll;
pressSweep_red.semAll=semAll;

%% make summary plots tdtomato
US_summaryPlots(dF_byDS_red,stimFrame,dF_byPressure_red,DCsweep_red,...
    pressSweep_red,DC_labels,pressure_labels,ops,stat(idxRed),tif_1100,Red_ROIs)

%% save

save([dir_reduced,'analysis_redCells_',date,'.mat'],'dF_byDS','stimFrame','dF_byPressure','DCsweep',...
    'pressSweep','DC_labels','pressure_labels','ROI_masks_all','dF_byDS_red','stimFrame','dF_byPressure_red','DCsweep_red',...
    'pressSweep_red','Red_ROIs','rawTimeSeries')