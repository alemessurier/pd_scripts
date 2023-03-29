abfs={'F:\patch\20210211\21211005.abf','F:\patch\20210211\21211006.abf','F:\patch\20210211\21211008.abf','F:\patch\20210211\21211009.abf'};
csvs={'F:\patch\20210211\21211005_spikes.csv','F:\patch\20210211\21211006_spikes.csv','F:\patch\20210211\21211008_spikes.csv','F:\patch\20210211\21211009_spikes.csv'}

trace_idx=[];
spike_times=[];
for f=1:length(abfs)
    
    [~,~,param(f)]=abfload(abfs{f});
    tmp=dlmread(csvs{f});
    tmp_trace=tmp(:,1);
    if ~isempty(trace_idx)
        tmp_trace=tmp_trace+max(trace_idx);
    end
    trace_idx=[trace_idx; tmp_trace];
    spike_times=[spike_times; tmp(:,2)];
    sampRate=20000;
    numSweeps(f)=param.lActualEpisodes;
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
plotSpikeRaster(raster,'PlotType','vertline');

%% separate by stimulus type
idx_pupcall=repmat((1:9)',numSweeps/9,1);

for j=1:9
    spikes{j}=raster(idx_pupcall==j,:);
end

spikesBySweep=cell(numSweeps,1);

for i=1:length(spikesBySweep)
    spikesBySweep{i}=spike_times(trace_idx==i);
end

for st=1:9
    tmp=spikesBySweep(idx_pupcall==st);
    spikesByStim{st}=cat(1,tmp{:});
end

%% make plots
tones=[4,8,13,18,21,26,37,45,64];


figure;
for i=1:9
    subplot(2,9,i)
    hold on
    p=patch([202,202,252,252],[0,size(spikes{i},1),size(spikes{i},1),0],'c');
    p.EdgeColor='none';
    p.FaceAlpha=0.5;
    plotSpikeRaster(spikes{i},'PlotType','vertline')
    tmp=gca;
    tmp.XTickLabels=[];
    ylabel('trial')
    title([num2str(tones(i)),' kHz'])
end
edges=0:10:400;
binCount=cellfun(@(x)histc(x,edges)/(numSweeps/9),spikesByStim,'un',0);
maxes=cellfun(@max,binCount);
maxhist=max(maxes);

for i=1:9
    subplot(2,9,i+9)
    hold on
    p=patch([202,202,252,252],[0,maxhist,maxhist,0],'c')
    p.EdgeColor='none';
    p.FaceAlpha=0.5;
    bar(edges,binCount{i},'histc')
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