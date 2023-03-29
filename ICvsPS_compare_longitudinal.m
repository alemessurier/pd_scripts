%% load in multiday data from IC and PS mice
pupCalls_loadTrackedData_ICvsPS

%% get best responses to calls and tones - PS

for i=1:length(MultiDayROIs_calls_PS)
    [meanDF_best_tones_PS{i},meanDF_best_PS{i},dayIdx_PS{i},ROIidx_days_PS{i}]=...
        pupCalls_getBestCallsTones(MultiDayROIs_calls_PS{i},...
        MultiDayROIs_tones_PS{i},allDates_calls_PS{i},allDates_tones_PS{i},dayCohoused_PS{i});
end

% concatenate responses and ROI indices across mice, days
meanDF_bestCalls_all_PS=cat(1,meanDF_best_PS{:});
meanDF_bestTones_all_PS=cat(1,meanDF_best_tones_PS{:});
ROIidx_days_all_PS=cat(1,ROIidx_days_PS{:});
dayIdx_all_PS=cat(1,dayIdx_PS{:});

ROIidx_fields_PS=[];
for d=1:length(paths_PS)
    idx=repmat(d,length(ROIidx_days_PS{d}),1);
    ROIidx_fields_PS=[ROIidx_fields_PS;idx];
end

%% get best responses to calls and tones - IC

for i=1:length(MultiDayROIs_calls_IC)
    [meanDF_best_tones_IC{i},meanDF_best_IC{i},dayIdx_IC{i},ROIidx_days_IC{i}]=...
        pupCalls_getBestCallsTones(MultiDayROIs_calls_IC{i},...
        MultiDayROIs_tones_IC{i},allDates_calls_IC{i},allDates_tones_IC{i},dayCohoused_IC{i});
end

% concatenate responses and ROI indices across mice, days
meanDF_bestCalls_all_IC=cat(1,meanDF_best_IC{:});
meanDF_bestTones_all_IC=cat(1,meanDF_best_tones_IC{:});
ROIidx_days_all_IC=cat(1,ROIidx_days_IC{:});
dayIdx_all_IC=cat(1,dayIdx_IC{:});

ROIidx_fields_IC=[];
for d=1:length(paths_IC)
    idx=repmat(d,length(ROIidx_days_IC{d}),1);
    ROIidx_fields_IC=[ROIidx_fields_IC;idx];
end

%% for each mouse/imaging field, plot response amplitude day 1 vs last day
days_PS=unique(dayIdx_all_PS);

for a=1:length(MultiDayROIs_calls_PS)
    [maxCall,meanCall,maxTones,meanTones]=MultiDayROI_getBestResponses(MultiDayROIs_calls_PS{a},allDates_calls_PS{a},MultiDayROIs_tones_PS{a});

    maxCall_PS{a}=nan(size(maxCall,1),length(days_PS));
    meanCall_PS{a}=nan(size(maxCall,1),length(days_PS));
    maxTones_PS{a}=nan(size(maxCall,1),length(days_PS));
    meanTones_PS{a}=nan(size(maxCall,1),length(days_PS));
    days=unique(dayIdx_PS{a});

    for d=1:length(days)
        maxCall_PS{a}(:,days(d)+1)=maxCall(:,d);
        meanCall_PS{a}(:,days(d)+1)=meanCall(:,d);
        maxTones_PS{a}(:,days(d)+1)=maxTones(:,d);
        meanTones_PS{a}(:,days(d)+1)=meanTones(:,d);
    end
end

maxCall_PS=cat(1,maxCall_PS{:});
meanCall_PS=cat(1,meanCall_PS{:});
maxTones_PS=cat(1,maxTones_PS{:});
meanTones_PS=cat(1,meanTones_PS{:});

%% for each mouse/imaging field, plot response amplitude day 1 vs last day
days_IC=unique(dayIdx_all_IC);

