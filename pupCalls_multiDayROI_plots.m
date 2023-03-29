

fsidx=strfind(matchFilePath,'/');
save_path=matchFilePath(1:fsidx(end));
load([save_path,'MultiDayROIs.mat'])
%%
allDates_calls=allDates_calls_5sec;
MultiDayROIs_calls=MultiDayROIs_calls_5sec;
MultiDayROIs_tones=MultiDayROIs_tones_3sec;
allDates_tones=allDates_tones_3sec;

%% plot tuning across days for each tracked neuron
plot_meanDF_multiday(allDates_tones,allDates_calls,MultiDayROIs_tones,MultiDayROIs_calls)
%% plot tuning from one day - calls
pupCalls_plotTuning(allDates_calls(1).dFByTrial,allDates_calls(1).h_calls,30)
%% plot tuning from one day - tones
pupCalls_plotTuning_tones(allDates_tones(3).dFByTone,allDates_tones(3).tones,allDates_tones(3).h_tone);
%%
% [F_calls,~,ops]=load2p_data_pupcalls(paths_2p{1});
[F_calls_2sec,F_calls_5sec,F_calls_10sec,~,~,ops]=load2p_data_pupcalls_multiISI_spks(paths_IC{3});
% pupCalls_plotAllTrials_ordered(F_calls_10sec,ops,3,301,3,10)
pupCalls_plotAllTrials_ordered(F_calls_5sec,ops,3,151,2,5)
%% plot Zscored mean responses across days (colormap days)

cmap=cool(length(allDates_calls));
for r=1:length(MultiDayROIs_calls)
    fig=figure; hold on
    fig.Position=[71 72 378 581];
    annotation('textbox',[0.05 0.9 0.2 0.1],'String',['ROI ',num2str(r)],'EdgeColor','none');

    for d=1:length(allDates_calls)
        tones=allDates_tones_3sec(d).tones;
        subplot(2,1,1)
        hold on
        plot(1:6,MultiDayROIs_calls(r).meanCalls_Z(:,d),'-o','color',cmap(d,:))
        title('mean response, total')
        xlabel('calls')
        ylabel('Z-scored mean dF/F')

        subplot(2,1,2)
        hold on
        plot(1:length(tones),MultiDayROIs_tones(r).meanTones_Z(:,d),'-o','color',cmap(d,:))
        title('mean response, tones')
        xlabel('days')
        ylabel('Z-scored mean dF/F')
        tmp=gca;
        tmp.XTick=1:length(tones);
        tmp.XTickLabel=tones;
        %         legend(daylabels)
    end
end

%% plot mean responses to calls/tones as heatmaps

for r=1:length(MultiDayROIs_calls)
    figure; hold on
    for d=1:length(allDates_calls)
        subplot(2,length(allDates_calls),d)
        imagesc(MultiDayROIs_calls(r).meanResponsesCalls{d})
        colormap gray
        axis square

        subplot(2,length(allDates_calls),d+length(allDates_calls))
        imagesc(MultiDayROIs_tones(r).meanResponsesTones{d});
        colormap gray
        axis square


    end
end

%% plot mean responses to calls/tones as heatmaps

for r=1:length(MultiDayROIs_calls)
    fig=figure; hold on
     fig.Position=[344 17 857 781];
    for d=1:length(allDates_calls)
        subplot(4,length(allDates_calls),d)
        imagesc(MultiDayROIs_calls_2sec(r).meanResponsesCalls{d})
        colormap gray
        axis square

        subplot(4,length(allDates_calls),d+length(allDates_calls))
        imagesc(MultiDayROIs_calls_5sec(r).meanResponsesCalls{d})
        colormap gray
        axis square

        subplot(4,length(allDates_calls),d+2*length(allDates_calls))
        imagesc(MultiDayROIs_calls_10sec(r).meanResponsesCalls{d})
        colormap gray
        axis square

        subplot(4,length(allDates_calls),d+3*length(allDates_calls))
        imagesc(MultiDayROIs_tones(r).meanResponsesTones{d});
        colormap gray
        axis square


    end
end

%% get best response for each ROI, sort by first day

% preallocate arrays w/zeros
meanDF_tmp={zeros(length(MultiDayROIs_calls),size(allDates_calls_5sec(1).dFByTrial{1},2))};
meanDF_best_5sec=repmat(meanDF_tmp,1,length(allDates_calls));

