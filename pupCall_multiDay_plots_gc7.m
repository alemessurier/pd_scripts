%% plot tuning from one day
pupCalls_plotTuning(allDates_calls(1).dFByTrial,allDates_calls(1).h_calls,30)
%%
[F_calls,~,ops]=load2p_data_pupcalls(paths_2p{1});

pupCalls_plotAllTrials_ordered(F_calls,ops,3,151,2,5)

%% get best response for each ROI, sort by first day

% preallocate arrays w/zeros
meanDF_tmp={zeros(length(MultiDayROIs_calls),size(allDates_calls(1).dFByTrial{1},2))};
meanDF_best_calls=repmat(meanDF_tmp,1,length(allDates_calls));


meanDF_tmp={zeros(length(MultiDayROIs_calls),size(allDates_tones(1).dFByTone{1},2))};
meanDF_best_tones=repmat(meanDF_tmp,1,length(allDates_calls));


for r=1:length(MultiDayROIs_calls)
    for d=1:length(allDates_calls)
      

        % 5sec
        [bestR_callsTmp,idx_best]=max(MultiDayROIs_calls(r).meanR(:,d));
        if ~isnan(bestR_callsTmp)
            meanDF_best_calls{d}(r,:)=MultiDayROIs_calls(r).meanResponsesCalls{d}(idx_best,:);

        end
        bestR_calls{d}(r)=bestR_callsTmp;
        idx_best_calls{d}(r)=idx_best;

       

        % 5on3w
        [bestR_tonesTmp,idx_best]=max(MultiDayROIs_tones(r).meanRTones(:,d));
        if ~isnan(bestR_tonesTmp)
            meanDF_best_tones{d}(r,:)=MultiDayROIs_tones(r).meanResponsesTones{d}(idx_best,:);
        end
        bestR_tones{d}(r)=bestR_tonesTmp;
        idx_best_tones{d}(r)=idx_best;
    end
end

%% find best tone on each day

figure; hold on
for d=1:length(allDates_tones)
    subplot(2,length(allDates_tones),d)
    include_idx=~isnan(bestR_tones{d});
    histogram(idx_best_tones{d}(include_idx))
    tmp=gca;
    tmp.XTick=1:length(allDates_tones(d).tones);
    tmp.XTickLabel= [];
    title(['day ',num2str(d)])
    ylabel('# cells')
%     tmp.XTickLabelRotation=45;

    meanR_tone_all=nanmean(allDates_tones(d).meanRTones);
    semR_tone_all=nanstd(allDates_tones(d).meanRTones)/sqrt(sum(include_idx));
    subplot(2,length(allDates_tones),d+length(allDates_tones))
    shadedErrorBar(1:length(allDates_tones(d).tones),meanR_tone_all,semR_tone_all,'k-')
    tmp=gca;
    tmp.XTick=1:length(allDates_tones(d).tones);
    tmp.XTickLabel= allDates_tones(d).tones;
    tmp.XTickLabelRotation=45;
    ylabel('mean dF/F')

end
%% choose white and black level for heatmaps

allvals=[meanDF_best_calls{:},meanDF_best_tones{:}];
figure
histogram(allvals(:))
%% plot best responses for each cell on each day to each stimulus

% sort by
[chk,idx_sort]=sort(bestR_calls{1},'descend');
clim=[-10 20];
fig=figure; hold on
for d=1:length(allDates_tones)
    subplot(2,length(allDates_tones),d)
  imagesc(meanDF_best_calls{d}(idx_sort,:),clim)
    colormap gray
    axis square
    title(['day ',num2str(d)]);
    ylabel('calls')

    subplot(2,length(allDates_tones),d+length(allDates_tones))
    imagesc(meanDF_best_tones{d}(idx_sort,:),clim)
    colormap gray
    axis square
    % title(['day ',num2str(d)]);
    ylabel('tones')
end