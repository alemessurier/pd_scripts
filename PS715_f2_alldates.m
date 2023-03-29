% PS715 over days f1
paths_2p = {'/Volumes/pupCalls1/reduced/PS715/20210731/f2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210802/f2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210803/f2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210804/f2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210805/f2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210806/f2/suite2p/plane0/'};
%% load image of field
for d=1:length(paths_2p)
    load([paths_2p{d},'Fall.mat'],'ops')
    ops_all{d}=ops;
    figure; imagesc(ops.refImg)
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
    percentResponsive(d) = sum(sum(allDates(d).h_calls,2)>0)/size(h_calls,1);
end
figure; plot(percentResponsive,'ko-')
%% mean dF/F to each stim by day

for d=1:length(paths_2p)
    meanDF_early{d}=cellfun(@mean,allDates(d).meanByTrial_early);
    medianDF_early{d}=cellfun(@median,allDates(d).meanByTrial_early);
end


meanDF_early_all=cellfun(@(x)x(:),meanDF_early,'un',0);
medianDF_early_all=cellfun(@(x)x(:),medianDF_early,'un',0);

figure; hold on
h_DC=plotSpread(meanDF_early_all,[],[],{'day1','day2','day3','day4','day5','day6'},4);
ylabel('mean dF/F by cell/stim')

figure; hold on
h_DC=plotSpread(medianDF_early_all,[],[],{'day1','day2','day3','day4','day5','day6'},4);
ylabel('median dF/F by cell/stim')

for c=1:6
    meanDF_early_byStim=cellfun(@(x)x(c,:),meanDF_early,'un',0);
    medianDF_early_byStim=cellfun(@(x)x(c,:),medianDF_early,'un',0);

    figure; hold on
    h_DC=plotSpread(meanDF_early_byStim,[],[],{'day1','day2','day3','day4','day5','day6'},4);
    ylabel('mean dF/F by cell/stim')
    title(['call ',num2str(c)])

    figure; hold on
    h_DC=plotSpread(medianDF_early_byStim,[],[],{'day1','day2','day3','day4','day5','day6'},4);
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