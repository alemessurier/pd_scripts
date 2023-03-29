%% compute and plot selectivity index for best call vs best tone in cells tracked over days
%% load in multi-day ROI data
pupCalls_gcamp8_paths

%% make multi-day ROI data structures

for a=1:length(paths_2p)
    [allDates_calls_10sec{a},allDates_calls_5sec{a},allDates_calls_2sec{a},...
        allDates_tones_5sec{a},allDates_tones_3sec{a},MultiDayROIs_calls_2sec{a},...
        MultiDayROIs_calls_5sec{a},MultiDayROIs_calls_10sec{a},...
        MultiDayROIs_tones_3sec{a},meanDF_best_2sec_all{a},...
        meanDF_best_5sec_all{a},meanDF_best_10sec_all{a},...
        meanDF_best_tones_all{a},ROIidx_days{a},dayIdx{a}]= pupCalls_loadMultiDayROIs_allMice(paths_2p{a},matchFilePath{a});
end
%% means over all trials

for a=1:length(paths_2p)
    pathsThisField=paths_2p{a};
    numDays=length(pathsThisField);
    callStruct=MultiDayROIs_calls_5sec{a};
    toneStruct=MultiDayROIs_tones_3sec{a};
    numROIs=length(callStruct);
    SIcallVtone=nan(numROIs,numDays);
    figure; hold on
    for r=1:numROIs

        for day=1:numDays

            if ~isempty(callStruct(r).meanByTrial{day})
                callTrials=cat(1,callStruct(r).meanByTrial{day}{:});
                meanCall=mean(callTrials);
                stdCall=std(callTrials);
                numTcalls=length(callTrials);

                toneTrials=cat(1,toneStruct(r).meanByTrial{day}{:});
                meanTone=mean(toneTrials);
                stdTone=std(toneTrials);
                numTtones=length(toneTrials);

                pooledSD=sqrt(((numTtones-1)*stdTone^2 + (numTcalls-1)*stdCall^2)/(numTcalls+numTtones-2));
                SIcallVtone(r,day)=(meanCall-meanTone)/pooledSD;
            else
            end
        end
       plot(1:numDays,SIcallVtone(r,:),'ko-')
    end
%      daysPlot=repmat(1:numDays,numROIs,1);
      figure; hold on
      subplot(1,2,1)
      plot(SIcallVtone(:,1),SIcallVtone(:,2),'ko')
      axis square
      ax=gca;
      ax.XLim=[-1 1];
      ax.YLim=[-1 1];
      subplot(1,2,2)
      plot(SIcallVtone(:,1),SIcallVtone(:,end),'ko')
       axis square
      ax=gca;
      ax.XLim=[-1 1];
      ax.YLim=[-1 1];

   SI_allfields{a}=SIcallVtone;     
end

%% plot day 1 selectivity vs day 2 selectivity

SIday1v2=cellfun(@(x)x(:,1:2),SI_allfields,'UniformOutput',0);
SIday1v2=cat(1,SIday1v2{:});
figure;
plot(SIday1v2(:,1),SIday1v2(:,2),'ko')
minplot=min(min(SIday1v2));
maxplot=max(max(SIday1v2));
ax=gca;
ax.XLim=[minplot -minplot];
ax.YLim=[minplot -minplot];
hold on;
plot([0,0],[minplot -minplot],'k:')
plot([minplot -minplot],[0,0],'k:')

%% plot day 1 selectivity vs last day selectivity

SIday1vlast=cellfun(@(x)x(:,[1 end]),SI_allfields,'UniformOutput',0);
SIday1vlast=cat(1,SIday1vlast{:});
figure;
plot(SIday1vlast(:,1),SIday1vlast(:,2),'ko')
minplot=min(min(SIday1vlast));
maxplot=max(max(SIday1vlast));
ax=gca;
ax.XLim=[minplot -minplot];
ax.YLim=[minplot -minplot];
hold on;
plot([0,0],[minplot -minplot],'k:')
plot([minplot -minplot],[0,0],'k:')

%% means over best call and tone trials

for a=1:length(paths_2p)
    pathsThisField=paths_2p{a};
    numDays=length(pathsThisField);
    callStruct=MultiDayROIs_calls_5sec{a};
    toneStruct=MultiDayROIs_tones_3sec{a};
    numROIs=length(callStruct);
    SIcallVtone_best=nan(numROIs,numDays);
    figure; hold on
    for r=1:numROIs

        for day=1:numDays

            if ~isempty(callStruct(r).meanByTrial{day})
                [~,bestCall]=max(callStruct(r).meanR(:,day))
                callTrials=callStruct(r).meanByTrial{day}{bestCall};
                meanCall=mean(callTrials);
                stdCall=std(callTrials);
                numTcalls=length(callTrials);
                
                [~,bestTone]=max(toneStruct(r).meanRTones(:,day))
                toneTrials=toneStruct(r).meanByTrial{day}{bestTone};
                meanTone=mean(toneTrials);
                stdTone=std(toneTrials);
                numTtones=length(toneTrials);

                pooledSD=sqrt(((numTtones-1)*stdTone^2 + (numTcalls-1)*stdCall^2)/(numTcalls+numTtones-2));
                SIcallVtone_best(r,day)=(meanCall-meanTone)/pooledSD;
            else
            end
        end
       plot(1:numDays,SIcallVtone_best(r,:),'ko-')
    end
%      daysPlot=repmat(1:numDays,numROIs,1);
      figure; hold on
      subplot(1,2,1)
      plot(SIcallVtone_best(:,1),SIcallVtone_best(:,2),'ko')
      axis square
%       ax=gca;
%       ax.XLim=[-1 1];
%       ax.YLim=[-1 1];
      subplot(1,2,2)
      plot(SIcallVtone_best(:,1),SIcallVtone_best(:,end),'ko')
       axis square
%       ax=gca;
%       ax.XLim=[-1 1];
%       ax.YLim=[-1 1];

   SI_allfields{a}=SIcallVtone_best;     
end

%% plot day 1 selectivity vs last day selectivity

SIday1vlast=cellfun(@(x)x(:,[1 end]),SI_allfields,'UniformOutput',0);
SIday1vlast=cat(1,SIday1vlast{:});
figure;
plot(SIday1vlast(:,1),SIday1vlast(:,2),'ko')
minplot=min(min(SIday1vlast));
maxplot=max(max(SIday1vlast));
ax=gca;
ax.XLim=[minplot -minplot];
ax.YLim=[minplot -minplot];
hold on;
plot([0,0],[minplot -minplot],'k:')
plot([minplot -minplot],[0,0],'k:')
