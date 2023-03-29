%%
load('/Users/aml717/Desktop/patch/allpatch_reduced.mat')

%% 
IC_idx=arrayfun(@(x)strcmp(x.opto_tag,'IC'),metadata);
PS_idx=arrayfun(@(x)strcmp(x.opto_tag,'PS'),metadata);
idx_noTones=arrayfun(@(x)isempty(x.tone_files),metadata);
idx_noUSv=arrayfun(@(x)isempty(x.usv_files),metadata);

% data_optotagged=data(IC_idx | PS_idx);

%%

if ~isempty(data(c).optoID.raster20)
        timeIdx=[50,size(data(c).optoID.raster20,2)];
        make_lightRaster_patch(data(c).optoID.raster20,data(c).optoID.spike_times20,data(c).optoID.stimTime,timeIdx,10,20,0.2)
        title(['cell ',num2str(c)])
    end

    if ~isempty(data(c).optoID.raster50)
        timeIdx=[50,size(data(c).optoID.raster50,2)];
        make_lightRaster_patch(data(c).optoID.raster50,data(c).optoID.spike_times50,data(c).optoID.stimTime,timeIdx,10,50,0.2)
        title(['cell ',num2str(c)])
    end
    if ~isempty(data(c).optoID.raster200)
        timeIdx=[50,size(data(c).optoID.raster200,2)];
        make_lightRaster_patch(data(c).optoID.raster200,data(c).optoID.spike_times200,data(c).optoID.stimTime,timeIdx,10,200,0.2)
        title(['cell ',num2str(c)])
    end
    
    %%
data_optotagged=data(PS_idx & ~idx_noUSv & ~idx_noTones);
%%
data_optotagged=data(IC_idx & ~idx_noUSv & ~idx_noTones);
%%
data_optotagged=data(PS_idx & ~idx_noUSv );


for c=1:length(data_optotagged)
    make_usvRasterPSTH(data_optotagged(c).usv.spike_raster,...
        data_optotagged(c).usv.spikesByStim,data_optotagged(c).usv.raster_all,...
        data_optotagged(c).usv.spike_times,[100 6000],50)
end
%%
data_optotagged=data(PS_idx &  ~idx_noTones);

for c=1:length(data_optotagged)
    make_tonesRasterPSTH(data_optotagged(c).tones.spike_raster,...
        data_optotagged(c).tones.spikesByStim,data_optotagged(c).tones.freq_order,...
        [50 400],20)
end
%% get firing rates
data_IC=data(IC_idx);
data_fr_IC=get_patchFR(data_IC,[100 6000]);
data_PS=data(PS_idx);
data_fr_PS=get_patchFR(data_PS,[100 6000]);

%% compare firing rates for IC and PC - evoked instantaneous

% evoked mean IFR over all calls
meanEvIFR_all_IC=[data_fr_IC(:).meanEvIFR_all];
meanEvIFR_all_PS=[data_fr_PS(:).meanEvIFR_all];

% evoked mean IFR for best call
meanEvIFR_best_PS=arrayfun(@(x)max(x.meanEvIFR),data_fr_PS);
meanEvIFR_best_IC=arrayfun(@(x)max(x.meanEvIFR),data_fr_IC);

% evoked peak IFR over all calls
peakEvIFR_all_IC=[data_fr_IC(:).peakEvIFR_all];
peakEvIFR_all_PS=[data_fr_PS(:).peakEvIFR_all];

% evoked peak IFR for best call
peakEvIFR_best_PS=arrayfun(@(x)max(x.peakEvIFR),data_fr_PS);
peakEvIFR_best_IC=arrayfun(@(x)max(x.peakEvIFR),data_fr_IC);

%% make plots
figure; hold on
plotSpread({meanEvIFR_best_IC,meanEvIFR_best_PS},[],[],{'IC, best call','PS, best call'},4);
ylabel('mean evoked IFR (Hz), best call')
[~,p_meanEvIFR_best]=ttest2(meanEvIFR_best_PS,meanEvIFR_best_IC)


figure; hold on
plotSpread({meanEvIFR_all_IC,meanEvIFR_all_PS},[],[],{'IC','PS'},4);
ylabel('mean evoked IFR (Hz), all calls')


