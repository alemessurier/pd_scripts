%% PS1 (retro_gcamp_mouse3)
paths_2p = {'/Volumes/pupcalls2/retro_GCaMP_mouse3/20210525/field1/suite2p/plane0/',...
    '/Volumes/pupcalls2/retro_GCaMP_mouse3/20210525/field2/suite2p/plane0/',...
    '/Volumes/pupcalls2/retro_GCaMP_mouse3/20210526/field2/suite2p/plane0/',...
    '/Volumes/pupcalls2/retro_GCaMP_mouse3/20210526/field1/suite2p/plane0/',...
    '/Volumes/pupcalls2/retro_GCaMP_mouse3/20210527/suite2p/plane0/',...
    '/Volumes/pupcalls2/retro_GCaMP_mouse3/20210527/field4/suite2p/plane0/',...
    '/Volumes/pupcalls2/retro_GCaMP_mouse3/20210528_field4/suite2p/plane0/'}

%% PS715 over days f1
paths_2p = {'/Volumes/pupCalls1/reduced/PS715/20210731/f1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210802/f1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210804/f1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210805/f1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210806/f1/suite2p/plane0/'};
matchFilePath='/Volumes/pupCalls1/reduced/PS715/PS715_f1_ROImatch.mat';

for d=1:length(paths_2p)
    pupCall_imaging_pipeline(paths_2p{d},0)
end
pupCall_multidayROIs_load(matchFilePath,paths_2p)
%% PS715 over days f2
paths_2p = {'/Volumes/pupCalls1/reduced/PS715/20210731/f2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210802/f2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210803/f2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210804/f2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210805/f2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210806/f2/suite2p/plane0/'};
pupCall_multidayROIs_load(matchFilePath,paths_2p)
%% IC824 over days
paths_2p = {'/Volumes/pupCalls1/reduced/IC824/20210927/f1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC824/20210928/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC824/20210929/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC824/20211001/suite2p/plane0/'};
matchFilePath='/Volumes/pupCalls1/reduced/IC824/IC824_matchROIs.mat';

% for d=1:length(paths_2p)
%     pupCall_imaging_pipeline(paths_2p{d},0)
% end
pupCall_multidayROIs_load(matchFilePath,paths_2p)
%% IC929 over days
paths_2p = {'/Volumes/pupCalls1/reduced/IC929/20211019/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC929/20211021/f1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC929/20211021/f2/suite2p/plane0/'}

%% IC928 over days
paths_2p = {'/Volumes/pupCalls1/reduced/IC928/20211019/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC928/20211022/suite2p/plane0/'}

%% PS1001 over days
paths_2p={'/Volumes/pupCalls1/reduced/PS1001/20211019/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS1001/20211102/f1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS1001/20211102/f2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS1001/20211103/f3/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS1001/20211103/f4/suite2p/plane0/'};

%% PS1008 over days
paths_2p={'/Volumes/pupCalls1/reduced/PS1008/20211103/f4/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS1008/20211103/f5/suite2p/plane0/'};

%% IC1122 over days
paths_2p={'/Volumes/pupCalls2/IC1122/reduced/20211207/suite2p/plane0/',...
    '/Volumes/pupCalls2/IC1122/reduced/20211210/suite2p/plane0/'};

%% PS12202 over days
paths_2p={'/Volumes/pupcalls2/PS12202/reduced/20220111/suite2p/plane0/',...
    '/Volumes/pupcalls2/PS12202/reduced/20220112/f1/suite2p/plane0/',...
    '/Volumes/pupcalls2/PS12202/reduced/20220112/f2/suite2p/plane0/',...
    '/Volumes/pupcalls2/PS12202/reduced/20220114/f2/suite2p/plane0/'};

%% load image of field
for d=1:length(paths_2p)
    load([paths_2p{d},'Fall.mat'],'ops')
    ops_all{d}=ops;
    figure; imagesc(ops.refImg)
    axis square
    colormap gray
end
%% load in meanByTrial, P, h_calls

for d=1:length(paths_2p)
    load([paths_2p{d},'reduced_data.mat'],'meanByTrial_early','meanByTrial_late','h_calls','responsiveTrials_byCell');
    allDates(d).meanByTrial_early = meanByTrial_early;
    allDates(d).meanByTrial_late = meanByTrial_late;
    allDates(d).h_calls= h_calls;
    allDates(d).responsiveTrials=responsiveTrials_byCell;
end

%% proportion ROIs significantly responsive by day

for d=1:length(paths_2p)
    percentResponsive(d) = sum(sum(allDates(d).h_calls,2)>0)/size(allDates(d).h_calls,1);
end
figure; plot(percentResponsive,'ko-')
%% mean dF/F to each stim by day

for d=1:length(paths_2p)
    meanDF_early{d}=cellfun(@mean,allDates(d).meanByTrial_early);
    medianDF_early{d}=cellfun(@median,allDates(d).meanByTrial_early);
    dayLabels{d}=num2str(d)
end


meanDF_early_all=cellfun(@(x)x(:),meanDF_early,'un',0);
medianDF_early_all=cellfun(@(x)x(:),medianDF_early,'un',0);

