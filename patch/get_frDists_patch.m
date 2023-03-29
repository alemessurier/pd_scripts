function data_out=get_frDists_patch(data_fr)

%% evoked instantaneous FR for all cells

% evoked mean IFR over all calls
data_out.meanEvIFR_all=[data_fr(:).meanEvIFR_all];

% evoked mean IFR for best call
data_out.meanEvIFR_best=arrayfun(@(x)max(x.meanEvIFR),data_fr);

% evoked peak IFR over all calls
data_out.peakEvIFR_all=[data_fr(:).peakEvIFR_all];

% evoked peak IFR for best call
data_out.peakEvIFR_best=arrayfun(@(x)max(x.peakEvIFR),data_fr);

%% compare firing rates for IC and PC - trial-by-trial

% evoked mean fr over all calls, trials (raw Hz)
data_out.evFrByTrial_Hz_all=arrayfun(@(x)mean(x.evFrByTrial_Hz_all),data_fr);

% evoked mean fr over all calls, trials (raw Hz)
data_out.evFrByTrial_norm_all=arrayfun(@(x)mean(x.evFrByTrial_norm_all),data_fr);

% evoked mean fr over best call, trials (raw Hz, norm)
for c=1:length(data_fr)
    meanEvFrbyTrial_Hz=cellfun(@mean,data_fr(c).evFrByTrial_Hz);
    data_out.evFrByTrial_Hz_best(c)=max(meanEvFrbyTrial_Hz);

    meanEvFrbyTrial_norm=cellfun(@mean,data_fr(c).evFrByTrial_norm);
    data_out.evFrByTrial_norm_best(c)=max(meanEvFrbyTrial_norm);

    data_out.trialFR_mean(c)=mean(data_fr(c).trialFR_all);
end