figure; hold on
plotSpread({peakEvIFR_best_IC,peakEvIFR_best_PS},[],[],{'IC, best call','PS, best call'},4);
ylabel('peak evoked IFR (Hz), best call')
[~,p_peakEvIFR_best]=ttest2(peakEvIFR_best_IC,peakEvIFR_best_PS)

figure; hold on
plotSpread({peakEvIFR_all_IC,peakEvIFR_all_PS},[],[],{'IC','PS'},4);
ylabel('peak evoked IFR (Hz), all calls')
[~,p_peakEvIFR_Hz_all]=ttest2(evFrByTrial_Hz_all_PS,evFrByTrial_Hz_all_IC)

%% compare firing rates for IC and PC - trial-by-trial

% evoked mean fr over all calls, trials (raw Hz)
evFrByTrial_Hz_all_IC=arrayfun(@(x)mean(x.evFrByTrial_Hz_all),data_fr_IC);
evFrByTrial_Hz_all_PS=arrayfun(@(x)mean(x.evFrByTrial_Hz_all),data_fr_PS);

% evoked mean fr over all calls, trials (raw Hz)
evFrByTrial_norm_all_IC=arrayfun(@(x)mean(x.evFrByTrial_norm_all),data_fr_IC);
evFrByTrial_norm_all_PS=arrayfun(@(x)mean(x.evFrByTrial_norm_all),data_fr_PS);

% evoked mean fr over best call, trials (raw Hz, norm)
for c=1:length(data_fr_PS)
    meanEvFrbyTrial_Hz=cellfun(@mean,data_fr_PS(c).evFrByTrial_Hz);
    evFrByTrial_Hz_best_PS(c)=max(meanEvFrbyTrial_Hz);

    meanEvFrbyTrial_norm=cellfun(@mean,data_fr_PS(c).evFrByTrial_norm);
    evFrByTrial_norm_best_PS(c)=max(meanEvFrbyTrial_norm);

    trialFR_mean_PS(c)=mean(data_fr_PS(c).trialFR);
end

for c=1:length(data_fr_IC)
    meanEvFrbyTrial_Hz=cellfun(@mean,data_fr_IC(c).evFrByTrial_Hz);
    evFrByTrial_Hz_best_IC(c)=max(meanEvFrbyTrial_Hz);

    meanEvFrbyTrial_norm=cellfun(@mean,data_fr_IC(c).evFrByTrial_norm);
    evFrByTrial_norm_best_IC(c)=max(meanEvFrbyTrial_norm);

    trialFR_mean_IC(c)=mean(data_fr_IC(c).trialFR);
end

%% make plots
figure; hold on
plotSpread({evFrByTrial_Hz_all_IC,evFrByTrial_Hz_all_PS},[],[],{'IC','PS'},4);
ylabel('mean evoked FR (Hz), all calls')

figure; hold on
plotSpread({evFrByTrial_norm_all_IC,evFrByTrial_norm_all_PS},[],[],{'IC','PS'},4);
ylabel('mean evoked FR (norm), all calls')

figure; hold on
plotSpread({evFrByTrial_Hz_best_IC,evFrByTrial_Hz_best_PS},[],[],{'IC','PS'},4);
ylabel('mean evoked FR (Hz), best calls')
[~,p_evFrByTrial_Hz_best]=ttest2(evFrByTrial_Hz_best_PS,evFrByTrial_Hz_best_IC);


figure; hold on
plotSpread({evFrByTrial_norm_best_IC,evFrByTrial_norm_best_PS},[],[],{'IC','PS'},4);
ylabel('mean evoked FR (norm), best calls')


figure; hold on
plotSpread({trialFR_mean_IC,trialFR_mean_PS},[],[],{'IC','PS'},4);
ylabel('mean FR across trials (Hz)')


%% for each cell, collect:
%   IFR for each USV
%   IFR overall
%   trial-by-trial firing rate - each USV
%   trial-by-trial firing rate - overall
%% get firing rates for all cells
 
% exclude cells with no USV data
idx_noUSv=arrayfun(@(x)isempty(x.usv_files),metadata);
data_fr=get_patchFR(data(~idx_noUSv),[100 6000]);

%% evoked instantaneous FR for all cells

% evoked mean IFR over all calls
meanEvIFR_all=[data_fr(:).meanEvIFR_all];

% evoked mean IFR for best call
meanEvIFR_best=arrayfun(@(x)max(x.meanEvIFR),data_fr);

