%% load in multi-day ROI data
pupCalls_gcamp8_paths
paths_2p=paths_2p([1:3,5]);
matchFilePath=matchFilePath([1:3,5])


%% make multi-day ROI data structures

for a=1:length(paths_2p)
    [allDates_calls_10sec{a},allDates_calls_5sec{a},allDates_calls_2sec{a},...
    allDates_tones_5sec{a},allDates_tones_3sec{a},MultiDayROIs_calls_2sec{a},...
    MultiDayROIs_calls_5sec{a},MultiDayROIs_calls_10sec{a},...
    MultiDayROIs_tones_3sec{a},meanDF_best_2sec_all{a},...
    meanDF_best_5sec_all{a},meanDF_best_10sec_all{a},...
        meanDF_best_tones_all{a},ROIidx_days{a},dayIdx{a}]= pupCalls_loadMultiDayROIs_allMice(paths_2p{a},matchFilePath{a});
end

%% concatenate responses and ROI indices across mice, days
meanDF_best_5sec_allFields=cat(1,meanDF_best_5sec_all{:});
meanDF_best_10sec_allFields=cat(1,meanDF_best_10sec_all{:});
% meanDF_best_2sec_allFields=cat(1,meanDF_best_2sec_all{:});
meanDF_best_tones_allFields=cat(1,meanDF_best_tones_all{:});
ROIidx_days_allFields=cat(1,ROIidx_days{:});
dayIdx_allFields=cat(1,dayIdx{:});

ROIidx_fields=[];
for d=1:length(paths_2p)
    idx=repmat(d,length(ROIidx_days{d}),1);
    ROIidx_fields=[ROIidx_fields;idx];
end
%% run PCA on best call responses, 5 sec ISI, all days

% [PCs, SCORE, LATENT, TSQUARED, explained,mu] = pca(meanDF_best_5sec{1});

% meanDF_best_5sec_all=cat(1,meanDF_best_5sec{:});

