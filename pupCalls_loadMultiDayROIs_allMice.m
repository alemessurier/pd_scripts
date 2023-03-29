%% loads in data from all mice
%%
function [allDates_calls_10sec,allDates_calls_5sec,allDates_calls_2sec,...
    allDates_tones_5sec,allDates_tones_3sec,MultiDayROIs_calls_2sec,...
    MultiDayROIs_calls_5sec,MultiDayROIs_calls_10sec,...
    MultiDayROIs_tones_3sec, meanDF_best_2sec_all,meanDF_best_5sec_all,...
    meanDF_best_10sec_all,meanDF_best_tones_all,ROIidx_days,dayIdx]...
    =pupCalls_loadMultiDayROIs_allMice(paths_2p,matchFilePath)

%% load in multi-day ROI data

[allDates_calls_10sec,allDates_calls_5sec,allDates_calls_2sec,...
    allDates_tones_5sec,allDates_tones_3sec,MultiDayROIs_calls_2sec,...
    MultiDayROIs_calls_5sec,MultiDayROIs_calls_10sec,...
    MultiDayROIs_tones_3sec]= pupCall_multidayROIs_multiISI(matchFilePath,paths_2p);
%%
%% get best response for each ROI, sort by first day

% preallocate arrays w/zeros
meanDF_tmp={nan(length(MultiDayROIs_calls_5sec),size(allDates_calls_5sec(1).dFByTrial{1},2))};
meanDF_best_5sec=repmat(meanDF_tmp,1,length(allDates_calls_5sec));

meanDF_tmp={nan(length(MultiDayROIs_calls_5sec),size(allDates_calls_10sec(1).dFByTrial{1},2))};
meanDF_best_10sec=repmat(meanDF_tmp,1,length(allDates_calls_5sec));

if isempty(allDates_calls_2sec(end).dFByTrial)
    meanDF_tmp={nan(length(MultiDayROIs_calls_5sec),91)};
else
meanDF_tmp={nan(length(MultiDayROIs_calls_5sec),size(allDates_calls_2sec(end).dFByTrial{1},2))};
end
meanDF_best_2sec=repmat(meanDF_tmp,1,length(allDates_calls_5sec));

meanDF_tmp={nan(length(MultiDayROIs_calls_5sec),size(allDates_tones_3sec(1).dFByTone{1},2))};
meanDF_best_tones=repmat(meanDF_tmp,1,length(allDates_calls_5sec));


for r=1:length(MultiDayROIs_calls_5sec)
    for d=1:length(allDates_calls_5sec)
       % 2sec
        [bestR_2secTmp,idx_best]=max(MultiDayROIs_calls_2sec(r).meanR(:,d));
        if ~isnan(bestR_2secTmp)
            meanDF_best_2sec{d}(r,:)=MultiDayROIs_calls_2sec(r).meanResponsesCalls{d}(idx_best,:);

        end
        bestR_2sec{d}(r)=bestR_2secTmp;
        idx_best_2sec{d}(r)=idx_best;

        % 5sec
        [bestR_5secTmp,idx_best]=max(MultiDayROIs_calls_5sec(r).meanR(:,d));
        if ~isnan(bestR_5secTmp)
            meanDF_best_5sec{d}(r,:)=MultiDayROIs_calls_5sec(r).meanResponsesCalls{d}(idx_best,:);

        end
        bestR_5sec{d}(r)=bestR_5secTmp;
        idx_best_5sec{d}(r)=idx_best;

        % 10sec
        [bestR_10secTmp,idx_best]=max(MultiDayROIs_calls_10sec(r).meanR(:,d));
        if ~isnan(bestR_10secTmp)
            meanDF_best_10sec{d}(r,:)=MultiDayROIs_calls_10sec(r).meanResponsesCalls{d}(idx_best,:);

        end
        bestR_10sec{d}(r)=bestR_10secTmp;
        idx_best_10sec{d}(r)=idx_best;

        % 5on3w
        [bestR_tonesTmp,idx_best]=max(MultiDayROIs_tones_3sec(r).meanRTones(:,d));
        if ~isnan(bestR_tonesTmp)
            meanDF_best_tones{d}(r,:)=MultiDayROIs_tones_3sec(r).meanResponsesTones{d}(idx_best,:);
        end
        bestR_tones{d}(r)=bestR_tonesTmp;
        idx_best_tones{d}(r)=idx_best;
    end
end
meanDF_best_tones_all=cat(1,meanDF_best_tones{:}); % combine across days
meanDF_best_5sec_all=cat(1,meanDF_best_5sec{:}); % combine across days
meanDF_best_10sec_all=cat(1,meanDF_best_10sec{:}); % combine across days
meanDF_best_2sec_all=cat(1,meanDF_best_2sec{:}); % combine across days

ROIidx_days=repmat((1:length(MultiDayROIs_calls_5sec))',d,1); % index of ROI identities
dayIdx=[];
for d=1:length(allDates_tones_5sec)
    idx=repmat(d,length(MultiDayROIs_calls_5sec),1);
    dayIdx=[dayIdx;idx];
end