% evoked peak IFR over all calls
peakEvIFR_all=[data_fr(:).peakEvIFR_all];

% evoked peak IFR for best call
peakEvIFR_best=arrayfun(@(x)max(x.peakEvIFR),data_fr);


% make plots, compare all, IC, PS
figure; hold on
plotSpread({meanEvIFR_best,meanEvIFR_best_IC,meanEvIFR_best_PS},[],[],{'all','IC','PS'},4);
ylabel('mean evoked IFR (Hz), best call')
% [~,p_meanEvIFR_best]=ttest2(meanEvIFR_best_PS,meanEvIFR_best_IC)


figure; hold on
plotSpread({meanEvIFR_all,meanEvIFR_all_IC,meanEvIFR_all_PS},[],[],{'all','IC','PS'},4);
ylabel('mean evoked IFR (Hz), all calls')


figure; hold on
plotSpread({peakEvIFR_best,peakEvIFR_best_IC,peakEvIFR_best_PS},[],[],{'all','IC','PS'},4);
ylabel('peak evoked IFR (Hz), best call')
% [~,p_peakEvIFR_best]=ttest2(peakEvIFR_best_IC,peakEvIFR_best_PS)

figure; hold on
plotSpread({peakEvIFR_all,peakEvIFR_all_IC,peakEvIFR_all_PS},[],[],{'all','IC','PS'},4);
ylabel('peak evoked IFR (Hz), all calls')
% [~,p_peakEvIFR_Hz_all]=ttest2(evFrByTrial_Hz_all_PS,evFrByTrial_Hz_all_IC)

%% compare firing rates for IC and PC - trial-by-trial

% evoked mean fr over all calls, trials (raw Hz)
evFrByTrial_Hz_all=arrayfun(@(x)mean(x.evFrByTrial_Hz_all),data_fr);

% evoked mean fr over all calls, trials (raw Hz)
evFrByTrial_norm_all=arrayfun(@(x)mean(x.evFrByTrial_norm_all),data_fr);

% evoked mean fr over best call, trials (raw Hz, norm)
for c=1:length(data_fr)
    meanEvFrbyTrial_Hz=cellfun(@mean,data_fr(c).evFrByTrial_Hz);
    evFrByTrial_Hz_best(c)=max(meanEvFrbyTrial_Hz);

    meanEvFrbyTrial_norm=cellfun(@mean,data_fr(c).evFrByTrial_norm);
    evFrByTrial_norm_best(c)=max(meanEvFrbyTrial_norm);

    trialFR_mean(c)=mean(data_fr(c).trialFR);
end


%% make plots
figure; hold on
plotSpread({evFrByTrial_Hz_all,evFrByTrial_Hz_all_IC,evFrByTrial_Hz_all_PS},[],[],{'all','IC','PS'},4);
ylabel('mean evoked FR (Hz), all calls')

figure; hold on
plotSpread({evFrByTrial_norm_all,evFrByTrial_norm_all_IC,evFrByTrial_norm_all_PS},[],[],{'all','IC','PS'},4);
ylabel('mean evoked FR (norm), all calls')

figure; hold on
plotSpread({evFrByTrial_Hz_best,evFrByTrial_Hz_best_IC,evFrByTrial_Hz_best_PS},[],[],{'all','IC','PS'},4);
ylabel('mean evoked FR (Hz), best calls')
% [~,p_evFrByTrial_Hz_best]=ttest2(evFrByTrial_Hz_best_PS,evFrByTrial_Hz_best_IC);


figure; hold on
plotSpread({evFrByTrial_norm_best,evFrByTrial_norm_best_IC,evFrByTrial_norm_best_PS},[],[],{'all','IC','PS'},4);
ylabel('mean evoked FR (norm), best calls')


figure; hold on
plotSpread({trialFR_mean,trialFR_mean_IC,trialFR_mean_PS},[],[],{'all','IC','PS'},4);
ylabel('mean FR across trials (Hz)')

%% compare tone vs call responses for each cell
% exclude cells with no tone data or no usv data
load('/Users/aml717/Desktop/patch/allpatch_reduced.mat')
IC_idx=arrayfun(@(x)strcmp(x.opto_tag,'IC'),metadata);
PS_idx=arrayfun(@(x)strcmp(x.opto_tag,'PS'),metadata);
idx_noTones=arrayfun(@(x)isempty(x.tone_files),metadata);
idx_noUSv=arrayfun(@(x)isempty(x.usv_files),metadata);
data_fr_tones=get_patchFR_tones(data(~idx_noTones & ~idx_noUSv),[50 400]);
data_fr_calls=get_patchFR(data(~idx_noTones & ~idx_noUSv),[100 6000]);

