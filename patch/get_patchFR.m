function data_fr=get_patchFR(data,time_idx)

% for each cell, collect:
%   IFR for each USV
%   IFR overall
%   trial-by-trial firing rate - stim-evoked, each USV
%   trial-by-trial firing rate - stim-evoked, overall
%   stim-evoked IFR, each USV -average
%   stim-evoked IFR, all - average
%   stim-evoked IFR, each USV - peak
%   stim-evoked IFR, all - peak
%   mean firing rate over each trial

% interval for stim-evoked FR
evStart=1.5-time_idx(1)/1000;
evEnd=(evStart+1.5);
evSec=evEnd-evStart; %length of evoked period in seconds
blSec=evStart; %length of baseline in seconds
ev_idx_ms=evStart*1000:evEnd*1000;
bl_idx_ms=1:evStart*1000;
trialSec=(time_idx(2)-time_idx(1))/1000;

for c=1:length(data)
    sprintf(num2str(c))
    numUSVs=length(data(c).usv.spikesByStim);
    for s=1:numUSVs
        numTrials=size(data(c).usv.spike_raster{s},1);
%         stimStart=1.5-time_idx(1)/1000+((1:numTrials)-1)*6;
%         stimEnd=2.5-time_idx(1)/1000+((1:numTrials)-1)*6;
%         vecStimTimes=[stimStart',stimEnd'];
        stimStart=((1:numTrials)-1)*trialSec; % use start of each trial for calculating IFR; use corrected trial
        vecStimTimes=stimStart';
        spikeRasterMS=data(c).usv.spike_raster{s};
        spikeRasterMS=spikeRasterMS(:,time_idx(1):time_idx(2)); % correct for shortened trial if removing sections
        [trial,ms]=find(spikeRasterMS);
        spikeTimesTmp=(ms/1000)+(trial-1)*trialSec;
        if numel(spikeTimesTmp)<2
            data_fr(c).zeta(s).vecTime=[];
            data_fr(c).zeta(s).vecRate=[];
            data_fr(c).zeta(s).dblZetaP=[];
            data_fr(c).zeta(s).dblZETA=[];
            data_fr(c).meanEvIFR(s)=0;
            data_fr(c).peakEvIFR(s)=0;
            data_fr(c).evFrByTrial_Hz{s}=zeros(numTrials,1);
            data_fr(c).evFrByTrial_norm{s}=zeros(numTrials,1);
            data_fr(c).trialFR{s}=zeros(numTrials,1);
        else
            % calculate instantaneous firing rate without performing the ZETA-test
            %if we simply want to plot the neuron's response, we can use:
%             figure;
            [vecTime,vecRate,sIFR] = getIFR(spikeTimesTmp,vecStimTimes);%,trialSec,2,1/1000,4,1);
            data_fr(c).zeta(s).vecTime=vecTime;
            data_fr(c).zeta(s).vecRate=vecRate;


            %   stim-evoked IFR, each USV -average and peak

            % correct for cases in which not enough spikes to calculate IFR during baseline or evoked period
            ev_idx=vecTime>evStart & vecTime<evEnd;
            if sum(ev_idx)==0
                meanEv=0;
                peakEv=0;
            else
                meanEv=mean(vecRate(ev_idx));
                peakEv=max(vecRate(ev_idx));
            end

            bl_idx=vecTime>evStart;
            if sum(bl_idx)==0
                blEv=0;
            else
                blEv=mean(vecRate(bl_idx));
            end
         
           
           

     
            data_fr(c).meanEvIFR(s)=(meanEv-blEv);%/blEv;
            data_fr(c).peakEvIFR(s)=(peakEv-blEv);%/blEv;

            %   trial-by-trial firing rate - stim-evoked, each USV
            evFrByTrial_Hz=sum(spikeRasterMS(:,ev_idx_ms),2)/evSec-sum(spikeRasterMS(:,bl_idx_ms),2)/blSec;
            evFrByTrial_norm=evFrByTrial_Hz./(sum(spikeRasterMS(:,bl_idx_ms),2)/blSec);
            data_fr(c).evFrByTrial_Hz{s}=evFrByTrial_Hz;
            data_fr(c).evFrByTrial_norm{s}=evFrByTrial_norm;

            %   mean firing rate over each trial
            data_fr(c).trialFR{s}=sum(spikeRasterMS(:,bl_idx_ms),2)/blSec;




            %% run the ZETA-test with specified parameters
            %however, we can also specify the parameters ourselves
            dblUseMaxDur = trialSec; %median(diff(vecStimulusStartTimes)); %median of trial-to-trial durations
            intResampNum = 500; %50 random resamplings should give us a good enough idea if this cell is responsive. If it's close to 0.05, we should increase this #.
            intPlot = 0;%what do we want to plot?(0=nothing, 1=inst. rate only, 2=traces only, 3=raster plot as well, 4=adds latencies in raster plot)
            intLatencyPeaks = 4; %how many latencies do we want? 1=ZETA, 2=-ZETA, 3=peak, 4=first crossing of peak half-height
            vecRestrictRange = [0 inf];%do we want to restrict the peak detection to for example the time during stimulus? Then put [0 1] here.
            boolDirectQuantile = false;%if true; uses the empirical null distribution rather than the Gumbel approximation. Note that in this case the accuracy of your p-value is limited by the # of resamplings

            %then run ZETA with those parameters
            [dblZetaP,vecLatencies,sZETA,sRate] = getZeta(spikeTimesTmp,vecStimTimes,dblUseMaxDur,intResampNum,intPlot,intLatencyPeaks,vecRestrictRange,boolDirectQuantile);
            data_fr(c).zeta(s).dblZetaP=dblZetaP;
            data_fr(c).zeta(s).dblZETA=sZETA.dblZETA;
        end
    end

    %% calculate across all trials
      numTrials=size(data(c).usv.raster_all,1);
