function US_summaryPlots(dF_byDC,stimFrame,dF_byPressure,cellNames,DC_labels,pressure_labels,ops,poststim)

DCsweep = make_DCsweep( dF_byDC,cellNames,poststim );
pressSweep = make_DCsweep( dF_byPressure,cellNames,poststim );

%% plot mean waveform for each duty cycle across all cells


fns=fieldnames(dF_byDC.(cellNames{1}));
samp_rate=ops.fs;
% figure; hold on
for dc=1:length(fns)
    
%     subplot(1,2,1)
    allResponses_DC=cellfun(@(x)mean(dF_byDC.(x).(fns{dc}),2)',cellNames,'un',0);
%     allResponses=cellfun(@(x)(x-mean(x(1:stimFrame),2))/std(x(1:stimFrame)),allResponses,'un',0)
    allResponses_DC=cat(1,allResponses_DC{:});
    imagesc(allResponses_DC)
    colormap gray
    hold on
    vline(150)
    
    meanResponse_DC{dc}=mean(allResponses_DC);
    semResponse_DC{dc}=std(allResponses_DC)/sqrt(size(allResponses_DC,1));
%     subplot(1,2,2)
%     time=((1:length(meanResponse_DC{dc}))-stimFrame)/samp_rate;
%     boundedline(time,meanResponse_DC{dc},semResponse_DC{dc})
%     title(fns{dc})
end

% plot responses across cells to each DC
fns_pressure=fieldnames(dF_byPressure.(cellNames{1}));
for dc=1:length(fns_pressure)
%     figure;
%     subplot(1,2,1)
    allResponses_P=cellfun(@(x)mean(dF_byPressure.(x).(fns_pressure{dc}),2)',cellNames,'un',0);
%     allResponses_P=cellfun(@(x)(x-mean(x(1:stimFrame),2))/std(x(1:stimFrame)),allResponses_P,'un',0)
    allResponses_P=cat(1,allResponses_P{:});
%     imagesc(allResponses_P)
%     colormap gray
%     hold on
%     vline(150)
    
    meanResponse_P{dc}=mean(allResponses_P);
    semResponse_P{dc}=std(allResponses_P)/sqrt(size(allResponses_P,1));
%     subplot(1,2,2)
7777777777777777777%     time=((1:length(meanResponse_P{dc}))-stimFrame)/samp_rate;
%     boundedline(time,meanResponse_P{dc},semResponse_P{dc})
%     title(fns_pressure{dc})
end

figure; hold on
s(1)=subplot(2,1,1); hold on
% maxY=max(cellfun(@max,mean_evoked));
% minY=min(cellfun(@min,mean_evoked));
% set(gca,'YLim',[minY-0.01 maxY+0.01])
cmap_dc=brewermap(numel(meanResponse_DC)+1,'YlGnBu');
cmap_dc=cmap_dc(2:end,:);
set(gca,'ColorOrder',cmap_dc);
time=((1:length(meanResponse_DC{1}))-stimFrame)/samp_rate;
hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),meanResponse_DC,'Uni',0);
DC_labels_str=arrayfun(@(x)[num2str(x),'%'],DC_labels,'un',0);
legend(DC_labels_str)
% hold off
xlabel('time from US pulse (s)')
ylabel('dF/F')
title('population mean, duty cycle')

s(2)=subplot(2,1,2); hold on
% maxY=max(cellfun(@max,mean_evoked));
% minY=min(cellfun(@min,mean_evoked));
% set(gca,'YLim',[minY-0.01 maxY+0.01])
cmap_p=brewermap(numel(meanResponse_P)+1,'PuRd');
cmap_p=cmap_p(2:end,:);
set(gca,'ColorOrder',cmap_p);
hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),meanResponse_P,'Uni',0);
p_labels_str=arrayfun(@(x)[num2str(x),' MPa'],pressure_labels,'un',0);
legend(p_labels_str)
% hold off
xlabel('time from US pulse (s)')
ylabel('dF/F')
title('population mean, pressure')
linkaxes(s)
%% plot median waveform for each duty cycle across all cells

% figure; hold on
for dc=1:length(fns)
    
