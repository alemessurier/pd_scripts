%%
load('/Users/aml717/Desktop/patch/corticocollicular_reduced.mat')
opto_idx=arrayfun(@(x)strcmp(x.notes,'tagged'),metadata)
data_optotagged=data(opto_idx);

%%
for c=1:length(data_optotagged)
    make_usvRasterPSTH(data_optotagged(c).usv.spike_raster,...
        data_optotagged(c).usv.spikesByStim,data_optotagged(c).usv.raster_all,...
        data_optotagged(c).usv.spike_times,[100 6000],50)
end


% make_lightRaster_patch(data_optotagged(c).optoID.raster20,...
%     data_optotagged(c).optoID.spike_times20,data_optotagged(c).optoID.stimTime,[50 ,binWidth,pulseLength,LineWidth)
%% format spike_times for zeta test usv

for c=1:length(data_optotagged)
    IFR=figure; hold on
    numTrials=size(data_optotagged(c).usv.spike_raster{1},1);
    stimStart=1.5+((1:numTrials)-1)*6;
    stimEnd=2.5+((1:numTrials)-1)*6;
    vecStimTimes=[stimStart',stimEnd'];
    numUSVs=length(data_optotagged(c).usv.spikesByStim);
    for s=1:numUSVs
        spikeRasterMS=data_optotagged(c).usv.spike_raster{s};
        [trial,ms]=find(spikeRasterMS);
        spikeTimesTmp=(ms/1000)+(trial-1)*6;
        if numel(spikeTimesTmp)<2
            data_optotagged(c).usv.zeta(s).vecTime=[];
            data_optotagged(c).usv.zeta(s).vecRate=[];
            data_optotagged(c).usv.zeta(s).dblZetaP=[];
            data_optotagged(c).usv.zeta(s).dblZETA=[];
        else
            % calculate instantaneous firing rate without performing the ZETA-test
            %if we simply want to plot the neuron's response, we can use:
            [vecTime,vecRate,sIFR] = getIFR(spikeTimesTmp,vecStimTimes);
            data_optotagged(c).usv.zeta(s).vecTime=vecTime;
            data_optotagged(c).usv.zeta(s).vecRate=vecRate;
            figure(IFR)
            subplot(1,numUSVs,s)
            plot(vecTime,vecRate);
            xlabel('time from stim onset')
            ylabel('instantaneous FR (hz)')
            %% run the ZETA-test with specified parameters
            %however, we can also specify the parameters ourselves
            dblUseMaxDur = 6; %median(diff(vecStimulusStartTimes)); %median of trial-to-trial durations
            intResampNum = 500; %50 random resamplings should give us a good enough idea if this cell is responsive. If it's close to 0.05, we should increase this #.
            intPlot = 3;%what do we want to plot?(0=nothing, 1=inst. rate only, 2=traces only, 3=raster plot as well, 4=adds latencies in raster plot)
            intLatencyPeaks = 4; %how many latencies do we want? 1=ZETA, 2=-ZETA, 3=peak, 4=first crossing of peak half-height
            vecRestrictRange = [0 inf];%do we want to restrict the peak detection to for example the time during stimulus? Then put [0 1] here.
            boolDirectQuantile = false;%if true; uses the empirical null distribution rather than the Gumbel approximation. Note that in this case the accuracy of your p-value is limited by the # of resamplings

            %then run ZETA with those parameters
            [dblZetaP,vecLatencies,sZETA,sRate] = getZeta(spikeTimesTmp,vecStimTimes,dblUseMaxDur,intResampNum,intPlot,intLatencyPeaks,vecRestrictRange,boolDirectQuantile);
            data_optotagged(c).usv.zeta(s).dblZetaP=dblZetaP;
            data_optotagged(c).usv.zeta(s).dblZETA=sZETA.dblZETA;
        end
    end
end

%% format spike_times for zeta test tones

for c=7:8%1:length(data_optotagged)
    IFR=figure; hold on
    numTrials=size(data_optotagged(c).tones.spike_raster{1},1);
    stimStart=0.2+((1:numTrials)-1)*0.4;
    stimEnd=0.25+((1:numTrials)-1)*0.4;
    vecStimTimes=[stimStart',stimEnd'];
    numTones=length(data_optotagged(c).tones.spikesByStim);
    for s=1:numTones
        spikeRasterMS=data_optotagged(c).tones.spike_raster{s};
        [trial,ms]=find(spikeRasterMS);
        spikeTimesTmp=(ms/1000)+(trial-1)*0.4;

        if isempty(spikeTimesTmp)
            data_optotagged(c).tones.zeta(s).vecTime=[];
            data_optotagged(c).tones.zeta(s).vecRate=[];
            data_optotagged(c).tones.zeta(s).dblZetaP=[];
            data_optotagged(c).tones.zeta(s).dblZETA=[];
        else
            % calculate instantaneous firing rate without performing the ZETA-test
            %if we simply want to plot the neuron's response, we can use:
            [vecTime,vecRate,sIFR] = getIFR(spikeTimesTmp,vecStimTimes);
            data_optotagged(c).tones.zeta(s).vecTime=vecTime;
            data_optotagged(c).tones.zeta(s).vecRate=vecRate;
            figure(IFR)
            subplot(1,numTones,s)
            plot(vecTime,vecRate);
            xlabel('time from stim onset')
            ylabel('instantaneous FR (hz)')
            %% run the ZETA-test with specified parameters
            %however, we can also specify the parameters ourselves
            dblUseMaxDur = 0.4; %median(diff(vecStimulusStartTimes)); %median of trial-to-trial durations
            intResampNum = 500; %50 random resamplings should give us a good enough idea if this cell is responsive. If it's close to 0.05, we should increase this #.
            intPlot = 3;%what do we want to plot?(0=nothing, 1=inst. rate only, 2=traces only, 3=raster plot as well, 4=adds latencies in raster plot)
            intLatencyPeaks = 4; %how many latencies do we want? 1=ZETA, 2=-ZETA, 3=peak, 4=first crossing of peak half-height
            vecRestrictRange = [0 inf];%do we want to restrict the peak detection to for example the time during stimulus? Then put [0 1] here.
            boolDirectQuantile = false;%if true; uses the empirical null distribution rather than the Gumbel approximation. Note that in this case the accuracy of your p-value is limited by the # of resamplings

            %then run ZETA with those parameters
            [dblZetaP,vecLatencies,sZETA,sRate] = getZeta(spikeTimesTmp,vecStimTimes,dblUseMaxDur,intResampNum,intPlot,intLatencyPeaks,vecRestrictRange,boolDirectQuantile);
            data_optotagged(c).tones.zeta(s).dblZetaP=dblZetaP;
            data_optotagged(c).tones.zeta(s).dblZETA=sZETA.dblZETA;
        end
    end
end

%% format spike_times for zeta test usv - all stims

for c=1:length(data_optotagged)
    IFR=figure; hold on
    numTrials=size(data_optotagged(c).usv.raster_all,1);
    stimStart=1.5+((1:numTrials)-1)*6;
    stimEnd=2.5+((1:numTrials)-1)*6;
    vecStimTimes=[stimStart',stimEnd'];
    
        spikeRasterMS=data_optotagged(c).usv.raster_all;
        [trial,ms]=find(spikeRasterMS);
        spikeTimesTmp=(ms/1000)+(trial-1)*6;
        if numel(spikeTimesTmp)<2
            data_optotagged(c).usv.zeta_all.vecTime=[];
            data_optotagged(c).usv.zeta_all.vecRate=[];
            data_optotagged(c).usv.zeta_all.dblZetaP=[];
            data_optotagged(c).usv.zeta_all.dblZETA=[];
        else
            % calculate instantaneous firing rate without performing the ZETA-test
            %if we simply want to plot the neuron's response, we can use:
            [vecTime,vecRate,sIFR] = getIFR(spikeTimesTmp,vecStimTimes);
            data_optotagged(c).usv.zeta_all.vecTime=vecTime;
            data_optotagged(c).usv.zeta_all.vecRate=vecRate;
            figure(IFR)
            plot(vecTime,vecRate);
            xlabel('time from stim onset')
            ylabel('instantaneous FR (hz)')
            %% run the ZETA-test with specified parameters
            %however, we can also specify the parameters ourselves
            dblUseMaxDur = 6; %median(diff(vecStimulusStartTimes)); %median of trial-to-trial durations
            intResampNum = 10000; %50 random resamplings should give us a good enough idea if this cell is responsive. If it's close to 0.05, we should increase this #.
            intPlot = 3;%what do we want to plot?(0=nothing, 1=inst. rate only, 2=traces only, 3=raster plot as well, 4=adds latencies in raster plot)
            intLatencyPeaks = 4; %how many latencies do we want? 1=ZETA, 2=-ZETA, 3=peak, 4=first crossing of peak half-height
            vecRestrictRange = [0 inf];%do we want to restrict the peak detection to for example the time during stimulus? Then put [0 1] here.
            boolDirectQuantile = true;%if true; uses the empirical null distribution rather than the Gumbel approximation. Note that in this case the accuracy of your p-value is limited by the # of resamplings

            %then run ZETA with those parameters
            [dblZetaP,vecLatencies,sZETA,sRate] = getZeta(spikeTimesTmp,vecStimTimes,dblUseMaxDur,intResampNum,intPlot,intLatencyPeaks,vecRestrictRange,boolDirectQuantile);
            data_optotagged(c).usv.zeta_all.dblZetaP=dblZetaP;
            data_optotagged(c).usv.zeta_all.dblZETA=sZETA.dblZETA;
        end
    
end
%%
[optN, dblC, allN, allC] = opthist(spikeTimesTmp);

%% format spike_times for zeta test opto 20 ms

for c=1:length(data_optotagged)
%     IFR=figure; hold on
    numTrials=size(data_optotagged(c).optoID.raster20,1);
    stimStart=0.315+((1:numTrials)-1)*1;
    stimEnd=0.335+((1:numTrials)-1)*1;
    vecStimTimes=[stimStart',stimEnd'];
    
        spikeRasterMS=data_optotagged(c).optoID.raster20;
        [trial,ms]=find(spikeRasterMS);
        spikeTimesTmp=(ms/1000)+(trial-1)*1;
        if numel(spikeTimesTmp)<2
            data_optotagged(c).optoID.zeta_20ms.vecTime=[];
            data_optotagged(c).optoID.zeta_20ms.vecRate=[];
            data_optotagged(c).optoID.zeta_20ms.dblZetaP=[];
            data_optotagged(c).optoID.zeta_20ms.dblZETA=[];
        else
            % calculate instantaneous firing rate without performing the ZETA-test
            %if we simply want to plot the neuron's response, we can use:
            [vecTime,vecRate,sIFR] = getIFR(spikeTimesTmp,vecStimTimes);
            data_optotagged(c).optoID.zeta_20ms.vecTime=vecTime;
            data_optotagged(c).optoID.zeta_20ms.vecRate=vecRate;
%             figure(IFR)
%             plot(vecTime,vecRate);
%             xlabel('time from stim onset')
%             ylabel('instantaneous FR (hz)')
            %% run the ZETA-test with specified parameters
            %however, we can also specify the parameters ourselves
            dblUseMaxDur = 1; %median(diff(vecStimulusStartTimes)); %median of trial-to-trial durations
            intResampNum = 500; %50 random resamplings should give us a good enough idea if this cell is responsive. If it's close to 0.05, we should increase this #.
            intPlot = 3;%what do we want to plot?(0=nothing, 1=inst. rate only, 2=traces only, 3=raster plot as well, 4=adds latencies in raster plot)
            intLatencyPeaks = 4; %how many latencies do we want? 1=ZETA, 2=-ZETA, 3=peak, 4=first crossing of peak half-height
            vecRestrictRange = [0 inf];%do we want to restrict the peak detection to for example the time during stimulus? Then put [0 1] here.
            boolDirectQuantile = false;%if true; uses the empirical null distribution rather than the Gumbel approximation. Note that in this case the accuracy of your p-value is limited by the # of resamplings

            %then run ZETA with those parameters
            [dblZetaP,vecLatencies,sZETA,sRate] = getZeta(spikeTimesTmp,vecStimTimes,dblUseMaxDur,intResampNum,intPlot,intLatencyPeaks,vecRestrictRange,boolDirectQuantile);
            data_optotagged(c).optoID.zeta_20ms.dblZetaP=dblZetaP;
            data_optotagged(c).optoID.zeta_20ms.dblZETA=sZETA.dblZETA;
        end
    
end