[PCs, SCORE, LATENT, TSQUARED, explained,mu] = pca(meanDF_best_5sec_allFields);
figure; plot(cumsum(explained));
figure; imagesc(PCs')
colormap gray
cmap=brewermap(6,'Set2');
figure; hold on
for i=1:3
    plot(PCs(:,i),'color',cmap(i,:))
end

%%
% meanDF_best_10sec_all=cat(1,meanDF_best_10sec{:});

[PCs, SCORE, LATENT, TSQUARED, explained,mu] = pca(meanDF_best_10sec_allFields);
figure; plot(cumsum(explained));
figure; imagesc(PCs')
colormap gray
cmap=brewermap(5,'Set2');
figure; hold on
for i=1:3
    plot(PCs(:,i),'color',cmap(i,:))
end
legend
%%
%%
% meanDF_best_10sec_all=cat(1,meanDF_best_10sec{:});

[PCs, SCORE, LATENT, TSQUARED, explained,mu] = pca(meanDF_best_10sec_allFields);
figure; plot(cumsum(explained));
figure; imagesc(PCs')
colormap gray
cmap=brewermap(6,'Set2');
figure; hold on
timePlot=1:size(PCs,2);
timePlot=(timePlot/30)-2;
for i=1:10
    figure
%     subplot(1,2,1)
    plot(timePlot,PCs(:,i))%,'color',cmap(i,:))
    title(['PC ',num2str(i)])
xlabel('time (s)')
%     subplot(1,2,2)
%     histogram(SCORE(:,i))
end
% legend
%% sort best responses based on PC weights, plot as heatmap

for PC=1:4
    [sortedWeights,sortIDX]=sort(SCORE(:,PC),'descend');
    sortIDX=sortIDX(~isnan(sortedWeights));
    sortedRs=meanDF_best_10sec_allFields(sortIDX,:);
    figure;
    imagesc(sortedRs,[-20 50])
    colormap gray
    title(['sorted by PC ',num2str(PC)])
end

%% determine which (if any) PCs are significantly weighted on one day of imaging vs others

%% determine which (if any) PCs are significantly weighted on one imaging field vs. others

%% plot distributions of weights of each PCA by imaging field

numFields=length(unique(ROIidx_fields));
cmap=brewermap(numFields,'Set3');
for p=1:5
    figure; hold on
    for f=1:numFields
        idx=ROIidx_fields==f;
    pl(f)=cdfplot(SCORE(idx,p));
    pl(f).Color=cmap(f,:);
    end
    title(['PC',num2str(p)])
    legend
end

%% plot distributions of weights of each PCA by day of imaging


numDays=length(unique(dayIdx_allFields));
cmap=morgenstemning(numDays+3);
% cmap=flipud(cmap);
for p=1:5
    figure; hold on
    for f=1:numDays
        idx=dayIdx_allFields==f;
    pl(f)=cdfplot(SCORE(idx,p));
    pl(f).Color=cmap(f,:);
    end
    title(['PC',num2str(p)])
    legend
end

%% 3d scatter plot of first 3 PC weights for each cell, colorcoded by day
figure; hold on
cmapDays=brewermap(4,'Set2');
for f=1:4
%     figure; hold on
    ROIsByDay=ROIidx_days_allFields(ROIidx_fields==f); % get ROI positions on each day for this field
    ROIsField=unique(ROIsByDay); % each ROI in this field
    daysField=dayIdx_allFields(ROIidx_fields==f); % day index for ROIs in this field
    days=unique(daysField); % each day this field was imaged
    numDays=max(days);
    weightsField=SCORE(ROIidx_fields==f,2:4); % weights for ROIs in this field for 3 PCs
%     for r=1:length(ROIsField) % plot a line for each ROI connected values across days
%         thisROI=weightsField(ROIsByDay==r,:);
%         tmp=plot3(thisROI(1:2,1),thisROI(1:2,2),thisROI(1:2,3));
%         tmp.Color=[0 0 0];
%         hold on
%     end
    
    for d=1:2%numDays
        thisDay=weightsField(daysField==d,:);
        tmp=plot3(thisDay(:,1),thisDay(:,2),thisDay(:,3));
        tmp.Color=cmapDays(d,:);
        tmp.Marker='o';
        tmp.MarkerFaceColor=cmapDays(d,:);
        tmp.LineStyle='none';
        hold on
    end

end

%% 2d plots of each PC weights for each cell across days, colorcoded by field


numFields=4
cmapFields=brewermap(numFields,'Set2');
for PC=1:5
figure; hold on
    for f=1:numFields
%     figure; hold on
    ROIsByDay=ROIidx_days_allFields(ROIidx_fields==f); % get ROI positions on each day for this field
    ROIsField=unique(ROIsByDay); % each ROI in this field
    daysField=dayIdx_allFields(ROIidx_fields==f); % day index for ROIs in this field
    days=unique(daysField); % each day this field was imaged
    numDays=max(days);
    weightsField=SCORE(ROIidx_fields==f,PC); % weights for ROIs in this field for 3 PCs
    for r=1:length(ROIsField) % plot a line for each ROI connected values across days
        thisROI=weightsField(ROIsByDay==r);
        tmp=plot(days,thisROI,'o-','Color',cmapFields(f,:));
        
    end
   
    end
    title(['PC ',num2str(PC),' weights'])
    xlabel('day of imaging')
    ylabel('weight')
    
end

%% find ROIs with biggest weights on first 10 PCs, plot RFs over days
    numCells=round(0.2*size(SCORE,1))


for PC=1:10
    % find top 10% of cells
    [weights,sortedWeightsIdx] = sort(SCORE(:,PC),'descend');
    nanWeight=isnan(weights);
    sortedWeightsIdx=sortedWeightsIdx(~nanWeight);

    % get response data from these cells for plotting
    fieldIDs=ROIidx_fields(sortedWeightsIdx(1:numCells)); % which field
    dayIDs=dayIdx_allFields(sortedWeightsIdx(1:numCells)); % which day
    withinDayIDs=ROIidx_days_allFields(sortedWeightsIdx(1:numCells)); % which ROI
    figure;
    histogram(dayIDs)
    xlabel('day of imaging')
    ylabel('#of cells')
    title(['top 20% of cells, PC ',num2str(PC)])

    figure; 
    histogram(fieldIDs)
    xlabel('mouse')
    ylabel('#of cells')
    title(['top 20% of cells, PC ',num2str(PC)])

%     figure; hold on
%     title(['PC ',num2str(PC),' weights'])
%     xlabel('day')
%     cmap=brewermap(7,'Set3')
%     for r=1:10
% %         plot_meanDF_multiday_single(allDates_tones_3sec{fieldIDs(r)},...
% %             allDates_calls_10sec{fieldIDs(r)},MultiDayROIs_tones_3sec{fieldIDs(r)}, ...
% %                 MultiDayROIs_calls_10sec{fieldIDs(r)},withinDayIDs(r));
% 
%         plot_meanDF_calls_multiISI_single(allDates_calls_10sec{fieldIDs(r)},...
%             allDates_calls_5sec{fieldIDs(r)},allDates_calls_2sec{fieldIDs(r)},...
%             MultiDayROIs_calls_2sec{fieldIDs(r)},MultiDayROIs_calls_5sec{fieldIDs(r)},...
%             MultiDayROIs_calls_10sec{fieldIDs(r)},withinDayIDs(r));
%         
%         % get weights for this cell on this PC for each day of imaging
%         thisROIIdx=ROIidx_fields==fieldIDs(r) & ROIidx_days_allFields==withinDayIDs(r);    
%         tmpweight=SCORE(thisROIIdx,PC);
%         tmpdays=dayIdx_allFields(thisROIIdx);
%         ROIweights{r}=tmpweight(~isnan(tmpweight));
%         ROIdays{r}=tmpdays(~isnan(tmpweight));
%         plot(ROIdays{r},ROIweights{r},'o-','Color',cmap(fieldIDs(r),:))
%     end
    
end
