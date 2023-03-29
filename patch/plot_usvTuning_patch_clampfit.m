function plot_usvTuning_patch_clampfit(abfs,csvs)
trace_idx=[];
spike_times=[];
for f=1:length(abfs)
    
    [~,~,param(f)]=abfload(abfs{f});
    tmp=dlmread(csvs{f});
    tmp_trace=tmp(:,1);
    numSweeps(f)=param.lActualEpisodes;
    if ~isempty(trace_idx)
        tmp_trace=tmp_trace+sum(numSweeps(1:(f-1)));
    end
    trace_idx=[trace_idx; tmp_trace];
    spike_times=[spike_times; tmp(:,2)];
    sampRate=20000;
    
    sampPerSweep(f)=param.sweepLengthInPts;
    timePerSweep(f)=sampPerSweep(f)/sampRate;
    
end
numSweeps=sum(numSweeps);

% add in safety check that numSweeps, sampPerSweep,timePerSweep are same
% across files so we know we are concatenating files from same protocol

spike_times=round(spike_times);
raster_temp=zeros(numSweeps,timePerSweep(1)*1000);
for i=1:length(trace_idx)
    raster_temp(trace_idx(i),spike_times(i))=1;
end
raster=logical(raster_temp);
figure
plotSpikeRaster(raster,'PlotType','vertline');

%% separate by stimulus type
idx_pupcall=repmat((1:5)',10,1);
idx_pupcall=[idx_pupcall;nan];
idx_pupcall=repmat(idx_pupcall,length(abfs),1);

for j=1:5
    spikes{j}=raster(idx_pupcall==j,:);
end

spikesBySweep=cell(numSweeps,1);

for i=1:length(spikesBySweep)
    spikesBySweep{i}=spike_times(trace_idx==i);
end

for st=1:5
    tmp=spikesBySweep(idx_pupcall==st);
    spikesByStim{st}=cat(1,tmp{:});
end

%% make plots
% tones=[4,8,13,18,21,26,37,45,64];


figure;
for i=1:5
    subplot(2,5,i)
    hold on
    p=patch([1500,1500,2500,2500],[0,size(spikes{i},1),size(spikes{i},1),0],'c');
    p.EdgeColor='none';
    p.FaceAlpha=0.5;
    plotSpikeRaster(spikes{i},'PlotType','vertline')
    tmp=gca;
    tmp.XTickLabels=[];
    ylabel('trial')
    title(['call ',num2str(i)])
end
edges=0:60:6000;
binCount=cellfun(@(x)histc(x,edges)/(numSweeps/5),spikesByStim,'un',0);
maxes=cellfun(@max,binCount);
maxhist=max(maxes);

for i=1:5
    subplot(2,5,i+5)
    hold on
    p=patch([1500,1500,2500,2500],[0,maxhist,maxhist,0],'c')
    p.EdgeColor='none';
    p.FaceAlpha=0.5;
    bar(edges,binCount{i},'histc')
    tmp=gca;
    tmp.XTick=0:1000:6000;
    tmp.XTickLabels=0:1:6;
    xlabel('time (s)')
    ylabel('avg spike count')
    
    % smoothed=smooth(binCount,5,'lowess');
    % smoothed=interp1(edges,smoothed,edges(1):edges(end)/size(whisk_data,2):edges(end));
    % plot(edges,smoothed,'g')
    % hist(spikeTimes,param.settings.samples/200);
end
% vline(stimTimes*param.settings.fskHz)
end

