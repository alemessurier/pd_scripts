function [meanDF_best_tones_all,meanDF_best_all,dayIdx,ROIidx_days]=pupCalls_getBestCallsTones(MultiDayROIs_calls,MultiDayROIs_tones,allDates_calls,allDates_tones,daysCohoused)
%% get best response for each ROI, sort by first day

% preallocate arrays w/zeros
meanDF_tmp={nan(length(MultiDayROIs_calls),size(allDates_calls(1).dFByTrial{1},2))};
meanDF_best=repmat(meanDF_tmp,1,length(allDates_calls));


meanDF_tmp={nan(length(MultiDayROIs_calls),size(allDates_tones(1).dFByTone{1},2))};
meanDF_best_tones=repmat(meanDF_tmp,1,length(allDates_calls));


for r=1:length(MultiDayROIs_calls)
    for d=1:length(allDates_calls)
      
        % 5sec
        [bestRTmp,idx_best]=max(MultiDayROIs_calls(r).meanR(:,d));
        if ~isnan(bestRTmp)
            meanDF_best{d}(r,:)=MultiDayROIs_calls(r).meanResponsesCalls{d}(idx_best,:);

        end
%         bestR{d}(r)=bestRTmp;
%         idx_best{d}(r)=idx_best;

       
        % 5on3w
        [bestR_tonesTmp,idx_best]=max(MultiDayROIs_tones(r).meanRTones(:,d));
        if ~isnan(bestR_tonesTmp)
            meanDF_best_tones{d}(r,:)=MultiDayROIs_tones(r).meanResponsesTones{d}(idx_best,:);
        end
%         bestR_tones{d}(r)=bestR_tonesTmp;
%         idx_best_tones{d}(r)=idx_best;
    end
end
meanDF_best_tones_all=cat(1,meanDF_best_tones{:}); % combine across days
meanDF_best_all=cat(1,meanDF_best{:}); % combine across days

ROIidx_days=repmat((1:length(MultiDayROIs_calls))',d,1); % index of ROI identities
dayIdx=[];
for d=1:length(allDates_tones)
    idx=repmat(daysCohoused(d),length(MultiDayROIs_calls),1);
    dayIdx=[dayIdx;idx];
end