for a=1:length(MultiDayROIs_calls_IC)
    [maxCall,meanCall,maxTones,meanTones]=MultiDayROI_getBestResponses(MultiDayROIs_calls_IC{a},allDates_calls_IC{a},MultiDayROIs_tones_IC{a});

    maxCall_IC{a}=nan(size(maxCall,1),length(days_IC));
    meanCall_IC{a}=nan(size(maxCall,1),length(days_IC));
    maxTones_IC{a}=nan(size(maxCall,1),length(days_IC));
    meanTones_IC{a}=nan(size(maxCall,1),length(days_IC));
    days=unique(dayIdx_IC{a});

    for d=1:length(days)
        maxCall_IC{a}(:,days(d)+1)=maxCall(:,d);
        meanCall_IC{a}(:,days(d)+1)=meanCall(:,d);
        maxTones_IC{a}(:,days(d)+1)=maxTones(:,d);
        meanTones_IC{a}(:,days(d)+1)=meanTones(:,d);
    end
end

maxCall_IC=cat(1,maxCall_IC{:});
meanCall_IC=cat(1,meanCall_IC{:});
maxTones_IC=cat(1,maxTones_IC{:});
meanTones_IC=cat(1,meanTones_IC{:});

%% make plots comparing each day to day 0

daysUse=intersect(days_IC,days_PS);

figCall=figure; hold on
figTone=figure; hold on
numPlots=length(daysUse)-1;
for d=1:numPlots
    figure(figCall);
    c(d)=subplot(1,numPlots,d); hold on
    plot(maxCall_IC(:,1),maxCall_IC(:,d+1),'go')
    plot(maxCall_PS(:,1),maxCall_PS(:,d+1),'ko')
    minPlot=min(min([maxCall_PS(:,1);maxCall_PS(:,d+1);maxCall_IC(:,1);maxCall_IC(:,d+1)]));
    maxPlot=max(max([maxCall_PS(:,1);maxCall_PS(:,d+1);maxCall_IC(:,1);maxCall_IC(:,d+1)]));
    plot([minPlot maxPlot],[minPlot maxPlot],'k:')
    xlabel('best call response, day 0')
    ylabel(['best call response, day ',num2str(d)])
    tmp=gca
    tmp.XLim=[minPlot maxPlot];
    tmp.YLim=[minPlot maxPlot];
    axis square

    figure(figTone); 
    t(d)=subplot(1,numPlots,d); hold on
    plot(maxTones_IC(:,1),maxTones_IC(:,d+1),'go')
    plot(maxTones_PS(:,1),maxTones_PS(:,d+1),'ko')
    minPlot=min(min([maxTones_PS(:,1);maxTones_PS(:,d+1);maxTones_IC(:,1);maxTones_IC(:,d+1)]));
    maxPlot=max(max([maxTones_PS(:,1);maxTones_PS(:,d+1);maxTones_IC(:,1);maxTones_IC(:,d+1)]));
    plot([minPlot maxPlot],[minPlot maxPlot],'k:')
    xlabel('best Tones response, day 0')
    ylabel(['best Tones response, day ',num2str(d)])
    tmp=gca
    tmp.XLim=[minPlot maxPlot];
    tmp.YLim=[minPlot maxPlot];
    axis square
end
linkaxes(c,'xy')
linkaxes(t,'xy')

%% PCA on responses shape/duration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% meanDF_best_10sec_all=cat(1,meanDF_best_10sec{:});

[PCs, SCORE, LATENT, TSQUARED, explained,mu] = pca(meanDF_bestCalls_all_IC);
figure; plot(cumsum(explained));
figure; imagesc(PCs')
colormap gray
cmap=brewermap(6,'Set2');
figure; hold on
timePlot=1:size(PCs,2);
timePlot=(timePlot/30)-2;
for i=1:5
    figure
    subplot(1,2,1)
    plot(timePlot,PCs(:,i))%,'color',cmap(i,:))
    title(['PC ',num2str(i)])
xlabel('time (s)')
    subplot(1,2,2)
    histogram(SCORE(:,i))
end
% legend