data_IC=data(IC_idx & ~idx_noTones & ~idx_noUSv);
data_PS=data(PS_idx & ~idx_noTones & ~idx_noUSv);
data_fr_IC=get_patchFR(data_IC ,[100 6000]);
data_fr_PS=get_patchFR(data_PS,[100 6000]);
data_fr_tones_IC=get_patchFR_tones(data_IC ,[50 400]);
data_fr_tones_PS=get_patchFR_tones(data_PS,[50 400]);

% get fr measures from each population
fr_tones=get_frDists_patch(data_fr_tones);
fr_calls=get_frDists_patch(data_fr_calls);

fr_tones_IC=get_frDists_patch(data_fr_tones_IC);
fr_calls_IC=get_frDists_patch(data_fr_IC);

fr_tones_PS=get_frDists_patch(data_fr_tones_PS);
fr_calls_PS=get_frDists_patch(data_fr_PS);

%% scatter plots comparing tones and calls for each cell


% peak evoked IFR
figure; hold on
plot(fr_tones.peakEvIFR_best,fr_calls.peakEvIFR_best,'ko')
plot(fr_tones_IC.peakEvIFR_best,fr_calls_IC.peakEvIFR_best,'go')
plot(fr_tones_PS.peakEvIFR_best,fr_calls_PS.peakEvIFR_best,'bo')
maxVal=max([fr_tones.peakEvIFR_best,fr_calls.peakEvIFR_best]);
tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('evoked firing rate, best tone (Hz)')
ylabel('evoked firing rate, best call (Hz)')
axis square


% peak evoked IFR
figure; hold on
plot(fr_tones.trialFR_mean,fr_calls.trialFR_mean,'ko')
plot(fr_tones_IC.trialFR_mean,fr_calls_IC.trialFR_mean,'go')
plot(fr_tones_PS.trialFR_mean,fr_calls_PS.trialFR_mean,'bo')
maxVal=max([fr_tones.trialFR_mean,fr_calls.trialFR_mean]);
tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('baseline firing rate during tone blocks (Hz)')
ylabel('baseline firing rate during call blocks (Hz)')
axis square

%%

figure; hold on

plot([0.5 1],[fr_tones.trialFR_mean',fr_calls.trialFR_mean'],'ro-')
plot([0.5 1],[mean(fr_tones.trialFR_mean),mean(fr_calls.trialFR_mean)],'ko')
errorbar([0.5 1],[mean(fr_tones.trialFR_mean),mean(fr_calls.trialFR_mean)],...
    [std(fr_tones.trialFR_mean)/sqrt(length(fr_tones.trialFR_mean)),...
    std(fr_calls.trialFR_mean)/sqrt(length(fr_calls.trialFR_mean))],'Color','k','LineWidth',1.5)

plot([1.5 2],[fr_tones_IC.trialFR_mean',fr_calls_IC.trialFR_mean'],'go-')
plot([1.5 2],[mean(fr_tones_IC.trialFR_mean),mean(fr_calls_IC.trialFR_mean)],'ko')
errorbar([1.5 2],[mean(fr_tones_IC.trialFR_mean),mean(fr_calls_IC.trialFR_mean)],...
    [std(fr_tones_IC.trialFR_mean)/sqrt(length(fr_tones_IC.trialFR_mean)),...
    std(fr_calls_IC.trialFR_mean)/sqrt(length(fr_calls_IC.trialFR_mean))],'Color','k','LineWidth',1.5)

plot([2.5 3],[fr_tones_PS.trialFR_mean',fr_calls_PS.trialFR_mean'],'bo-')
plot([2.5 3],[mean(fr_tones_PS.trialFR_mean),mean(fr_calls_PS.trialFR_mean)],'ko')
errorbar([2.5 3],[mean(fr_tones_PS.trialFR_mean),mean(fr_calls_PS.trialFR_mean)],...
    [std(fr_tones_PS.trialFR_mean)/sqrt(length(fr_tones_PS.trialFR_mean)),...
    std(fr_calls_PS.trialFR_mean)/sqrt(length(fr_calls_PS.trialFR_mean))],'Color','k','LineWidth',1.5)

