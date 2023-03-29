 [data,si,param]=abfload('/Volumes/pupcalls2/patch/20220121/2022_01_21_0012.abf');
tmp=dlmread('F:\patch\21122005.csv');
trace_idx=tmp(:,1);
spike_times=tmp(:,2);
sampRate=20000;
numSweeps=param.lActualEpisodes;
sampPerSweep=param.sweepLengthInPts;
timePerSweep=sampPerSweep/sampRate;
sweep_time=0:0.001:6;

spike_times=round(spike_times);
raster_temp=zeros(numSweeps,timePerSweep);
for i=1:length(trace_idx)
    raster_temp(trace_idx(i),spike_times(i))=1;
end
raster=logical(raster_temp);
% plotSpikeRaster(raster,'PlotType','vertline');

%% separate by stimulus type
idx_pupcall=repmat((1:5)',10,1);

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
binCount=cellfun(@(x)histc(x,edges)/10,spikesByStim,'un',0);
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