%% remove nans (placeholders for cells that weren't present on a given day)


meanDF_best_all=[meanDF_bestCalls_all_PS;meanDF_bestCalls_all_IC];
ROIidx_fields=[ROIidx_fields_PS;ROIidx_fields_IC];
dayIdx_allFields=[dayIdx_all_PS;dayIdx_all_IC];
projIdx=[repmat(1,length(dayIdx_all_PS),1);repmat(2,length(dayIdx_all_IC),1)];

nanIdx=sum(isnan(meanDF_best_all),2);
nanIdx=nanIdx>0;
meanDF_best_all=meanDF_best_all(~nanIdx,:);
ROIidx_fields=ROIidx_fields(~nanIdx);
dayIdx_allFields=dayIdx_allFields(~nanIdx);
projIdx=projIdx(~nanIdx);
%% do PCA
[PCs, SCORE, LATENT, TSQUARED, explained,mu] = pca(meanDF_best_all);
figure; plot(cumsum(explained));
figure; imagesc(PCs')
colormap gray
cmap=brewermap(6,'Set2');
figure; hold on
timePlot=1:size(PCs,2);
timePlot=(timePlot/30)-2;
for i=1:5
    figure
    subplot(1,2,1)
    plot(timePlot,PCs(:,i))%,'color',cmap(i,:))
    title(['PC ',num2str(i)])
xlabel('time (s)')
    subplot(1,2,2)
    histogram(SCORE(:,i))
end
% legend
%% sort best responses based on PC weights, plot as heatmap

% meanDF_best_all=[meanDF_bestCalls_all_PS;meanDF_bestCalls_all_IC];
for PC=1:4
    [sortedWeights,sortIDX]=sort(SCORE(:,PC),'descend');
%     sortIDX=sortIDX(~isnan(sortedWeights));
    sortedRs=meanDF_best_all(sortIDX,:);
    figure;
    imagesc(sortedRs,[-20 50])
    colormap gray
    title(['sorted by PC ',num2str(PC)])
end

%% find ROIs with biggest weights on first 10 PCs, plot RFs over days
    numCells=round(0.2*size(SCORE,1))
    

for PC=1:5
    % find top 10% of cells
    [weights,sortedWeightsIdx] = sort(SCORE(:,PC),'descend');
    nanWeight=isnan(weights);
    sortedWeightsIdx=sortedWeightsIdx(~nanWeight);

    % get response data from these cells for plotting
    fieldIDs=ROIidx_fields(sortedWeightsIdx(1:numCells)); % which field
    dayIDs=dayIdx_allFields(sortedWeightsIdx(1:numCells)); % which day
%     withinDayIDs=ROIidx_days_allFields(sortedWeightsIdx(1:numCells)); % which ROI
    projID=projIdx(sortedWeightsIdx(1:numCells)); % which projection
    figure;
    histogram(dayIDs)
    xlabel('day of imaging')
    ylabel('#of cells')
    title(['top 20% of cells, PC ',num2str(PC)])

    figure;
    histogram(projID)
    xlabel('projection')
    ylabel('#of cells')
    title(['top 20% of cells, PC ',num2str(PC)])

%     figure; 
%     histogram(fieldIDs)
%     xlabel('mouse')
%     ylabel('#of cells')
%     title(['top 20% of cells, PC ',num2str(PC)])

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

%% plot distributions of weights of each PCA by day of imaging

days=unique(dayIdx_allFields);
numDays=length(unique(dayIdx_allFields));
cmap=morgenstemning(numDays+3);
% cmap=flipud(cmap);
for p=1:5
    figure; hold on
    for f=1:length(days)
        idx=dayIdx_allFields==days(f);
    pl(f)=cdfplot(SCORE(idx,p));
    pl(f).Color=cmap(f,:);
    end
    title(['PC',num2str(p)])
    legend
end

%%
%% plot distributions of weights of each PCA by projection

days=unique(dayIdx_allFields);
numDays=length(unique(dayIdx_allFields));
cmap=morgenstemning(numDays+3);
cmap=brewermap(2,'Set2')
% cmap=flipud(cmap);
for p=1:5
    figure; hold on
    for f=1:2
        idx=projIdx==f;
    pl(f)=cdfplot(SCORE(idx,p));
    pl(f).Color=cmap(f,:);
    end
    title(['PC',num2str(p)])
    legend
end