%     subplot(1,2,1)
    allResponses_DC=cellfun(@(x)median(dF_byDC.(x).(fns{dc}),2)',cellNames,'un',0);
%     allResponses=cellfun(@(x)(x-mean(x(1:stimFrame),2))/std(x(1:stimFrame)),allResponses,'un',0)
    allResponses_DC=cat(1,allResponses_DC{:});
    imagesc(allResponses_DC)
    colormap gray
    hold on
    vline(150)
    
    medianResponse_DC{dc}=median(allResponses_DC);
    semResponse_DC{dc}=std(allResponses_DC)/sqrt(size(allResponses_DC,1));
%     subplot(1,2,2)
%     time=((1:length(medianResponse_DC{dc}))-stimFrame)/samp_rate;
%     boundedline(time,medianResponse_DC{dc},semResponse_DC{dc})
%     title(fns{dc})
end

% plot responses across cells to each DC
fns_pressure=fieldnames(dF_byPressure.(cellNames{1}));
for dc=1:length(fns_pressure)
%     figure;
%     subplot(1,2,1)
    allResponses_P=cellfun(@(x)median(dF_byPressure.(x).(fns_pressure{dc}),2)',cellNames,'un',0);
%     allResponses_P=cellfun(@(x)(x-median(x(1:stimFrame),2))/std(x(1:stimFrame)),allResponses_P,'un',0)
    allResponses_P=cat(1,allResponses_P{:});
%     imagesc(allResponses_P)
%     colormap gray
%     hold on
%     vline(150)
    
    medianResponse_P{dc}=median(allResponses_P);
    semResponse_P{dc}=std(allResponses_P)/sqrt(size(allResponses_P,1));
%     subplot(1,2,2)
%     time=((1:length(medianResponse_P{dc}))-stimFrame)/samp_rate;
%     boundedline(time,medianResponse_P{dc},semResponse_P{dc})
%     title(fns_pressure{dc})
end

figure; hold on
s(3)=subplot(2,1,1); hold on
% maxY=max(cellfun(@max,median_evoked));
% minY=min(cellfun(@min,median_evoked));
% set(gca,'YLim',[minY-0.01 maxY+0.01])
cmap_dc=brewermap(numel(medianResponse_DC)+1,'YlGnBu');
cmap_dc=cmap_dc(2:end,:);
set(gca,'ColorOrder',cmap_dc);
time=((1:length(medianResponse_DC{1}))-stimFrame)/samp_rate;
% hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),medianResponse_DC,'Uni',0);
DC_labels_str=arrayfun(@(x)[num2str(x),'%'],DC_labels,'un',0);
legend(DC_labels_str)
% hold off
xlabel('time from US pulse (s)')
ylabel('dF/F')
title('population median, duty cycle')

s(4)=subplot(2,1,2); hold on
% maxY=max(cellfun(@max,median_evoked));
% minY=min(cellfun(@min,median_evoked));
% set(gca,'YLim',[minY-0.01 maxY+0.01])
cmap_p=brewermap(numel(medianResponse_P)+1,'PuRd');
cmap_p=cmap_p(2:end,:);
set(gca,'ColorOrder',cmap_p);
% hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),medianResponse_P,'Uni',0);
p_labels_str=arrayfun(@(x)[num2str(x),' MPa'],pressure_labels,'un',0);
legend(p_labels_str)
% hold off
xlabel('time from US pulse (s)')
ylabel('dF/F')
title('population median, pressure')
linkaxes(s)
%% plot duty cycle vs. mean response across all cells

figure; hold on
d(1)=subplot(2,1,1) 
errorbar(DCsweep.meanAll,DCsweep.semAll,'k-','LineWidth',2)
tmp=gca;
tmp.XTick=1:length(DC_labels);
tmp.XTickLabel=DC_labels;
xlabel('duty cycle (%)')
ylabel('dF/F')
title('mean evoked dF/F')

d(2)=subplot(2,1,2)
errorbar(pressSweep.meanAll,pressSweep.semAll,'k-','LineWidth',2)
tmp=gca;
tmp.XTick=1:length(pressure_labels);
tmp.XTickLabel=pressure_labels;
xlabel('pressure level (MPa)')
ylabel('dF/F')