meanDF_tmp={zeros(length(MultiDayROIs_calls),size(allDates_calls_10sec(1).dFByTrial{1},2))};
meanDF_best_10sec=repmat(meanDF_tmp,1,length(allDates_calls));

if isempty(allDates_calls_2sec(end).dFByTrial)
    meanDF_tmp={zeros(length(MultiDayROIs_calls),91)};
else
meanDF_tmp={zeros(length(MultiDayROIs_calls),size(allDates_calls_2sec(end).dFByTrial{1},2))};
end
meanDF_best_2sec=repmat(meanDF_tmp,1,length(allDates_calls));

meanDF_tmp={zeros(length(MultiDayROIs_calls),size(allDates_tones_3sec(1).dFByTone{1},2))};
meanDF_best_tones=repmat(meanDF_tmp,1,length(allDates_calls));


for r=1:length(MultiDayROIs_calls)
    for d=1:length(allDates_calls)
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

allvals=[meanDF_best_10sec{:},meanDF_best_5sec{:},meanDF_best_2sec{:},meanDF_best_tones{:}];
figure
histogram(allvals(:))
%% plot best responses for each cell on each day to each stimulus

% sort by
[chk,idx_sort]=sort(bestR_5sec{1},'descend');
clim=[-10 20];
fig=figure; hold on
for d=1:length(allDates_tones)
    subplot(4,length(allDates_tones),d)
  imagesc(meanDF_best_2sec{d}(idx_sort,:),clim)
    colormap gray
    axis square
    title(['day ',num2str(d)]);
    ylabel('2 sec ISI calls')

    subplot(4,length(allDates_tones),d+length(allDates_tones))
     imagesc(meanDF_best_5sec{d}(idx_sort,:),clim)
    colormap gray
    axis square
    % title(['day ',num2str(d)]);
    ylabel('5 sec ISI calls')

    subplot(4,length(allDates_tones),d+2*length(allDates_tones))
    imagesc(meanDF_best_10sec{d}(idx_sort,:),clim)
    colormap gray
    axis square
    % title(['day ',num2str(d)]);
    ylabel('10 sec ISI calls')

    subplot(4,length(allDates_tones),d+3*length(allDates_tones))
    imagesc(meanDF_best_tones{d}(idx_sort,:),clim)
    colormap gray
    axis square
    % title(['day ',num2str(d)]);
    ylabel('tones')
end
%% plot best responses for each cell on each day to each stimulus

% sort by
[chk,idx_sort]=sort(bestR_5sec{3},'descend');
clim=[-10 20];
fig=figure; hold on
for d=1:length(allDates_tones)
   

    subplot(1,length(allDates_tones),d)
     imagesc(meanDF_best_5sec{d}(idx_sort,:),clim)
    colormap gray
    axis square
    % title(['day ',num2str(d)]);
    ylabel('5 sec ISI calls')

end
%% plot mean responses across days (colormap days)

cmap=cool(length(allDates_calls));
for r=1:length(MultiDayROIs_calls)
    fig=figure; hold on
    fig.Position=[71 72 378 581];
    annotation('textbox',[0.05 0.9 0.2 0.1],'String',['ROI ',num2str(r)],'EdgeColor','none');

    for d=1:length(allDates_calls)
        tones=allDates_tones(d).tones;

        %         subplot(1,4,1)
        %         hold on
        %         plot(1:6,MultiDayROIs(r).meanEarly(:,d),'-o','color',cmap(d,:))
        %         title('mean response, early')
        %         xlabel('calls')
        %         ylabel('mean dF/F')
        %
        %         subplot(1,4,2)
        %         hold on
        %         plot(1:6,MultiDayROIs(r).meanLate(:,d),'-o','color',cmap(d,:))
        %         title('mean response, late')
        %         xlabel('calls')
        %         ylabel('mean dF/F')

        subplot(2,1,1)
        hold on
        shadedErrorBar(1:6,MultiDayROIs_calls(r).meanR(:,d),MultiDayROIs_calls(r).semR(:,d),{'-o','color',cmap(d,:)},1)
        title('mean response, total')
        xlabel('calls')
        ylabel('mean dF/F')

        subplot(2,1,2)
        hold on
        shadedErrorBar(1:length(tones),MultiDayROIs_tones(r).meanRTones(:,d),MultiDayROIs_tones(r).semRTones(:,d),{'-o','color',cmap(d,:)},1)
        title('mean response, tones')
        xlabel('days')
        ylabel('mean dF/F')
        tmp=gca;
        tmp.XTick=1:length(tones);
        tmp.XTickLabel=tones;
        %         legend(daylabels
    end
end

%% plot meanDF_total over days

meanDF_total_calls=cat(1,MultiDayROIs_calls(:).meanDF_total_calls);
meanDF_total_tones=cat(1,MultiDayROIs_tones(:).meanDF_total_tones);

figure; hold on
plot(1:length(allDates_calls),meanDF_total_calls,'o-')
title('calls')

figure; hold on
plot(1:length(allDates_tones),meanDF_total_tones,'o-')
title('tones')


figure; hold on
plotSpread(meanDF_total_calls,[],[],[],4)
title('mean dF/F during call blocks')
tmp=gca;
tmp.XTickLabel=0:length(allDates)-1;
xlabel('days of cohousing')
ylabel('mean dF/F')

figure; hold on
plotSpread(meanDF_total_tones,[],[],[],4)
title('mean dF/F during tone blocks')
tmp=gca;
tmp.XTickLabel=0:length(allDates)-1;
xlabel('days of cohousing')
ylabel('mean dF/F')

daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates)-1,'un',0);
cmap=morgenstemning(length(allDates)+1);
figure; hold on
for i=1:length(allDates)
    tmp=cdfplot(meanDF_total_tones(:,i));
    tmp.Color=cmap(i,:)