tmp=gca;
tmp.XLim=[0 3.5];
tmp.XTick=0.5:0.5:3;
tmp.XTickLabel={'all cells, tones','all cells, calls','IC, tones','IC, calls','PS,tones','IC,calls'};
tmp.XTickLabelRotation=45;
ylabel('baseline firing rate during epoch (Hz)')
%%

figure; hold on
plot([0.5 1],[fr_tones.peakEvIFR_best',fr_calls.peakEvIFR_best'],'ro-')
plot([0.5 1],[mean(fr_tones.peakEvIFR_best),mean(fr_calls.peakEvIFR_best)],'ko')
errorbar([0.5 1],[mean(fr_tones.peakEvIFR_best),mean(fr_calls.peakEvIFR_best)],...
    [std(fr_tones.peakEvIFR_best)/sqrt(length(fr_tones.peakEvIFR_best)),...
    std(fr_calls.peakEvIFR_best)/sqrt(length(fr_calls.peakEvIFR_best))],'Color','k','LineWidth',1.5)

plot([1.5 2],[fr_tones_IC.peakEvIFR_best',fr_calls_IC.peakEvIFR_best'],'go-')
plot([1.5 2],[mean(fr_tones_IC.peakEvIFR_best),mean(fr_calls_IC.peakEvIFR_best)],'ko')
errorbar([1.5 2],[mean(fr_tones_IC.peakEvIFR_best),mean(fr_calls_IC.peakEvIFR_best)],...
    [std(fr_tones_IC.peakEvIFR_best)/sqrt(length(fr_tones_IC.peakEvIFR_best)),...
    std(fr_calls_IC.peakEvIFR_best)/sqrt(length(fr_calls_IC.peakEvIFR_best))],'Color','k','LineWidth',1.5)

plot([2.5 3],[fr_tones_PS.peakEvIFR_best',fr_calls_PS.peakEvIFR_best'],'bo-')
plot([2.5 3],[mean(fr_tones_PS.peakEvIFR_best),mean(fr_calls_PS.peakEvIFR_best)],'ko')
errorbar([2.5 3],[mean(fr_tones_PS.peakEvIFR_best),mean(fr_calls_PS.peakEvIFR_best)],...
    [std(fr_tones_PS.peakEvIFR_best)/sqrt(length(fr_tones_PS.peakEvIFR_best)),...
    std(fr_calls_PS.peakEvIFR_best)/sqrt(length(fr_calls_PS.peakEvIFR_best))],'Color','k','LineWidth',1.5)

tmp=gca;
tmp.XLim=[0 3.5];
tmp.XTick=0.5:0.5:3;
tmp.XTickLabel={'all cells, calls','all cells, tones','IC, tones','IC, calls','PS,tones','IC,calls'};
tmp.XTickLabelRotation=45;
ylabel('evoked firing rate, best stimulus (Hz)')
%% compare across populations
dists=[fr_calls,fr_tones,fr_calls_IC,fr_tones_IC,fr_calls_PS,fr_tones_PS];
names={'all cells, calls','all cells, tones','IC, calls','IC, tones','PS, calls','PS, tones'};
plot_frDists_patch(dists,names)

%% make cdf plots w/IC and PS mean/sem errorbars - calls

load('/Users/aml717/Desktop/patch/allpatch_reduced.mat')
IC_idx=arrayfun(@(x)strcmp(x.opto_tag,'IC'),metadata);
PS_idx=arrayfun(@(x)strcmp(x.opto_tag,'PS'),metadata);
idx_noTones=arrayfun(@(x)isempty(x.tone_files),metadata);
idx_noUSv=arrayfun(@(x)isempty(x.usv_files),metadata);

data_fr_calls=get_patchFR(data(~idx_noUSv),[100 6000]);
data_IC=data(IC_idx & ~idx_noUSv);
data_PS=data(PS_idx & ~idx_noUSv);
data_fr_IC=get_patchFR(data_IC ,[100 6000]);
data_fr_PS=get_patchFR(data_PS,[100 6000]);
fr_calls=get_frDists_patch(data_fr_calls);
fr_calls_IC=get_frDists_patch(data_fr_IC);
fr_calls_PS=get_frDists_patch(data_fr_PS);

