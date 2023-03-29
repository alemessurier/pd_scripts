function [spike_raster,spikesByStim,threshold,raster_all,spike_times]=plot_usvTuning_patch(abfs,invert)

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
    [filtSweeps,threshold]=plot_by_sweep_pupCalls( data,param(f),sampRate,[],[]);%,-200,200 );
    data_plot=squeeze(data(:,1,:))';
    
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
raster_all=zeros(numSweepsAll,timePerSweep(1)*1000);
for i=1:length(trace_idx)
    raster_all(trace_idx(i),spike_times(i))=1;
end
raster_all=logical(raster_all);
figure
plotSpikeRaster(raster_all,'PlotType','vertline');

%% separate by stimulus type

idx_pupcall=repmat((1:5)',10,1);
idx_pupcall=[idx_pupcall;nan];
for f=1:length(abfs)
    idx_pupcall_all{f}=idx_pupcall(1:numSweeps(f));
end
idx_pupcall_all=cat(1,idx_pupcall_all{:});

for j=1:5
    spike_raster{j}=raster_all(idx_pupcall_all==j,:);
end

spikesBySweep=cell(numSweepsAll,1);

for i=1:length(spikesBySweep)
    spikesBySweep{i}=spike_times(trace_idx==i);
end

for st=1:5
    tmp=spikesBySweep(idx_pupcall_all==st);
    spikesByStim{st}=cat(2,tmp{:});
end

%% make plots
% tones=[4,8,13,18,21,26,37,45,64];
load('/Volumes/aml717/Personal/MATLAB/pd_scripts/patch/usv_prototype_syllables.mat')

figure;
for i=1:5
    subplot(2,5,i)
    hold on
    syllables=usv_prototype_syllables{i};
    syllables=round(syllables*1000);
    for s=1:size(syllables,1)
        p=patch([syllables(s,1),syllables(s,1),syllables(s,2),syllables(s,2)],[0,size(spike_raster{i},1),size(spike_raster{i},1),0],'c');
    p.EdgeColor='none';
    p.FaceAlpha=0.5;
    end
    plotSpikeRaster(spike_raster{i},'PlotType','vertline')
    tmp=gca;
    tmp.XTickLabels=[];
    ylabel('trial')
    title(['call ',num2str(i)])
end
edges=0:300:6000;
binCount=cellfun(@(x)histcounts(x,edges)/(numSweepsAll/5),spikesByStim,'un',0);
maxes=cellfun(@max,binCount);
maxhist=max(maxes);

for i=1:5
    subplot(2,5,i+5)
    hold on
      syllables=usv_prototype_syllables{i};
          syllables=round(syllables*1000);

    for s=1:size(syllables,1)
        p=patch([syllables(s,1),syllables(s,1),syllables(s,2),syllables(s,2)],[0,maxhist,maxhist,0],'c');
    p.EdgeColor='none';
    p.FaceAlpha=0.5;
    end
%     p=patch([1500,1500,2500,2500],[0,maxhist,maxhist,0],'c')
%     p.EdgeColor='none';
%     p.FaceAlpha=0.5;
    histogram(spikesByStim{i},edges)
    tmp=gca;
    tmp.XTick=0:1000:6000;
    tmp.XTickLabels=0:1:6;
    xlabel('time (s)')
    ylabel('avg spike count')
    
%     smoothed=smooth(binCount{i},5,'lowess');
% %     smoothed=interp1(edges,smoothed,edges(1):edges(end)/(numSweeps/5):edges(end));
%     plot(edges,smoothed,'g')
%     % hist(spikeTimes,param.settings.samples/200);
end
% vline(stimTimes*param.settings.fskHz)
end