end
legend(daylabels);
xlabel('mean dF/F, tone blocks')
ylabel('fraction of ROIs')
title('mean dF/F during tone blocks')

daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates)-1,'un',0);
cmap=morgenstemning(length(allDates)+1);
figure; hold on
for i=1:length(allDates)
    tmp=cdfplot(meanDF_total_calls(:,i));
    tmp.Color=cmap(i,:)
end
legend(daylabels);
xlabel('mean dF/F, call blocks')
ylabel('fraction of ROIs')
title('mean dF/F during call blocks')


%% number of response-evoking calls and tones by day

responsive_calls=cat(1,MultiDayROIs(:).h_calls);
responsive_tones=cat(1,MultiDayROIs(:).h_tones);

figure; hold on
plot(1:length(allDates),responsive_calls,'o-')
title('calls')

figure; hold on
plot(1:length(allDates),responsive_tones,'o-')
title('tones')

%% look at best responses over days, best call

bestCalls=zeros(length(MultiDayROIs_calls), length(allDates_calls));
maxResponse=bestCalls;
meanCall=maxResponse;

bestTones=bestCalls;
maxTones=bestCalls;
meanTones=maxTones;
for r=1:length(MultiDayROIs_calls)
    [maxes,bc]=max(MultiDayROIs_calls(r).meanR);
    bc(isnan(maxes))=nan;
    bestCalls(r,:)=bc;
    maxResponse(r,:)=maxes;
    meanCall(r,:)=mean(MultiDayROIs_calls(r).meanR);

    [maxes,bc]=max(MultiDayROIs_tones(r).meanRTones);
    bc(isnan(maxes))=nan;
    bestTones(r,:)=bc;
    maxTones(r,:)=maxes;
    meanTones(r,:)=mean(MultiDayROIs_tones(r).meanRTones);
end

figure; hold on
plot(1:length(allDates),maxResponse,'-')
title('max call response')
xlabel('days')

figure; hold on
plot(1:length(allDates),bestCalls,'-')
title('best call')
xlabel('days')

figure; hold on
plot(1:length(allDates),maxTones,'-')
title('best tone response')
xlabel('days')

figure; hold on
plot(1:length(allDates),bestTones,'-')
title('best tone')
xlabel('days')
ylabel('tones')
tmp=gca;
tmp.YTickLabel=tones;

figure; hold on
plot(1:length(allDates),meanCall,'-')
title('mean call response')
xlabel('days')

figure; hold on
plot(1:length(allDates),meanTones,'-')
title('mean tone response')
xlabel('days')

%% swarm plots of max responses over days

figure;
plotSpread(maxResponse,[],[],[],4);
title('response to best call')
xlabel('day of cohousing')
ylabel('mean dF/F')
tmp=gca;
tmp.XTickLabel=0:(length(allDates)-1)

figure;
plotSpread(maxTones,[],[],[],4);
title('response to best tone')
xlabel('day of cohousing')
ylabel('mean dF/F')
tmp=gca;
tmp.XTickLabel=0:(length(allDates)-1);

figure;
plotSpread(meanCall,[],[],[],4);
title('mean call response')
xlabel('day of cohousing')
ylabel('mean dF/F')
tmp=gca;
tmp.XTickLabel=0:(length(allDates)-1);