figure; hold on
p(1)=cdfplot(fr_calls.peakEvIFR_best);
p(1).Color='k'
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_calls_IC.peakEvIFR_best,'g');
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_calls_PS.peakEvIFR_best,'b');
title('')
xlabel('peak evoked instantaneous firing rate, best call (Hz)')
ylabel('percentile')
tmp=gca;
tmp.YTickLabel=tmp.YTick*100;

figure; hold on
p(1)=cdfplot(fr_calls.meanEvIFR_best);
p(1).Color='k'
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_calls_IC.meanEvIFR_best,'g');
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_calls_PS.meanEvIFR_best,'b');
title('')
xlabel('mean evoked instantaneous firing rate, best call (Hz)')
ylabel('percentile')
tmp=gca;
tmp.YTickLabel=tmp.YTick*100;

figure; hold on
p(1)=cdfplot(fr_calls.evFrByTrial_Hz_best);
p(1).Color='k'
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_calls_IC.evFrByTrial_Hz_best,'g');
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_calls_PS.evFrByTrial_Hz_best,'b');
title('')
xlabel('mean evoked firing rate, best call (Hz)')
ylabel('percentile')
tmp=gca;
tmp.YTickLabel=tmp.YTick*100;

figure; hold on
p(1)=cdfplot(fr_calls.trialFR_mean);
p(1).Color='k'
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_calls_IC.trialFR_mean,'g');
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_calls_PS.trialFR_mean,'b');
title('')
xlabel('mean firing rate (Hz)')
ylabel('percentile')
tmp=gca;
tmp.YTickLabel=tmp.YTick*100;

%% make cdf plots w/IC and PS mean/sem errorbars - tones

load('/Users/aml717/Desktop/patch/allpatch_reduced.mat')
IC_idx=arrayfun(@(x)strcmp(x.opto_tag,'IC'),metadata);
PS_idx=arrayfun(@(x)strcmp(x.opto_tag,'PS'),metadata);
idx_noTones=arrayfun(@(x)isempty(x.tone_files),metadata);
idx_noUSv=arrayfun(@(x)isempty(x.usv_files),metadata);

data_fr_tones=get_patchFR_tones(data(~idx_noTones),[50 400]);
data_IC=data(IC_idx & ~idx_noTones);
data_PS=data(PS_idx & ~idx_noTones);
data_fr_IC=get_patchFR_tones(data_IC ,[50 400]);
data_fr_PS=get_patchFR_tones(data_PS,[50 400]);
fr_tones=get_frDists_patch(data_fr_tones);
fr_tones_IC=get_frDists_patch(data_fr_IC);
fr_tones_PS=get_frDists_patch(data_fr_PS);

figure; hold on
p(1)=cdfplot(fr_tones.peakEvIFR_best);
p(1).Color='k'
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_tones_IC.peakEvIFR_best,'g');
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_tones_PS.peakEvIFR_best,'b');
title('')
xlabel('peak evoked instantaneous firing rate, best tone (Hz)')
ylabel('percentile')
tmp=gca;
tmp.YTickLabel=tmp.YTick*100;

figure; hold on
p(1)=cdfplot(fr_tones.meanEvIFR_best);
p(1).Color='k'
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_tones_IC.meanEvIFR_best,'g');
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_tones_PS.meanEvIFR_best,'b');
title('')
xlabel('mean evoked instantaneous firing rate, best tone (Hz)')
ylabel('percentile')
tmp=gca;
tmp.YTickLabel=tmp.YTick*100;

figure; hold on
p(1)=cdfplot(fr_tones.evFrByTrial_Hz_best);
p(1).Color='k'
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_tones_IC.evFrByTrial_Hz_best,'g');
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_tones_PS.evFrByTrial_Hz_best,'b');
title('')
xlabel('mean evoked firing rate, best tone (Hz)')
ylabel('percentile')
tmp=gca;
tmp.YTickLabel=tmp.YTick*100;

figure; hold on
p(1)=cdfplot(fr_tones.trialFR_mean);
p(1).Color='k'
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_tones_IC.trialFR_mean,'g');
[mean_handle,error_handle]=plot_errorBarOnCDF(p(1),fr_tones_PS.trialFR_mean,'b');
title('')
xlabel('baseline firing rate, tones (Hz)')
ylabel('percentile')
tmp=gca;
tmp.YTickLabel=tmp.YTick*100;

