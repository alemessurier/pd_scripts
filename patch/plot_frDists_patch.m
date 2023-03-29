function plot_frDists_patch(dists,names)


% make plots, compare all, IC, PS
figure; hold on
meanEvIFR_best={dists.meanEvIFR_best};
plotSpread(meanEvIFR_best,[],[],names,4);
ylabel('mean evoked IFR (Hz), best call')
% [~,p_meanEvIFR_best]=ttest2(meanEvIFR_best_PS,meanEvIFR_best_IC)


figure; hold on
meanEvIFR_all={dists.meanEvIFR_all};
plotSpread(meanEvIFR_all,[],[],names,4);
ylabel('mean evoked IFR (Hz), all calls')


figure; hold on
peakEvIFR_best={dists.peakEvIFR_best};
plotSpread(peakEvIFR_best,[],[],names,4);
ylabel('peak evoked IFR (Hz), best call')
% [~,p_peakEvIFR_best]=ttest2(peakEvIFR_best_IC,peakEvIFR_best_PS)

figure; hold on
peakEvIFR_all={dists.peakEvIFR_all};
plotSpread(peakEvIFR_all,[],[],names,4);
ylabel('peak evoked IFR (Hz), all calls')
% [~,p_peakEvIFR_Hz_all]=ttest2(evFrByTrial_Hz_all_PS,evFrByTrial_Hz_all_IC)

%% make plots
figure; hold on
evFrByTrial_Hz_all={dists.evFrByTrial_Hz_all};
plotSpread(evFrByTrial_Hz_all,[],[],names,4);
ylabel('mean evoked FR (Hz), all calls')


figure; hold on
evFrByTrial_Hz_best={dists.evFrByTrial_Hz_best};
plotSpread(evFrByTrial_Hz_best,[],[],names,4);
ylabel('mean evoked FR (Hz), best calls')
% [~,p_evFrByTrial_Hz_best]=ttest2(evFrByTrial_Hz_best_PS,evFrByTrial_Hz_best_IC);

figure; hold on
trialFR_mean={dists.trialFR_mean};
plotSpread(trialFR_mean,[],[],names,4);
ylabel('mean FR across trials (Hz)')