function [maxCall,meanCall,maxTones,meanTones]=MultiDayROI_getEarlyLateResponses(MultiDayROIs_calls,allDates_calls)
bestCalls=zeros(length(MultiDayROIs_calls), length(allDates_calls));
maxCall=bestCalls;
meanCall=maxCall;

bestTones=bestCalls;
maxTones=bestCalls;
meanTones=maxTones;
for r=1:length(MultiDayROIs_calls)
    [maxes,bc]=max(MultiDayROIs_calls(r).meanR);
    bc(isnan(maxes))=nan;
    bestCalls(r,:)=bc;
    maxCall(r,:)=maxes;
    meanCall(r,:)=mean(MultiDayROIs_calls(r).meanR);

    bestCallEarly

    [maxes,bc]=max(MultiDayROIs_tones(r).meanRTones);
    bc(isnan(maxes))=nan;
    bestTones(r,:)=bc;
    maxTones(r,:)=maxes;
    meanTones(r,:)=mean(MultiDayROIs_tones(r).meanRTones);
end

%% compare first and last day

figure; hold on
plot(meanCall(:,1),meanCall(:,size(meanCall,2)),'ko')
minPlot=min(min(meanCall));
maxPlot=max(max(meanCall));
plot([minPlot maxPlot],[minPlot maxPlot],'k:')
xlabel('mean call response, day 0')
ylabel('mean call response, last day')
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