figure; hold on
h_DC=plotSpread(meanDF_early_all,[],[],dayLabels,4);
ylabel('mean dF/F by cell/stim')

figure; hold on
h_DC=plotSpread(medianDF_early_all,[],[],dayLabels,4);
ylabel('median dF/F by cell/stim')

for c=1:6
    meanDF_early_byStim=cellfun(@(x)x(c,:),meanDF_early,'un',0);
    medianDF_early_byStim=cellfun(@(x)x(c,:),medianDF_early,'un',0);

    figure; hold on
    h_DC=plotSpread(meanDF_early_byStim,[],[],dayLabels,4);
    ylabel('mean dF/F by cell/stim')
    title(['call ',num2str(c)])

    figure; hold on
    h_DC=plotSpread(medianDF_early_byStim,[],[],dayLabels,4);
    ylabel('median dF/F by cell/stim')
    title(['call ',num2str(c)])
end

%%

for d=1:length(paths_2p)
    % view all trials across cells
    for c=1:size(allDates(d).meanByTrial_early,2)
        meanByTrial_tmp{c}=cat(1,allDates(d).meanByTrial_early{:,c});
    end
    meanByTrial_allcalls_early{d}=cat(2,meanByTrial_tmp{:});
    clear meanByTrial_tmp
end

maxVal=cellfun(@(x)max(x(:)),meanByTrial_allcalls_early);
minVal=cellfun(@(x)min(x(:)),meanByTrial_allcalls_early);
maxVal=max(maxVal);
minVal=min(minVal);

for d=1:length(paths_2p)

    figure;
    imagesc(meanByTrial_allcalls_early{d},[minVal maxVal])
    colormap gray
    title(['day ',num2str(d)])
end

%% compare distributions of responses across days - all cells, all trials

figure; hold on
cmap=cool(length(paths_2p));
for d=1:length(paths_2p)
    p(d)=cdfplot(meanByTrial_allcalls_early{d}(:));
    p(d).Color=cmap(d,:);
end

%% compare distributions of responses across days - all cells, all trials

figure; hold on
cmap=cool(length(paths_2p));
for d=1:length(paths_2p)
    meanByCell=mean(meanByTrial_allcalls_early{d});
    p(d)=cdfplot(meanByCell);
    p(d).Color=cmap(d,:);
end
title('mean dF all trial by cell')
legend
%% compare activity during tone vs call presentation by cell

%load data
for d=1:length(paths_2p)
    [F_calls,F_byToneRep,ops,inds_ex]=load2p_data_pupcalls(paths_2p{d});
    [deltaF_calls{d}] = pupCalls_make_deltaFall(F_calls,3,1);
    [deltaF_tones{d}] = tones_make_deltaFall(F_byToneRep,3,1,30);

    meanDF_total_calls{d}=mean(deltaF_calls{d},2);
    meanDF_total_tones{d}=mean(deltaF_tones{d},2);
    figure; hold on
    plot_scatterRLine(meanDF_total_tones{d},meanDF_total_calls{d})
    maxVal=max([meanDF_total_tones{d}; meanDF_total_calls{d}]);
    
    tmp=gca;
    tmp.YLim=[0 maxVal];
    tmp.XLim=[0 maxVal];
    plot([0 maxVal],[0 maxVal],'k:')
    xlabel(['total mean DF/F during tones, day ',num2str(d)])

    skewnessDF_total_calls{d}=skewness(deltaF_calls{d},1,2);
    skewnessDF_total_tones{d}=skewness(deltaF_tones{d},1,2);
    figure; hold on
    plot_scatterRLine(skewnessDF_total_tones{d},skewnessDF_total_calls{d})
    maxVal=max([skewnessDF_total_tones{d}; skewnessDF_total_calls{d}]);
    
    tmp=gca;
    tmp.YLim=[0 maxVal];
    tmp.XLim=[0 maxVal];
    plot([0 maxVal],[0 maxVal],'k:')
    xlabel(['total skewness DF/F during tones, day ',num2str(d)])
end


fig1=figure; hold on
fig2=figure; hold on
fig3=figure; hold on
fig4=figure; hold on

cmap=cool(length(paths_2p));
for d=1:length(paths_2p)
    figure(fig2)
    p(d)=cdfplot(meanDF_total_calls{d});
    p(d).Color=cmap(d,:);
    xlabel('mean dF/F during calls')
%     title(['day ',num2str(d)])
    
    figure(fig4)
    p(d)=cdfplot(skewnessDF_total_calls{d});
    p(d).Color=cmap(d,:);
    xlabel('dF/F skewness during calls')
%     title(['day ',num2str(d)])

    figure(fig1)
    p(d)=cdfplot(meanDF_total_tones{d});
    p(d).Color=cmap(d,:);
    xlabel('mean dF/F during tones')
%     title(['day ',num2str(d)])
    
    figure(fig3)
    p(d)=cdfplot(skewnessDF_total_tones{d});
    p(d).Color=cmap(d,:);
    xlabel('dF/F skewness during tones')
%     title(['day ',num2str(d)])

    
end
