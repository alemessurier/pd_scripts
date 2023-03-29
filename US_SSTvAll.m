function US_SSTvAll(dF_byDC,stimFrame,dF_byPressure,DC_labels,pressure_labels,...
    ops,ROI_masks,Red_ROIs,poststim,cellNames,cellsRed)



DCsweep = make_DCsweep( dF_byDC,cellNames,poststim );
pressSweep = make_DCsweep( dF_byPressure,cellNames,poststim );

DCsweep_red = make_DCsweep( dF_byDC,cellsRed,poststim );
pressSweep_red = make_DCsweep( dF_byPressure,cellsRed,poststim );

%% median response to each duty cycle, comparing sst vs all

fns=fieldnames(dF_byDC.(cellNames{1}));
samp_rate=ops.fs;
figure; hold on
for dc=1:length(fns)
%     figure; hold on
     m(dc)=subplot(length(fns),1,dc)
    allResponses_DC=cellfun(@(x)median(dF_byDC.(x).(fns{dc}),2)',cellNames,'un',0);
%     allResponses=cellfun(@(x)(x-median(x(1:stimFrame),2))/std(x(1:stimFrame)),allResponses,'un',0)
    allResponses_DC=cat(1,allResponses_DC{:});
    medianResponse_DC{dc}=median(allResponses_DC);
    semResponse_DC{dc}=std(allResponses_DC)/sqrt(size(allResponses_DC,1));

    SST_Responses_DC=cellfun(@(x)median(dF_byDC.(x).(fns{dc}),2)',cellsRed,'un',0);
%     SSTResponses=cellfun(@(x)(x-median(x(1:stimFrame),2))/std(x(1:stimFrame)),SSTResponses,'un',0)
    SST_Responses_DC=cat(1,SST_Responses_DC{:});
    SST_medianResponse_DC{dc}=median(SST_Responses_DC);
    SST_semResponse_DC{dc}=std(SST_Responses_DC)/sqrt(size(SST_Responses_DC,1));
  time=((1:length(medianResponse_DC{dc}))-stimFrame)/samp_rate;
     boundedline(time,medianResponse_DC{dc},semResponse_DC{dc},'k','alpha')
     boundedline(time,SST_medianResponse_DC{dc},SST_semResponse_DC{dc},'r','alpha')

     title(fns{dc})
end
xlabel('time from US pulse (s)')
ylabel('median dF/F')
linkaxes(m)
%%
fns=fieldnames(dF_byPressure.(cellNames{1}));
samp_rate=ops.fs;
figure; hold on
for dc=1:length(fns)
%     figure; hold on
     s(dc)=subplot(length(fns),1,dc);
    allResponses_DC=cellfun(@(x)median(dF_byPressure.(x).(fns{dc}),2)',cellNames,'un',0);
%     allResponses=cellfun(@(x)(x-median(x(1:stimFrame),2))/std(x(1:stimFrame)),allResponses,'un',0)
    allResponses_DC=cat(1,allResponses_DC{:});
    medianResponse_DC{dc}=median(allResponses_DC);
    semResponse_DC{dc}=std(allResponses_DC)/sqrt(size(allResponses_DC,1));

    SST_Responses_DC=cellfun(@(x)median(dF_byPressure.(x).(fns{dc}),2)',cellsRed,'un',0);
%     SSTResponses=cellfun(@(x)(x-median(x(1:stimFrame),2))/std(x(1:stimFrame)),SSTResponses,'un',0)
    SST_Responses_DC=cat(1,SST_Responses_DC{:});
    SST_medianResponse_DC{dc}=median(SST_Responses_DC);
    SST_semResponse_DC{dc}=std(SST_Responses_DC)/sqrt(size(SST_Responses_DC,1));
  time=((1:length(medianResponse_DC{dc}))-stimFrame)/samp_rate;
     boundedline(time,medianResponse_DC{dc},semResponse_DC{dc},'k','alpha')
     boundedline(time,SST_medianResponse_DC{dc},SST_semResponse_DC{dc},'r','alpha')

     title(fns{dc})
end
xlabel('time from US pulse (s)')
ylabel('median dF/F')
linkaxes(s)
%% plot duty cycle vs. median response across all cells

figure; hold on
q(1)=subplot(2,1,1);
hold on
errorbar(DCsweep.medianAll,DCsweep.semAll,'k-','LineWidth',2)
errorbar(DCsweep_red.medianAll,DCsweep_red.semAll,'r-','LineWidth',2)
tmp=gca;
tmp.XTick=1:length(DC_labels);
tmp.XTickLabel=DC_labels;
xlabel('duty cycle (%)')
ylabel('dF/F')
title('median evoked dF/F')

q(2)=subplot(2,1,2);
hold on
errorbar(pressSweep.medianAll,pressSweep.semAll,'k-','LineWidth',2)
errorbar(pressSweep_red.medianAll,pressSweep_red.semAll,'r-','LineWidth',2)
tmp=gca;
tmp.XTick=1:length(pressure_labels);
tmp.XTickLabel=pressure_labels;
xlabel('pressure level (MPa)')
ylabel('dF/F')

linkaxes(q,'y')
%% swarmplot of median responses
figure; hold on
g(1)=subplot(2,1,1);
hold on
dcData=num2cell(DCsweep.medianByCell,1);
DCstring=num2cell(DC_labels);
DCstring=cellfun(@(x)num2str(x),DCstring,'un',0);
h_DC=plotSpread(dcData,[],[],DCstring,3);
for i=2:(1+length(DC_labels));
    h_DC{3}.Children(i).MarkerSize=10;
end
h_DC{3}.Children(1).Color=[0 1 0];
h_DC{3}.Children(1).Marker='o';
h_DC{3}.Children(1).MarkerSize=10;
h_DC{3}.Children(1).MarkerFaceColor=[0 1 0];
% h_DC{3}.Children(1).LineWidth=3;

dcData_SST=num2cell(DCsweep_red.medianByCell,1);
DCstring=num2cell(DC_labels);
DCstring=cellfun(@(x)num2str(x),DCstring,'un',0);
h_DC_SST=plotSpread(dcData_SST,[],[],DCstring,0);
for i=1:length(DC_labels);
    h_DC_SST{3}.Children(i).MarkerSize=10;
    h_DC_SST{3}.Children(i).Color=[1 0 0];
end
    
xlabel('duty cycle (%)')
ylabel('dF/F')
title('median evoked dF/F')

g(2)=subplot(2,1,2); hold on
dcData=num2cell(pressSweep.medianByCell,1);
Pstring=num2cell(pressure_labels);
Pstring=cellfun(@(x)num2str(x),Pstring,'un',0);
h_P=plotSpread(dcData,[],[],Pstring,3);
for i=2:(1+length(pressure_labels));
    h_P{3}.Children(i).MarkerSize=10;
end
h_P{3}.Children(1).Color=[0 1 0];
h_P{3}.Children(1).Marker='o';
h_P{3}.Children(1).MarkerFaceColor=[0 1 0];
h_P{3}.Children(1).MarkerSize=10;
% h_P{3}.Children(1).LineWidth=3;

dcData_SST=num2cell(pressSweep_red.medianByCell,1);
h_P_SST=plotSpread(dcData_SST,[],[],Pstring,0);
for i=1:length(pressure_labels);
    h_P_SST{3}.Children(i).MarkerSize=10;
    h_P_SST{3}.Children(i).Color=[1 0 0];
end
    
xlabel('pressure (MPa)')
ylabel('dF/F')
title('median evoked dF/F')

linkaxes(g,'y')

%% plot median response of each cell to each stim, ordered by modulation depth

% all ROIs
prestim=(stimFrame-60):stimFrame;
% poststim=stimFrame:(stimFrame+60);
mediansDC50=cellfun(@(x)median(dF_byDC.(x).DC50,2)',cellNames,'un',0);
z_medians=cellfun(@(x)(x-median(x(1:stimFrame),2))/std(x(1:stimFrame)),mediansDC50,'un',0);
z_medians=cat(1,z_medians{:});
mediansDC50=cat(1,mediansDC50{:});

preStim_Z=median(z_medians(:,prestim),2);
postStim_Z=median(z_medians(:,poststim),2);
median_response_Z=postStim_Z-preStim_Z;
[median_Z_sorted, inds_sorted]=sort(median_response_Z,'descend');
z_medians_sorted=z_medians(inds_sorted,:);

%append red cells
mediansDC50_SST=cellfun(@(x)median(dF_byDC.(x).DC50,2)',cellsRed,'un',0);
z_medians_SST=cellfun(@(x)(x-median(x(1:stimFrame),2))/std(x(1:stimFrame)),mediansDC50_SST,'un',0);
z_medians_SST=cat(1,z_medians_SST{:});
mediansDC50_SST=cat(1,mediansDC50_SST{:});

preStim_Z_SST=median(z_medians_SST(:,prestim),2);
postStim_Z_SST=median(z_medians_SST(:,poststim),2);
median_response_Z_SST=postStim_Z_SST-preStim_Z_SST;
[median_Z_sorted_SST, inds_sorted_SST]=sort(median_response_Z_SST,'descend');
z_medians_sorted_SST=z_medians_SST(inds_sorted_SST,:);
imageZ=cat(1,z_medians_sorted,z_medians_sorted_SST);
figure; imagesc(imageZ)
colormap gray
hold on
hline(size(z_medians_sorted,1))

numFrames=size(z_medians_sorted,2);
tmp=gca;
tmp.XTick=(((0:150:numFrames))/30)*30;
tmp.XTickLabel=((0:150:numFrames)-stimFrame)/30;
vline(stimFrame);
xlabel('time from stim onset (s)');
ylabel('ROI')
title('median Z-scored dF/F by ROI, 50% DC')

preStim=median(mediansDC50(:,prestim),2);
postStim=median(mediansDC50(:,poststim),2);
median_response=postStim-preStim;
[median_response_sorted, inds_sorted]=sort(median_response,'descend');
mediansDC50_sorted=mediansDC50(inds_sorted,:);

preStim_SST=median(mediansDC50_SST(:,prestim),2);
postStim_SST=median(mediansDC50_SST(:,poststim),2);
median_response_SST=postStim_SST-preStim_SST;
[median_response_sorted_SST, inds_sorted_SST]=sort(median_response_SST,'descend');
mediansDC50_sorted_SST=mediansDC50_SST(inds_sorted_SST,:);

imageR=cat(1,mediansDC50_sorted,mediansDC50_sorted_SST);
figure; imagesc(imageR)
colormap gray
hold on
hline(size(z_medians_sorted,1))

% figure; imagesc(mediansDC50_sorted)
colormap gray

tmp=gca;
tmp.XTick=(((0:150:numFrames))/30)*30;
tmp.XTickLabel=((0:150:numFrames)-stimFrame)/30;
vline(stimFrame);
xlabel('time from stim onset (s)');
ylabel('ROI')
title('median dF/F by ROI, 50% DC')



% cells_sorted=cellNames(inds_sorted);
%% plot median response of each cell to each stim, ordered by modulation depth
% 
% % all ROIs
% prestim=(stimFrame-60):stimFrame;
% % poststim=stimFrame:(stimFrame+60);
% mediansP02=cellfun(@(x)median(dF_byPressure.(x).MPa02,2)',cellNames,'un',0);
% z_medians=cellfun(@(x)(x-median(x(1:stimFrame),2))/std(x(1:stimFrame)),mediansP02,'un',0);
% z_medians=cat(1,z_medians{:});
% mediansP02=cat(1,mediansP02{:});
% 
% preStim_Z=median(z_medians(:,prestim),2);
% postStim_Z=median(z_medians(:,poststim),2);
% median_response_Z=postStim_Z-preStim_Z;
% [median_Z_sorted, inds_sorted]=sort(median_response_Z,'descend');
% z_medians_sorted=z_medians(inds_sorted,:);
% 
% %append red cells
% mediansP02_SST=cellfun(@(x)median(dF_byPressure_red.(x).MPa02,2)',cellsRed,'un',0);
% z_medians_SST=cellfun(@(x)(x-median(x(1:stimFrame),2))/std(x(1:stimFrame)),mediansP02_SST,'un',0);
% z_medians_SST=cat(1,z_medians_SST{:});
% mediansP02_SST=cat(1,mediansP02_SST{:});
% 
% preStim_Z_SST=median(z_medians_SST(:,prestim),2);
% postStim_Z_SST=median(z_medians_SST(:,poststim),2);
% median_response_Z_SST=postStim_Z_SST-preStim_Z_SST;
% [median_Z_sorted_SST, inds_sorted_SST]=sort(median_response_Z_SST,'descend');
% z_medians_sorted_SST=z_medians_SST(inds_sorted_SST,:);
% imageZ=cat(1,z_medians_sorted,z_medians_sorted_SST);
% figure; imagesc(imageZ)
% colormap gray
% hold on
% hline(size(z_medians_sorted,1))
% 
% numFrames=size(z_medians_sorted,2);
% tmp=gca;
% tmp.XTick=(((0:150:numFrames))/30)*30;
% tmp.XTickLabel=((0:150:numFrames)-stimFrame)/30;
% vline(stimFrame);
% xlabel('time from stim onset (s)');
% ylabel('ROI')
% title('median Z-scored dF/F by ROI, 0.2 MPa')
% 
% preStim=median(mediansP02(:,prestim),2);
% postStim=median(mediansP02(:,poststim),2);
% median_response=postStim-preStim;
% [median_response_sorted, inds_sorted]=sort(median_response,'descend');
% mediansP02_sorted=mediansP02(inds_sorted,:);
% 
% preStim_SST=median(mediansP02_SST(:,prestim),2);
% postStim_SST=median(mediansP02_SST(:,poststim),2);
% median_response_SST=postStim_SST-preStim_SST;
% [median_response_sorted_SST, inds_sorted_SST]=sort(median_response_SST,'descend');
% mediansP02_sorted_SST=mediansP02_SST(inds_sorted_SST,:);
% 
% imageR=cat(1,mediansP02_sorted,mediansP02_sorted_SST);
% figure; imagesc(imageR)
% colormap gray
% hold on
% hline(size(z_medians_sorted,1))
% 
% % figure; imagesc(mediansP02_sorted)
% colormap gray
% 
% tmp=gca;
% tmp.XTick=(((0:150:numFrames))/30)*30;
% tmp.XTickLabel=((0:150:numFrames)-stimFrame)/30;
% vline(stimFrame);
% xlabel('time from stim onset (s)');
% ylabel('ROI')
% title('median dF/F by ROI, 0.2 MPa')
%% visualize ROI masks
%% function body
figure;
% cmap=brewermap(numBins,cmapName);

    colorMask=cat(3,zeros(512),zeros(512),zeros(512));
    h=imshow(colorMask);
    rwm=sum(ROI_masks,3);
    rwm=rwm>0;
    set(h,'AlphaData',rwm*0.8)
     tmp=gca;
    tmp.Visible='on';
    tmp.XTick=[];
    tmp.YTick=[];
    figure;
% cmap=brewermap(numBins,cmapName);

    colorMask=cat(3,ones(512),zeros(512),zeros(512));
    h=imshow(colorMask);
    rwm=sum(Red_ROIs,3);
    rwm=rwm>0;
    set(h,'AlphaData',rwm)
    tmp=gca;
    tmp.Visible='on';
    tmp.XTick=[];
    tmp.YTick=[];


