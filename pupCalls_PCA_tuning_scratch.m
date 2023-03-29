%% load in multi-day ROI data
pupCalls_gcamp8_paths
paths_2p=paths_2p([1:3,5]);
matchFilePath=matchFilePath([1:3,5])
%% make multi-day ROI data structures

for a=1:length(paths_2p)
    [allDates_calls_10sec{a},allDates_calls_5sec{a},allDates_calls_2sec{a},...
    allDates_tones_5sec{a},allDates_tones_3sec{a},MultiDayROIs_calls_2sec{a},...
    MultiDayROIs_calls_5sec{a},MultiDayROIs_calls_10sec{a},...
    MultiDayROIs_tones_3sec{a}] = pupCall_multidayROIs_multiISI(matchFilePath{a},paths_2p{a});
    
    numROIs=length(MultiDayROIs_calls_5sec{a});
    numDays=size(MultiDayROIs_calls_5sec{a}(1).meanR,2);
    ROI_IDtmp=repmat(1:numROIs,numDays,1);
    ROI_IDtmp=ROI_IDtmp(:);

day_IDtmp=repmat(1:numDays,numROIs,1)';
day_IDtmp=day_IDtmp(:);
    ROI_ID{a}=ROI_IDtmp;
    day_ID{a}=day_IDtmp;
    field_ID{a}=repmat(a,size(day_IDtmp));
end

ROI_ID=cat(1,ROI_ID{:});
day_ID=cat(1,day_ID{:});
field_ID=cat(1,field_ID{:});
%% concatenate call tuning curves across ROIs

MultiDayROIs_calls=[MultiDayROIs_calls_5sec{:}];

allCalls=cat(2,MultiDayROIs_calls(:).meanCalls_Z);

% nanIdx=isnan(allCalls);
% nanIdx=logical(mean(nanIdx));
% callsUse=allCalls(:,~nanIdx);
[PCs, SCORE, LATENT, TSQUARED, explained,mu] = pca(allCalls');
figure; plot(cumsum(explained));
figure; imagesc(SCORE)
colormap gray
cmap=brewermap(6,'Set2');
figure; hold on
for i=1:6
    plot(PCs(:,i),'color',cmap(i,:))
end



%% plot distributions of weights of each PCA by day of imaging

numDays=4

cmap=brewermap(4,'Set3');
% cmap=flipud(cmap);
for p=1:6
    figure; hold on
    for f=1:numDays
        idx=day_ID==f;
    pl(f)=cdfplot(SCORE(idx,p));
    pl(f).Color=cmap(f,:);
    end
    title(['PC',num2str(p)])
    legend
end

%% 2d plots of each PC weights for each cell across days, colorcoded by field

for PC=1:6
figure; hold on
    
    for r=1:numROIs % plot a line for each ROI connected values across days
        tmp=plot(1:numDays,SCORE(ROI_ID==r,PC),'ko-');
        
    end
   
    
    title(['PC ',num2str(PC),' weights'])
    xlabel('day of imaging')
    ylabel('weight')
    
end
%% find ROIs with biggest weights on first 10 PCs, plot RFs over days

for PC=1:6
    % find top 5 cells
    [weights,sortedWeightsIdx] = sort(SCORE(:,PC),'descend');
    nanWeight=isnan(weights);
    sortedWeightsIdx=sortedWeightsIdx(~nanWeight)

    % get response data from these cells for plotting
    fieldIDs=field_ID(sortedWeightsIdx(1:10)); % which field
    dayIDs=day_ID(sortedWeightsIdx(1:10)); % which day
    withinDayIDs=ROI_ID(sortedWeightsIdx(1:10)); % which ROI

    fug=figure; hold on
    title(['PC ',num2str(PC),' weights'])
    xlabel('day')
    cmap=brewermap(7,'Set3')
    for r=1:10
%         plot_meanDF_multiday_single(allDates_tones_3sec{fieldIDs(r)},...
%             allDates_calls_10sec{fieldIDs(r)},MultiDayROIs_tones_3sec{fieldIDs(r)}, ...
%                 MultiDayROIs_calls_10sec{fieldIDs(r)},withinDayIDs(r));

        plot_meanDF_calls_multiISI_single(allDates_calls_10sec{fieldIDs(r)},...
            allDates_calls_5sec{fieldIDs(r)},allDates_calls_2sec{fieldIDs(r)},...
            MultiDayROIs_calls_2sec{fieldIDs(r)},MultiDayROIs_calls_5sec{fieldIDs(r)},...
            MultiDayROIs_calls_10sec{fieldIDs(r)},withinDayIDs(r));
        
        % get weights for this cell on this PC for each day of imaging

        thisROIIdx=field_ID==fieldIDs(r) & ROI_ID==withinDayIDs(r);    
        tmpweight=SCORE(thisROIIdx,PC);
        tmpdays=day_ID(thisROIIdx);
        ROIweights{r}=tmpweight(~isnan(tmpweight));
        ROIdays{r}=tmpdays(~isnan(tmpweight));
        figure(fug)
        plot(ROIdays{r},ROIweights{r},'o-','Color',cmap(fieldIDs(r),:))
    end
    
end
%%
daysByPC=zeros(size(SCORE,1),size(PCs,2));
for PC=1:6
    [~,sortIDX]=sort(SCORE(:,PC),'descend');
    figure; imagesc(SCORE(sortIDX,:))
    title(['sorted by PC ',num2str(PC)])
    colormap gray
    daysByPC(:,PC)=day_ID(sortIDX);
end

figure
image(daysByPC)
colormap prism