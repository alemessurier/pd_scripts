%% IC622
paths_2p={'/Volumes/pupCalls1/reduced/IC622/20220718/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC622/20220719/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC622/20220720/suite2p/plane0/'};

matchFilePath='/Volumes/pupCalls1/reduced/IC622/IC622_roiMatch.mat';
% for i=1:length(paths_2p)
% pupCall_imaging_pipeline_multiISI_spikes(paths_2p{i},0);
% end
%% IC623
paths_2p={'/Volumes/pupCalls1/reduced/IC623/20220718/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC623/20220719/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC623/20220720/suite2p/plane0/'};
% for i=1:length(paths_2p)
% pupCall_imaging_pipeline_multiISI_spikes(paths_2p{i},0);
% end
matchFilePath='/Volumes/pupCalls1/reduced/IC623/IC623_roiMatch.mat';
%% IC603 field 1
paths_2p = {'/Volumes/pupCalls1/reduced/IC603/20220627/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC603/20220628/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC603/20220629/field1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC603/20220630/field1/suite2p/plane0/'}
% for i=1:length(paths_2p)
% pupCall_imaging_pipeline_multiISI_spikes(paths_2p{i},0);
% end

matchFilePath='/Volumes/pupCalls1/reduced/IC603/IC603_matchROI_field1.mat';
%% IC603 field 2
paths_2p = {'/Volumes/pupCalls1/reduced/IC603/20220629/field2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC603/20220630/field2/suite2p/plane0/'}
matchFilePath='/Volumes/pupCalls1/reduced/IC603/IC603_matchROI_field2.mat';

% pupCall_imaging_pipeline_multiISI_spikes(paths_2p{2},0)
%% IC 617 field 1
paths_2p = {'/Volumes/pupCalls1/reduced/IC617/20220703/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC617/20220705/field1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC617/20220706/field1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC617/20220707/field1/suite2p/plane0/'};
matchFilePath='/Volumes/pupCalls1/reduced/IC617/IC617_field1_roiMatch.mat'
%% IC 617 field 2
paths_2p = {'/Volumes/pupCalls1/reduced/IC617/20220705/field2/suite2p/plane0/',...
        '/Volumes/pupCalls1/reduced/IC617/20220706/field2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC617/20220707/field2/suite2p/plane0/'};


matchFilePath='/Volumes/pupCalls1/reduced/IC617/IC617_field2_roiMatch.mat';
% for i=1:length(paths_2p)
% pupCall_imaging_pipeline_multiISI_spikes(paths_2p{i},0);
% end

%% PS526 field 1
paths_2p = {'/Volumes/pupCalls1/reduced/PS526/20220628/field1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS526/20220629/field1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS526/20220630/suite2p/plane0/'}
matchFilePath='/Volumes/pupCalls1/reduced/PS526/PS526_field1_roiMatch.mat/';
% 
%% PS526 field 2
% paths_2p = {'/Volumes/pupCalls1/reduced/PS526/20220628/field2/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS526/20220629/field2/suite2p/plane0/'}
for i=1:length(paths_2p)
pupCall_imaging_pipeline_multiISI_spikes(paths_2p{i},0);
end
%% PS525

paths_2p={'/Volumes/pupCalls1/reduced/PS525/20220628/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS525/20220629/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS525/20220630/suite2p/plane0/'}
% for i=1:length(paths_2p)
% pupCall_imaging_pipeline_multiISI_spikes(paths_2p{i},0);
% end
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
    load([paths_2p{d},'reduced_data.mat'],'meanByTrial_early_5sec','meanByTrial_early_10sec','h_5sec','responsiveTrials_5sec');
    allDates(d).meanByTrial_early_5sec = meanByTrial_early_5sec;
    allDates(d).meanByTrial_early_10sec = meanByTrial_early_10sec;
    allDates(d).h_calls= h_5sec;
    allDates(d).responsiveTrials=responsiveTrials_5sec;
end