figure;
plotSpread(meanTones,[],[],[],4);
title('mean tone response')
xlabel('day of cohousing')
ylabel('mean dF/F')
tmp=gca;
tmp.XTickLabel=0:(length(allDates)-1);

daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates)-1,'un',0);
cmap=morgenstemning(length(allDates)+1);
figure; hold on
for i=1:length(allDates)
    tmp=cdfplot(meanCall(:,i));
    tmp.Color=cmap(i,:);
end
legend(daylabels);
xlabel('mean dF/F')
ylabel('fraction of ROIs')
title('mean call response')

cmap=morgenstemning(length(allDates)+1);
figure; hold on
for i=1:length(allDates)
    tmp=cdfplot(meanTones(:,i));
    tmp.Color=cmap(i,:);
end
legend(daylabels);
xlabel('mean dF/F')
ylabel('fraction of ROIs')
title('mean Tone response')

cmap=morgenstemning(length(allDates)+1);
figure; hold on
for i=1:length(allDates)
    tmp=cdfplot(maxResponse(:,i));
    tmp.Color=cmap(i,:);
end
legend(daylabels);
xlabel('mean dF/F')
ylabel('fraction of ROIs')
title('max call response')

cmap=morgenstemning(length(allDates)+1);
figure; hold on
for i=1:length(allDates)
    tmp=cdfplot(maxTones(:,i));
    tmp.Color=cmap(i,:);
end
legend(daylabels);
xlabel('mean dF/F')
ylabel('fraction of ROIs')
title('max Tone response')

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
plot(maxResponse(:,1),maxResponse(:,size(maxResponse,2)),'ko')
minPlot=min(min(maxResponse));
maxPlot=max(max(maxResponse));
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

%% calculate correlations across days for tone tuning, call tuning for each ROI

allCombs=nchoosek(1:length(allDates),2);

meanCorrEarly=zeros(length(MultiDayROIs),1);
meanCorrLate=meanCorrEarly;
meanCorrCalls=meanCorrEarly;
meanCorrTones=meanCorrCalls;

% shuffled
shuffCorrEarly=zeros(length(MultiDayROIs),1);
shuffCorrLate=shuffCorrEarly;
shuffCorrCalls=shuffCorrEarly;
shuffCorrTones=shuffCorrCalls;

% loop through ROIs
for r=1:length(MultiDayROIs)
    % preallocate vectors of correlations for each combo
    corrEarly=zeros(size(allCombs,1),1);
    corrLate=corrEarly;
    corrR=corrEarly;
    corrTones=corrEarly;

    shuffEarly=zeros(size(allCombs,1),1);
    shuffLate=shuffEarly;
    shuffR=shuffEarly;
    shuffTones=shuffEarly;

    % loop through combos
    for comb=1:size(allCombs,1)

        early1=MultiDayROIs(r).meanEarly(:,allCombs(comb,1));
        early2=MultiDayROIs(r).meanEarly(:,allCombs(comb,2));
        corrTmp=corrcoef(early1,early2);
        corrEarly(comb)=corrTmp(2);

        late1=MultiDayROIs(r).meanLate(:,allCombs(comb,1));
        late2=MultiDayROIs(r).meanLate(:,allCombs(comb,2));
        corrTmp=corrcoef(late2,late1);
        corrLate(comb)=corrTmp(2);

        calls1=MultiDayROIs(r).meanR(:,allCombs(comb,1));
        calls2=MultiDayROIs(r).meanR(:,allCombs(comb,2));
        corrTmp=corrcoef(calls2,calls1);
        corrR(comb)=corrTmp(2);

        tones1=MultiDayROIs(r).meanRTones(:,allCombs(comb,1));
        tones2=MultiDayROIs(r).meanRTones(:,allCombs(comb,2));
        corrTmp=corrcoef(tones2,tones1);
        corrTones(comb)=corrTmp(2);

        % shuffled correlations
        shuffEarly2=early2(randperm(length(early2)));
        corrTmp=corrcoef(early1,shuffEarly2);
        shuffEarly(comb)=corrTmp(2);

        shuffLate2=late2(randperm(length(late2)));
        corrTmp=corrcoef(late1,shuffLate2);
        shuffLate(comb)=corrTmp(2);

        shuffCalls2=calls2(randperm(length(calls2)));
        corrTmp=corrcoef(calls1,shuffCalls2);
        shuffR(comb)=corrTmp(2);

        shuffTones2=tones2(randperm(length(tones2)));
        corrTmp=corrcoef(tones1,shuffTones2);
        shuffTones(comb)=corrTmp(2);

    end

    meanCorrEarly(r)=nanmean(corrEarly);
    meanCorrLate(r)=nanmean(corrLate);
    meanCorrCalls(r)=nanmean(corrR);
    meanCorrTones(r)=nanmean(corrTones);

    shuffCorrEarly(r)=nanmean(shuffEarly);
    shuffCorrLate(r)=nanmean(shuffLate);
    shuffCorrCalls(r)=nanmean(shuffR);
    shuffCorrTones(r)=nanmean(shuffTones);
