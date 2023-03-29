function [raster,spike_times,threshold]=plot_lightResponse_patch(abfs,stimTime,pulseLength,invert)
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
    [filtSweeps,threshold]=plot_by_sweep_pupCalls( data,param,sampRate,[],[]);
    data_plot=squeeze(data(:,1,:))';
    
    [spikes_tmp,spikeTimes_tmp,trace_idx_tmp] = get_spikeTimes(filtSweeps,threshold);
    
    if f>1
        trace_idx_tmp=trace_idx_tmp+sum(numSweeps(1:(f-1)));
    end
    
    spikes{f}=spikes_tmp;
    spike_times{f}=spikeTimes_tmp;
    trace_idx{f}=trace_idx_tmp;
  
end
numSweeps=sum(numSweeps);
spike_times=cat(2,spike_times{:});
trace_idx=cat(2,trace_idx{:});
% add in safety check that numSweeps, sampPerSweep,timePerSweep are same
% across files so we know we are concatenating files from same protocol

% convert spike times to ms
spike_times=ceil(1000*spike_times/sampRate); %round to nearest ms
raster_temp=zeros(numSweeps,timePerSweep(1)*1000);
for i=1:length(trace_idx)
    raster_temp(trace_idx(i),spike_times(i))=1;
end
raster=logical(raster_temp);
%%
figure;
subplot(1,2,1); hold on
 p=patch([stimTime,stimTime,stimTime+pulseLength,stimTime+pulseLength],[0,size(raster,1),size(raster,1),0],'b');
    p.EdgeColor='none';
    p.FaceAlpha=0.5;
    plotSpikeRaster(raster,'PlotType','vertline')
    tmp=gca;
    tmp.XTickLabels=[];
    ylabel('trial')
    
    
    edges=0:50:2000;
binCount=histcounts(spike_times,edges)/numSweeps;
maxhist=max(binCount);

subplot(1,2,2);    hold on
    p=patch([stimTime,stimTime,stimTime+pulseLength,stimTime+pulseLength],[0,maxhist,maxhist,0],'b')
    p.EdgeColor='none';
    p.FaceAlpha=0.5;
    histogram(spike_times,edges)
    tmp=gca;
    tmp.XTick=0:500:2000;
    tmp.XTickLabels=0:0.5:2;
    xlabel('time (s)')
    ylabel('avg spike count')
    
    % smoothed=smooth(binCount,5,'lowess');
    % smoothed=interp1(edges,smoothed,edges(1):edges(end)/size(whisk_data,2):edges(end));
    % plot(edges,smoothed,'g')

end