%% proportion ROIs significantly responsive by day

for d=1:length(paths_2p)
    percentResponsive(d) = sum(sum(allDates(d).h_calls,2)>0)/size(allDates(d).h_calls,1);
end
figure; plot(percentResponsive,'ko-')
%% mean dF/F to each stim by day - all responses

for d=1:length(paths_2p)
    meanDF_early_5sec{d}=cellfun(@mean,allDates(d).meanByTrial_early_5sec);
    medianDF_early_5sec{d}=cellfun(@median,allDates(d).meanByTrial_early_5sec);
    bestCall_early_5sec{d}=max(meanDF_early_5sec{d});
    dayLabels{d}=num2str(d)
end


meanDF_early_5sec_all=cellfun(@(x)x(:),meanDF_early_5sec,'un',0);
medianDF_early_5sec_all=cellfun(@(x)x(:),medianDF_early_5sec,'un',0);

figure; hold on
h_DC=plotSpread(meanDF_early_5sec_all,[],[],dayLabels,4);
ylabel('mean dF/F by cell/stim')

figure; hold on
h_DC=plotSpread(medianDF_early_5sec_all,[],[],dayLabels,4);
ylabel('median dF/F by cell/stim')

for c=1:6
    meanDF_early_5sec_byStim=cellfun(@(x)x(c,:),meanDF_early_5sec,'un',0);
    medianDF_early_5sec_byStim=cellfun(@(x)x(c,:),medianDF_early_5sec,'un',0);

%     figure; hold on
%     h_DC=plotSpread(meanDF_early_5sec_byStim,[],[],dayLabels,4);
%     ylabel('mean dF/F by cell/stim')
%     title(['call ',num2str(c)])
% 
%     figure; hold on
%     h_DC=plotSpread(medianDF_early_5sec_byStim,[],[],dayLabels,4);
%     ylabel('median dF/F by cell/stim')
%     title(['call ',num2str(c)])

end
%% meanDF to best response by day for each cell

    
    % get best stim response for each cell
    meanDF_5sec_bestCall=cellfun(@(x)max(x,[],1)',meanDF_early_5sec,'un',0);

    medianDF_5sec_bestCall=cellfun(@(x)max(x,[],1)',medianDF_early_5sec,'un',0);

    figure; hold on
h_DC=plotSpread(meanDF_5sec_bestCall,[],[],dayLabels,4);
ylabel('mean dF/F to best call, 5 sec')

figure; hold on
h_DC=plotSpread(medianDF_5sec_bestCall,[],[],dayLabels,4);
ylabel('median dF/F to best call, 5sec')
%%

for d=1:length(paths_2p)
    % view all trials across cells
    for c=1:size(allDates(d).meanByTrial_early_5sec,2)
        meanByTrial_tmp{c}=cat(1,allDates(d).meanByTrial_early_5sec{:,c});
    end
    meanByTrial_allcalls_early_5sec{d}=cat(2,meanByTrial_tmp{:});
    clear meanByTrial_tmp
end

maxVal=cellfun(@(x)max(x(:)),meanByTrial_allcalls_early_5sec);
minVal=cellfun(@(x)min(x(:)),meanByTrial_allcalls_early_5sec);
maxVal=max(maxVal);
minVal=min(minVal);

for d=1:length(paths_2p)

    figure;
    imagesc(meanByTrial_allcalls_early_5sec{d},[minVal maxVal])
    colormap gray
    title(['day ',num2str(d)])
end

%% compare distributions of responses across days - all cells, all trials

figure; hold on
cmap=cool(length(paths_2p));
for d=1:length(paths_2p)
    p(d)=cdfplot(meanByTrial_allcalls_early_5sec{d}(:));
    p(d).Color=cmap(d,:);
end

%% compare distributions of responses across days - all cells, all trials

figure; hold on
cmap=cool(length(paths_2p));
for d=1:length(paths_2p)
    meanByCell=mean(meanByTrial_allcalls_early_5sec{d});
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