% %% notBoxPlot version
% 
% figure; hold on
% for i=1:length(DC_labels)
%     pl(i)=notBoxPlot(DCsweep.meanByCell(:,i),i,[],'line');
%      pl(i).sd.Color='none';
%     pl(i).data.Marker='.';
%     pl(i).data.MarkerSize=10;
% end
% ax=gca;
% ax.XTick=1:length(DC_labels);
% ax.XTickLabels=DC_labels;
%% plot duty cycle vs. median response across all cells

figure; hold on
d(3)=subplot(2,1,1) 
errorbar(DCsweep.medianAll,DCsweep.semAll,'k-','LineWidth',2)
tmp=gca;
tmp.XTick=1:length(DC_labels);
tmp.XTickLabel=DC_labels;
xlabel('duty cycle (%)')
ylabel('dF/F')
title('median evoked dF/F')

d(4)=subplot(2,1,2)
errorbar(pressSweep.medianAll,pressSweep.semAll,'k-','LineWidth',2)
tmp=gca;
tmp.XTick=1:length(pressure_labels);
tmp.XTickLabel=pressure_labels;
xlabel('pressure level (MPa)')
ylabel('dF/F')

linkaxes(d)
%% swarmplot of mean responses
figure; hold on
dcData=num2cell(DCsweep.meanByCell,1);
DCstring=num2cell(DC_labels);
DCstring=cellfun(@(x)num2str(x),DCstring,'un',0);
h_DC=plotSpread(dcData,[],[],DCstring,4);
for i=3:3+length(DC_labels)-1;
    h_DC{3}.Children(i).MarkerSize=10;
end
    
xlabel('duty cycle (%)')
ylabel('dF/F')
title('mean evoked dF/F')

figure; hold on
dcData=num2cell(pressSweep.meanByCell,1);
Pstring=num2cell(pressure_labels);
Pstring=cellfun(@(x)num2str(x),Pstring,'un',0);
h_press=plotSpread(dcData,[],[],Pstring,4);
for i=3:3+length(pressure_labels)-1;
    h_press{3}.Children(i).MarkerSize=10;
end
    
xlabel('pressure (MPa)')
ylabel('dF/F')
title('mean evoked dF/F')

%% swarmplot of median responses
figure; hold on
dcData=num2cell(DCsweep.medianByCell,1);
DCstring=num2cell(DC_labels);
DCstring=cellfun(@(x)num2str(x),DCstring,'un',0);
h_DC=plotSpread(dcData,[],[],DCstring,4);
for i=3:3+length(DC_labels)-1;
    h_DC{3}.Children(i).MarkerSize=10;
end
    
xlabel('duty cycle (%)')
ylabel('dF/F')
title('median evoked dF/F')

figure; hold on
dcData=num2cell(pressSweep.medianByCell,1);
Pstring=num2cell(pressure_labels);
Pstring=cellfun(@(x)num2str(x),Pstring,'un',0);
h_press=plotSpread(dcData,[],[],Pstring,4);
for i=3:3+length(pressure_labels)-1;
    h_press{3}.Children(i).MarkerSize=10;
end
    
xlabel('pressure (MPa)')
ylabel('dF/F')
title('median evoked dF/F')


%% plot mean response of each cell to strongest stim, ordered by modulation depth