%         stimStart=1.5-time_idx(1)/1000+((1:numTrials)-1)*6;
%         stimEnd=2.5-time_idx(1)/1000+((1:numTrials)-1)*6;
%         vecStimTimes=[stimStart',stimEnd'];
        stimStart=((1:numTrials)-1)*trialSec; % use start of each trial for calculating IFR; use corrected trial
        vecStimTimes=stimStart';
        spikeRasterMS=data(c).usv.raster_all;
        spikeRasterMS=spikeRasterMS(:,time_idx(1):time_idx(2)); % correct for shortened trial if removing sections
        [trial,ms]=find(spikeRasterMS);
        spikeTimesTmp=(ms/1000)+(trial-1)*trialSec;
   
    if numel(spikeTimesTmp)<2
        data_fr(c).zeta_all.vecTime=[];
        data_fr(c).zeta_all.vecRate=[];
        data_fr(c).zeta_all.dblZetaP=[];
        data_fr(c).zeta_all.dblZETA=[];
        data_fr(c).meanEvIFR_all=0;
        data_fr(c).peakEvIFR_all=0;
        data_fr(c).evFrByTrial_Hz_all=zeros(numTrials,1);
        data_fr(c).evFrByTrial_norm_all=zeros(numTrials,1);
        data_fr(c).trialFR_all=zeros(numTrials,1);
    else
        % calculate instantaneous firing rate without performing the ZETA-test
        %if we simply want to plot the neuron's response, we can use:
%         figure;
        [vecTime,vecRate,sIFR] = getIFR(spikeTimesTmp,vecStimTimes);%,trialSec,2,1/1000,4,1);
        data_fr(c).zeta_all.vecTime=vecTime;
        data_fr(c).zeta_all.vecRate=vecRate;


        %   stim-evoked IFR, each USV -average and peak
        
            % correct for cases in which not enough spikes to calculate IFR during baseline or evoked period
            ev_idx=vecTime>evStart & vecTime<evEnd;
            if sum(ev_idx)==0
                meanEv=0;
                peakEv=0;
            else
                meanEv=mean(vecRate(ev_idx));
                peakEv=max(vecRate(ev_idx));
            end

            bl_idx=vecTime>evStart;
            if sum(bl_idx)==0
                blEv=0;
            else
                blEv=mean(vecRate(bl_idx));
            end



        data_fr(c).meanEvIFR_all=(meanEv-blEv);%/blEv;
        data_fr(c).peakEvIFR_all=(peakEv-blEv);%/blEv;

        %   trial-by-trial firing rate - stim-evoked, each USV
        evFrByTrial_Hz=sum(spikeRasterMS(:,ev_idx_ms),2)/evSec-sum(spikeRasterMS(:,bl_idx_ms),2)/blSec;
        evFrByTrial_norm=evFrByTrial_Hz./(sum(spikeRasterMS(:,bl_idx_ms),2)/blSec);
        data_fr(c).evFrByTrial_Hz_all=evFrByTrial_Hz;
        data_fr(c).evFrByTrial_norm_all=evFrByTrial_norm;

        %   mean firing rate over each trial
        data_fr(c).trialFR_all=sum(spikeRasterMS(:,bl_idx_ms),2)/blSec;




        %% run the ZETA-test with specified parameters
        %however, we can also specify the parameters ourselves
        dblUseMaxDur = trialSec; %median(diff(vecStimulusStartTimes)); %median of trial-to-trial durations
        intResampNum = 500; %50 random resamplings should give us a good enough idea if this cell is responsive. If it's close to 0.05, we should increase this #.
        intPlot = 0;%what do we want to plot?(0=nothing, 1=inst. rate only, 2=traces only, 3=raster plot as well, 4=adds latencies in raster plot)
        intLatencyPeaks = 4; %how many latencies do we want? 1=ZETA, 2=-ZETA, 3=peak, 4=first crossing of peak half-height
        vecRestrictRange = [0 inf];%do we want to restrict the peak detection to for example the time during stimulus? Then put [0 1] here.
        boolDirectQuantile = false;%if true; uses the empirical null distribution rather than the Gumbel approximation. Note that in this case the accuracy of your p-value is limited by the # of resamplings

        %then run ZETA with those parameters
        [dblZetaP,vecLatencies,sZETA,sRate] = getZeta(spikeTimesTmp,vecStimTimes,dblUseMaxDur,intResampNum,intPlot,intLatencyPeaks,vecRestrictRange,boolDirectQuantile);
        data_fr(c).zeta_all.dblZetaP=dblZetaP;
        data_fr(c).zeta_all.dblZETA=sZETA.dblZETA;
    end
end