function [spike_raster,spikesByStim,threshold,raster_all,spike_times]=plot_toneTuning_patch(abfs,invert,freq_order,threshold)
spike_times=cell(length(abfs),1);
spikes=spike_times;
trace_idx=spikes;
for f=1:length(abfs)

    [data,si,param(f)]=abfload(abfs{f});
    numSweeps(f)=param(f).lActualEpisodes;

    sampRate=1/(si*1e-6); %sampling interval is in microseconds

    sampPerSweep(f)=param(f).sweepLengthInPts;
    timePerSweep(f)=sampPerSweep(f)/sampRate;

    if invert==1
        data=-data;
    end

    if isempty(threshold)
        [filtSweeps,threshold]=plot_by_sweep_pupCalls( data,param(f),sampRate,[],[] );
    else
        % filter data
        data_plot=squeeze(data(:,1,:))';
        for j=1:numSweeps(f)
            baseline=mean(data_plot(j,1:0.2*sampRate));
            normSweeps=double(data_plot(j,:)-baseline);
            %     filtSweeps(j,:)=bandpass(normSweeps(j,:),[100,1000],sampRate);
            filtSweeps(j,:)=genButterFilter(normSweeps,100,3000,4,'butter_acausal',sampRate);
        end
    end

    

    [spikes_tmp,spikeTimes_tmp,trace_idx_tmp] = get_spikeTimes(filtSweeps,threshold);

    if f>1
        trace_idx_tmp=trace_idx_tmp+sum(numSweeps(1:(f-1)));
    end

    spikes{f}=spikes_tmp;
    spike_times{f}=spikeTimes_tmp;
    trace_idx{f}=trace_idx_tmp;
    %     tmp=dlmread(csvs{f});
    %     tmp_trace=tmp(:,1);


end
numSweepsAll=sum(numSweeps);
spike_times=cat(2,spike_times{:});
trace_idx=cat(2,trace_idx{:});
% add in safety check that numSweeps, sampPerSweep,timePerSweep are same
% across files so we know we are concatenating files from same protocol

% convert spike times to ms
spike_times=ceil(1000*spike_times/sampRate); %round to nearest ms
raster_temp=zeros(numSweepsAll,timePerSweep(1)*1000);
for i=1:length(trace_idx)
    raster_temp(trace_idx(i),spike_times(i))=1;
end
raster=logical(raster_temp);
figure
plotSpikeRaster(raster,'PlotType','vertline');
raster_all=raster;
%% separate by stimulus type
idx_pupcall=repmat((1:9)',8,1);
for f=1:length(abfs)
    idx_pupcall_all{f}=idx_pupcall(1:numSweeps(f));
end
idx_pupcall_all=cat(1,idx_pupcall_all{:});

for j=1:9
    spike_raster{j}=raster(idx_pupcall_all==j,:);
end

spikesBySweep=cell(numSweepsAll,1);

for i=1:length(spikesBySweep)
    spikesBySweep{i}=spike_times(trace_idx==i);
end

for st=1:9
    tmp=spikesBySweep(idx_pupcall_all==st);
    spikesByStim{st}=cat(2,tmp{:});
end

%% make plots
tones=dlmread(freq_order)
tones=tones(1:9);
tones=round(tones/1000);
[tones,sortIDX]=sort(tones,'ascend');
spike_raster=spike_raster(sortIDX);
spikesByStim=spikesByStim(sortIDX);
figure;
for i=1:9
    subplot(2,9,i)
    hold on
    p=patch([202,202,252,252],[0,size(spike_raster{i},1),size(spike_raster{i},1),0],'c');
    p.EdgeColor='none';
    p.FaceAlpha=0.5;
    plotSpikeRaster(spike_raster{i},'PlotType','vertline')
    tmp=gca;
    tmp.XTickLabels=[];
    ylabel('trial')
    title([num2str(tones(i)),' kHz'])
end
edges=0:50:400;
binCount=cellfun(@(x)histcounts(x,edges)/(numSweepsAll/9),spikesByStim,'UniformOutput',0);
maxes=cellfun(@max,binCount);
maxhist=max(maxes);

for i=1:9
    subplot(2,9,i+9)
    hold on
    p=patch([202,202,252,252],[0,maxhist,maxhist,0],'c');
    p.EdgeColor='none';
    p.FaceAlpha=0.5;
    histogram(spikesByStim{i},edges)
    tmp=gca;
    tmp.XTick=0:200:400;
    tmp.XTickLabels=0:0.2:0.4;
    xlabel('time (s)')
    ylabel('avg spike count')

    % smoothed=smooth(binCount,5,'lowess');
    % smoothed=interp1(edges,smoothed,edges(1):edges(end)/size(whisk_data,2):edges(end));
    % plot(edges,smoothed,'g')
    % hist(spikeTimes,param.settings.samples/200);
end
% vline(stimTimes*param.settings.fskHz)
end