prestim=(stimFrame-60):stimFrame;
% poststim=stimFrame:(stimFrame+60);
meansDC50=cellfun(@(x)mean(dF_byDC.(x).DC50,2)',cellNames,'un',0);
z_means=cellfun(@(x)(x-mean(x(1:stimFrame),2))/std(x(1:stimFrame)),meansDC50,'un',0);
z_means=cat(1,z_means{:});
meansDC50=cat(1,meansDC50{:});

preStim_Z=mean(z_means(:,prestim),2);
postStim_Z=mean(z_means(:,poststim),2);
mean_response_Z=postStim_Z-preStim_Z;
[mean_Z_sorted, inds_sorted]=sort(mean_response_Z,'descend');
z_means_sorted=z_means(inds_sorted,:);
figure; imagesc(z_means_sorted)
colormap gray

numFrames=size(z_means_sorted,2);
tmp=gca;
tmp.XTick=(((0:150:numFrames))/30)*30;
tmp.XTickLabel=((0:150:numFrames)-stimFrame)/30;
vline(stimFrame);
xlabel('time from stim onset (s)');
ylabel('ROI')
title('mean Z-scored dF/F by ROI, 50% DC')

preStim=mean(meansDC50(:,prestim),2);
postStim=mean(meansDC50(:,poststim),2);
mean_response=postStim-preStim;
[mean_response_sorted, inds_sorted]=sort(mean_response,'descend');
meansDC50_sorted=meansDC50(inds_sorted,:);
numFrames=size(meansDC50_sorted,2);
figure; imagesc(meansDC50_sorted)
colormap gray

tmp=gca;
tmp.XTick=(((0:150:numFrames))/30)*30;
tmp.XTickLabel=((0:150:numFrames)-stimFrame)/30;
vline(stimFrame);
xlabel('time from stim onset (s)');
ylabel('ROI')
title('mean dF/F by ROI, 50% DC')



cells_sorted=cellNames(inds_sorted);
%% plot median response of each cell to strongest stim, ordered by modulation depth

prestim=(stimFrame-60):stimFrame;
% poststim=stimFrame:(stimFrame+60);
mediansDC50=cellfun(@(x)median(dF_byDC.(x).DC50,2)',cellNames,'un',0);
% z_medians=cellfun(@(x)(x-median(x(1:stimFrame),2))/std(x(1:stimFrame)),mediansDC50,'un',0);
% z_medians=cat(1,z_medians{:});
mediansDC50=cat(1,mediansDC50{:});

% preStim_Z=median(z_medians(:,prestim),2);
% postStim_Z=median(z_medians(:,poststim),2);
% median_response_Z=postStim_Z-preStim_Z;
% [median_Z_sorted, inds_sorted]=sort(median_response_Z,'descend');
% z_medians_sorted=z_medians(inds_sorted,:);
% figure; imagesc(z_medians_sorted)
% colormap gray
% 
% numFrames=size(z_medians_sorted,2);
% tmp=gca;
% tmp.XTick=(((0:150:numFrames))/30)*30;
% tmp.XTickLabel=((0:150:numFrames)-stimFrame)/30;
% vline(stimFrame);
% xlabel('time from stim onset (s)');
% ylabel('ROI')
% title('median Z-scored dF/F by ROI, 50% DC')

preStim=median(mediansDC50(:,prestim),2);
postStim=median(mediansDC50(:,poststim),2);
median_response=postStim-preStim;
[median_response_sorted, inds_sorted]=sort(median_response,'descend');
mediansDC50_sorted=mediansDC50(inds_sorted,:);
figure; imagesc(mediansDC50_sorted)
colormap gray

tmp=gca;
tmp.XTick=(((0:150:numFrames))/30)*30;
tmp.XTickLabel=((0:150:numFrames)-stimFrame)/30;
vline(stimFrame);
xlabel('time from stim onset (s)');
ylabel('ROI')
title('median dF/F by ROI, 50% DC')



cells_sorted=cellNames(inds_sorted);


%% plot mean response of each cell to strongest stim, ordered by modulation depth
% 
% meansMPa08=cellfun(@(x)mean(dF_byPressure.(x).MPa08,2)',cellNames,'un',0);
% z_means=cellfun(@(x)(x-mean(x(1:stimFrame),2))/std(x(1:stimFrame)),meansMPa08,'un',0);
% z_means=cat(1,z_means{:});
% meansMPa08=cat(1,meansMPa08{:});
% 
% preStim_Z=mean(z_means(:,prestim),2);
% postStim_Z=mean(z_means(:,poststim),2);
% mean_response_Z=postStim_Z-preStim_Z;
% [mean_Z_sorted, inds_sorted]=sort(mean_response_Z,'descend');
% z_means_sorted=z_means(inds_sorted,:);
% figure; imagesc(z_means_sorted)
% colormap gray
% 
% tmp=gca;
% tmp.XTick=(((0:150:numFrames))/30)*30;
% tmp.XTickLabel=((0:150:numFrames)-stimFrame)/30;
% vline(stimFrame);
% xlabel('time from stim onset (s)');
% ylabel('ROI')
% title('mean Z-scored dF/F by ROI, 0.8 MPa')
% 
% preStim=mean(meansMPa08(:,prestim),2);
% postStim=mean(meansMPa08(:,poststim),2);
% mean_response=postStim-preStim;
% [mean_response_sorted, inds_sorted]=sort(mean_response,'descend');
% meansMPa08_sorted=meansMPa08(inds_sorted,:);
% figure; imagesc(meansMPa08_sorted)
% colormap gray
% 
% tmp=gca;
% tmp.XTick=(((0:150:numFrames))/30)*30;
% tmp.XTickLabel=((0:150:numFrames)-stimFrame)/30;
% vline(stimFrame);
% xlabel('time from stim onset (s)');
% ylabel('ROI')
% title('mean dF/F by ROI, 0.8 MPa')
% 
% 
% 
% cells_sorted=cellNames(inds_sorted);
% %% find positive and negative responders
% [pvals_min,pvals_max ] = find_USmodulation_P( dF_byDS,dF_byPressure,stimFrame,60,60 );
% idx_pos=zeros(length(cellNames),1);
% idx_neg=idx_pos;
% alpha=0.5/length(pvals_max.(cellNames{1}));
% for c=1:length(cellNames)
%     idx_pos(c)=sum(pvals_max.(cellNames{c})<alpha)>0;
%     idx_neg(c)=sum(pvals_min.(cellNames{c})<alpha)>0;
% end
% idx_pos=logical(idx_pos);
% idx_neg=logical(idx_neg);
%% plot summary for indivudual cells
plot_US_byROI_params( samp_rate,stimFrame,DCsweep,dF_byDC,pressSweep,dF_byPressure,cells_sorted,pressure_labels,DC_labels)
cells_sorted=cellNames(flipud(inds_sorted));
plot_US_byROI_params( samp_rate,stimFrame,DCsweep,dF_byDC,pressSweep,dF_byPressure,cells_sorted,pressure_labels,DC_labels)


% %% plot modulation amplitude colorcoded over ref image
% % ROI_masks=makeROImasks_suite2p( ops,stat);
% % colorCodeROIs_suite2p(ROI_masks,tif_1100,'scale_var',mean_response)
% 
% cmap=brewermap(20,'PrGn');
% colorCodeROIs_suite2p(ROI_masks,ops.meanImg,'scale_var',mean_response,'cmap',cmap)
% colorCodeROIs_suite2p(ROI_masks,ops.meanImg,'scale_var',mean_response_Z,'cmap',cmap)
% 
% % ROI_masks=makeROImasks_suite2p( ops,stat);
% % colorCodeROIs_suite2p(ROI_masks,tif_1100,'scale_var',mean_response)
% %%
% cmap=brewermap(20,'PrGn');
% colorCodeROIs_suite2p(ROI_masks,ops.meanImg,'scale_var',median_response,'cmap',cmap)
% colorCodeROIs_suite2p(ROI_masks,ops.meanImg,'scale_var',median_response_Z,'cmap',cmap)
% 
% %% plot registration offsets by frame
% yoff_blocks=reshape(ops.yoff,numFrames,length(ops.first_tiffs));
% xoff_blocks=reshape(ops.xoff,numFrames,length(ops.first_tiffs));
% figure; imagesc(yoff_blocks')
% colormap gray
% tmp=gca;
% tmp.XTick=0:150:750;
% tmp.XTickLabel=-5:5:20;
% % vline(150)
% xlabel('time from US pulse (s)')
% ylabel('trials')
% title('registration pixel offset (y)')
% 
% figure; imagesc(xoff_blocks')
% colormap gray
% tmp=gca;
% tmp.XTick=0:150:750;
% tmp.XTickLabel=-5:5:20;
% % vline(150)
% xlabel('time from US pulse (s)')
% ylabel('trials')
% title('registration pixel offset (x)')
% 
% mean_xoff=mean(xoff_blocks');
% mean_xoff_z=(mean_xoff-mean(mean_xoff))/std(mean_xoff);
% mean_yoff=mean(yoff_blocks');
% mean_yoff_z=(mean_yoff-mean(mean_yoff))/std(mean_yoff);
% 
% figure; hold on 
% plot(mean_xoff_z,'k')
% plot(mean_yoff_z','r')
% tmp=gca;
% tmp.XTick=0:150:750;
% tmp.XTickLabel=-5:5:20;
% vline(150)
% xlabel('time from US pulse (s)')
% ylabel('Z-scored pixel offset')
% title('mean registration pixel offset')
% legend('x','y')


end