end

% cmap=brewermap(4,'dark2');
% figure; hold on
% % p(1)=cdfplot(meanCorrEarly);
% % p(1).Color=cmap(1,:);
% %
% %
% % p(2)=cdfplot(meanCorrLate);
% % p(2).Color=cmap(2,:);
%
% p(3)=cdfplot(meanCorrCalls);
% p(3).Color=cmap(3,:);
%
% p(4)=cdfplot(meanCorrTones);
% p(4).Color=cmap(4,:);
%
% title('mean tuning correlation across days')
% xlabel('corr coef')
% ylabel('fraction of ROIs')
% legend('calls, early','calls, late','calls','tones')

cmap=brewermap(8,'Paired');
figure; hold on
p(1)=cdfplot(meanCorrEarly);
p(1).Color=cmap(2,:);
p(2)=cdfplot(shuffCorrEarly);
p(2).Color=cmap(1,:);
title('calls,early')
legend('data','shuff')

figure; hold on
p(1)=cdfplot(meanCorrLate);
p(1).Color=cmap(4,:);
p(2)=cdfplot(shuffCorrLate);
p(2).Color=cmap(3,:);
title('calls,late')
legend('data','shuff')

figure; hold on
p(1)=cdfplot(meanCorrCalls);
p(1).Color=cmap(6,:);
p(2)=cdfplot(shuffCorrCalls);
p(2).Color=cmap(5,:);
[h,pval]=ttest(meanCorrCalls,shuffCorrCalls)
title('calls')
legend('data','shuff')
xlabel('correlation')
ylabel('fraction of ROIs')


figure; hold on
p(1)=cdfplot(meanCorrTones);
p(1).Color=cmap(8,:);
p(2)=cdfplot(shuffCorrTones);
p(2).Color=cmap(7,:);
[h,pval]=ttest(meanCorrTones,shuffCorrTones)
title('tones')
legend('data','shuff')
xlabel('correlation')
ylabel('fraction of ROIs')


figure; hold on
p(1)=cdfplot(meanCorrCalls);
p(1).Color=cmap(6,:);
% p(2)=cdfplot(shuffCorrCalls);
% p(2).Color=cmap(5,:);

p(1)=cdfplot(meanCorrTones);
p(1).Color=cmap(8,:);
% p(2)=cdfplot(shuffCorrTones);
% p(2).Color=cmap(7,:);
title('mean correlation across days')
legend('calls','tones')
xlabel('correlation')
ylabel('fraction of ROIs')

figure; hold on
plotSpread([meanCorrEarly,meanCorrLate,meanCorrCalls,meanCorrTones],[],[],{'calls, early','calls, late','calls','tones'},4)
plot(1,nanmean(shuffCorrEarly),'go')
plot(2,nanmean(shuffCorrLate),'go')
plot(3,nanmean(shuffCorrCalls),'go')
plot(4,nanmean(shuffCorrTones),'go')
ylabel('mean correlation across days')
%% sort ROIs by highest correlations across days

[~,corr_idx_calls] = sort(meanCorrCalls,'ascend');

MultiDayROIs_unsorted=MultiDayROIs;
MultiDayROIs = MultiDayROIs(corr_idx_calls);

[~,corr_idx_tones] = sort(meanCorrTones,'ascend');
MultiDayROIs = MultiDayROIs_unsorted(corr_idx_tones);

%% correlation of calls vs correlation of tone tuning

figure; hold on
plot(1:2,[meanCorrCalls,meanCorrTones],'ko-')
plot(1:2,[shuffCorrCalls,shuffCorrTones],'go-')

figure; hold on
plot_scatterRLine(meanCorrTones,meanCorrCalls)
xlabel('cross day corr, tone tuning')
ylabel('cross day corr, call tuning')