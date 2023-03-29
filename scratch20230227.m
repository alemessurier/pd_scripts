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

%% for each mouse/imaging field, plot response amplitude day 1 vs last day
for a=1:length(MultiDayROIs_calls_10sec)
[maxCall{a},meanCall{a},maxTones{a},meanTones{a}]=MultiDayROI_getBestResponses(MultiDayROIs_calls_10sec{a},allDates_calls_5sec{a},MultiDayROIs_tones_3sec{a});
end
%% compare first and last day (calls)

% concatenate ROIs across mice
maxCallDay1=cellfun(@(x)x(:,1),maxCall,'un',0);
maxCallEnd=cellfun(@(x)x(:,size(x,2)),maxCall,'un',0);

maxCallDay1=cat(1,maxCallDay1{:});
maxCallEnd=cat(1,maxCallEnd{:});

figure; hold on
plot(maxCallDay1,maxCallEnd,'ko')
minPlot=min(min([maxCallDay1;maxCallEnd]));
maxPlot=max(max([maxCallDay1;maxCallEnd]));
plot([minPlot maxPlot],[minPlot maxPlot],'k:')
xlabel('best call response, day 0')
ylabel('best call response, last day')
tmp=gca
tmp.XLim=[minPlot maxPlot];
tmp.YLim=[minPlot maxPlot];
axis square

%% compare first and last day (tones)

% concatenate ROIs across mice
maxTonesDay1=cellfun(@(x)x(:,1),maxTones,'un',0);
maxTonesEnd=cellfun(@(x)x(:,size(x,2)),maxTones,'un',0);

maxTonesDay1=cat(1,maxTonesDay1{:});
maxTonesEnd=cat(1,maxTonesEnd{:});

figure; hold on
plot(maxTonesDay1,maxTonesEnd,'ko')
minPlot=min(min([maxTonesDay1;maxTonesEnd]));
maxPlot=max(max([maxTonesDay1;maxTonesEnd]));
plot([minPlot maxPlot],[minPlot maxPlot],'k:')
xlabel('best Tones response, day 0')
ylabel('best Tones response, last day')
tmp=gca
tmp.XLim=[minPlot maxPlot];
tmp.YLim=[minPlot maxPlot];
axis square
%%
figure; hold on
plot(meanTones(:,1),meanTones(:,size(meanTones,2)),'ko')
minPlot=min(min(meanTones));
maxPlot=max(max(meanTones));
plot([minPlot maxPlot],[minPlot maxPlot],'k:')
xlabel('mean Tones response, day 0')
ylabel('mean Tones response, last day')
tmp=gca
tmp.XLim=[minPlot maxPlot];
tmp.YLim=[minPlot maxPlot];
axis square

figure; hold on
plot(meanTones(:,1),meanTones(:,size(meanTones,2)),'ko')
minPlot=min(min(meanTones));
maxPlot=max(max(meanTones));
plot([minPlot maxPlot],[minPlot maxPlot],'k:')
xlabel('mean tone response, day 0')
ylabel('mean tone response, last day')
tmp=gca
tmp.XLim=[minPlot maxPlot];
tmp.YLim=[minPlot maxPlot];
axis square

figure; hold on
plot(maxCall(:,1),maxCall(:,size(maxCall,2)),'ko')
minPlot=min(min(maxCall));
maxPlot=max(max(maxCall));
plot([minPlot maxPlot],[minPlot maxPlot],'k:')
xlabel('best call response, day 0')
ylabel('best call response, last day')
tmp=gca
tmp.XLim=[minPlot maxPlot];
tmp.YLim=[minPlot maxPlot];
axis square

figure; hold on
plot(maxTones(:,1),maxTones(:,size(maxTones,2)),'ko')
minPlot=min(min(maxTones));
maxPlot=max(max(maxTones));
plot([minPlot maxPlot],[minPlot maxPlot],'k:')
xlabel('best tone response, day 0')
ylabel('best tone response, last day')
tmp=gca
tmp.XLim=[minPlot maxPlot];
tmp.YLim=[minPlot maxPlot];
axis square

%% get early and late responses across all ROIs best df/f

meanEarly=mean(meanDF_best_5sec_allFields(:,61:120),2);
meanLate=mean(meanDF_best_5sec_allFields(:,120:210),2);

meanEarly_day1=meanEarly(dayIdx_allFields==1);
meanEarly_day2=meanEarly(dayIdx_allFields==2);
meanEarly_day3=meanEarly(dayIdx_allFields==3);
meanEarly_day4=meanEarly(dayIdx_allFields==4);

meanLate_day1=meanLate(dayIdx_allFields==1);
meanLate_day2=meanLate(dayIdx_allFields==2);
meanLate_day3=meanLate(dayIdx_allFields==3);
meanLate_day4=meanLate(dayIdx_allFields==4);


%%
    figure; hold on
    cmap=brewermap(4,'Set3');
   pl(1)=cdfplot(meanEarly_day1);
    pl(1).Color=cmap(1,:);
   pl(2)=cdfplot(meanEarly_day2);
    pl(2).Color=cmap(2,:);
   pl(3)=cdfplot(meanEarly_day3);
    pl(3).Color=cmap(3,:);
   pl(4)=cdfplot(meanEarly_day4);
    pl(4).Color=cmap(4,:);
  title('early')  
legend
  figure; hold on
    
   pl(1)=cdfplot(meanLate_day1);
    pl(1).Color=cmap(1,:);
   pl(2)=cdfplot(meanLate_day2);
    pl(2).Color=cmap(2,:);
   pl(3)=cdfplot(meanLate_day3);
    pl(3).Color=cmap(3,:);
   pl(4)=cdfplot(meanLate_day4);
    pl(4).Color=cmap(4,:);
  title('Late')
  legend