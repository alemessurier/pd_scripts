function make_usvRasterPSTH(spike_raster,spikesByStim,raster_all,spike_times,timeIdx,binWidth)

%% make plots for separated rasters/psth
% tones=[4,8,13,18,21,26,37,45,64];
load('/Volumes/aml717/Personal/MATLAB/pd_scripts/patch/usv_prototype_syllables.mat')
numSweeps=cellfun(@(x)size(x,1),spike_raster);
numSweeps=sum(numSweeps);
figure;
for i=1:5
    subplot(3,5,i)
    hold on
    syllables=usv_prototype_syllables{i};
    syllables=round(syllables*1000)-timeIdx(1);
    spike_raster_plot=spike_raster{i}(:,timeIdx(1):timeIdx(2));
    for s=1:size(syllables,1)
        p=patch([syllables(s,1),syllables(s,1),syllables(s,2),syllables(s,2)],[0,size(spike_raster_plot,1),size(spike_raster_plot,1),0],'g');
        p.EdgeColor='none';
        p.FaceAlpha=0.4;
    end
    plotSpikeRaster(spike_raster_plot,'PlotType','vertline')
    tmp=gca;
    tmp.XTickLabels=[];
    ylabel('trial')
    title(['call ',num2str(i)])
end

% if ~isempty(binWidth)
%     edges=timeIdx(1):binWidth:timeIdx(2);
%     binWidthSec=binWidth/1000;
%     firingRate=cellfun(@(x)(histcounts(x,edges)/(numSweeps/5))/binWidthSec,spikesByStim,'un',0);
%     edges=edges-timeIdx(1);


%     [trial,ms]=find(raster_all);
%     spikeTimesTmp=(ms)+(trial-1)*6000;
%     if ~isempty(spikeTimesTmp)
%     optN = opthist(spikeTimesTmp);
%     else
%         optN=60;
%     end
%     [~,edges]=histcounts(spikesByStim{1},optN);
%     binWidth=diff(edges);
%     binWidth=binWidth(1);
% %     binWidthSec=binWidth/1000;
%     firingRate=cellfun(@(x)(histcounts(x,optN)/(numSweeps/5)),spikesByStim,'un',0);
% 
% maxes=cellfun(@max,firingRate);
% maxhist=max(maxes);

for i=1:5
    subplot(3,5,i+5)
    hold on
   
    %     p=patch([1500,1500,2500,2500],[0,maxhist,maxhist,0],'c')
    %     p.EdgeColor='none';
    %     p.FaceAlpha=0.5;

%      [trial,ms]=find(spike_raster{i});
%     spikeTimesTmp=(ms)+(trial-1)*6000;
%     if numel(spikeTimesTmp)>2
%         optN = opthist(spikeTimesTmp);
%     else
%         optN=60;
%     end
    b(i)=histogram(spikesByStim{i},binWidth);%'BinEdges',edges,'BinCounts',firingRate{i});
    b(i).FaceColor=[0 0 0];
    b(i).FaceAlpha=0.2;
    b(i).LineWidth=1;
    tmp=gca;
    tmp.XTick=0:1000:(timeIdx(2)-timeIdx(1));
    tmp.XTickLabels=(0:1:(timeIdx(2)-timeIdx(1))/1000)-(1.5-timeIdx(1)/1000);
    xlabel('time (s)')
    ylabel('num spikes')
    maxhist(i)=max(b(i).Values);
    %     smoothed=smooth(firingRate{i},5,'lowess');
    %     smoothed=interp1(edges,smoothed,edges(1):edges(end)/(numSweeps/5):edges(end));
    %     plot(edges(1):edges(end)/(numSweeps/5):edges(end),smoothed,'g')
    % %     hist(spikeTimes,param.settings.samples/200);

    % plot instantaneous firing rate (from Jorritz et al. 2020)
  
        trialSec=(timeIdx(2)-timeIdx(1))/1000;
        spikeRasterMS=spike_raster{i}(:,timeIdx(1):timeIdx(2)); % correct for shortened trial if removing sections
        [trial,ms]=find(spikeRasterMS);
        spikeTimesTmp=(ms/1000)+(trial-1)*trialSec;
  numTrials=size(spike_raster{i},1);
        stimStart=((1:numTrials)-1)*trialSec; % use start of each trial for calculating IFR; use corrected trial
        vecStimTimes=stimStart';
    
    
    
    
    subplot(3,5,i+10)
    if numel(spikeTimesTmp)>2
    [vecTime,vecRate,sIFR] = getIFR(spikeTimesTmp,vecStimTimes,trialSec,[],[],[],0);
    maxIFR(i)=max(vecRate);
    plot(vecTime,vecRate);
    hold on
    xlabel('time, s')
    ylabel('IFR (Hz)')
    else
        maxIFR(i)=0.01;
        maxhist(i)=1;
    end
end

maxhist=max(maxhist);
maxIFR=max(maxIFR);
for i=1:5
    subplot(3,5,i+5)
 syllables=usv_prototype_syllables{i};
    syllables=round(syllables*1000)-timeIdx(1);
    tmp=gca;
    tmp.YLim=[0 maxhist];

    for s=1:size(syllables,1)
        p=patch([syllables(s,1),syllables(s,1),syllables(s,2),syllables(s,2)],[0,maxhist,maxhist,0],'g');
        p.EdgeColor='none';
        p.FaceAlpha=0.4;
    end
    
    subplot(3,5,i+10)
    tmp=gca;
    tmp.YLim=[0 maxIFR];
        

    for s=1:size(syllables,1)
        p=patch([syllables(s,1)/1000,syllables(s,1)/1000,syllables(s,2)/1000,syllables(s,2)/1000],[0,maxIFR,maxIFR,0],'g');
        p.EdgeColor='none';
        p.FaceAlpha=0.4;
    end
    tmp.XTick=0:1000:(timeIdx(2)-timeIdx(1));
    tmp.XTickLabels=(0:1:(timeIdx(2)-timeIdx(1))/1000)-(1.5-timeIdx(1)/1000);
end
% %% all usvs combined
% 
% figure;
% % subplot(2,1,1)
% 
% hold on
% 
% raster=raster_all(:,timeIdx(1):timeIdx(2));
% stimTime=1500;
% pulseLength=1000;
% p=patch([stimTime,stimTime,stimTime+pulseLength,stimTime+pulseLength],[0,size(raster,1),size(raster,1),0],'g');
% 
% p.EdgeColor='none';
% p.FaceAlpha=0.2;
% 
% LineFormat = struct()
% LineFormat.Color = [0 0 0];
% LineFormat.LineWidth = 1;
% LineFormat.LineStyle = '-';
% plotSpikeRaster(raster,'PlotType','vertline','LineFormat',LineFormat)
% tmp=gca;
% tmp.XTick=0:1000:(timeIdx(2)-timeIdx(1));
% tmp.XTickLabels=0:1:(timeIdx(2)-timeIdx(1))/1000;
% xlabel('time (s)')
% ylabel('trial')
% title('all pup calls')
% 
% 
% 
% % firingRate=(histcounts(spike_times,edges)/numSweeps);
% % 
% % maxhist=max(firingRate);
% figure
% [trial,ms]=find(raster_all);
%     spikeTimesTmp=(ms)+(trial-1)*6000;
%     if ~isempty(spikeTimesTmp)
%     optN = opthist(spikeTimesTmp);
%     else
%         optN=60;
%     end
% hold on
% 
% b=histogram(spike_times,optN);%'BinEdges',edges,'BinCounts',firingRate);
% b.FaceColor=[0 0 0];
% b.FaceAlpha=0.2;
% b.LineWidth=1;
% tmp=gca;
% tmp.XTick=0:1000:(timeIdx(2)-timeIdx(1));
% tmp.XTickLabels=0:1:(timeIdx(2)-timeIdx(1))/1000;
% xlabel('time (s)')
% ylabel('num spikes')
% 
% maxhist=max(b.Values);
% p=patch([stimTime,stimTime,stimTime+pulseLength,stimTime+pulseLength],[0,maxhist,maxhist,0],'g');
% 
% p.EdgeColor='none';
% p.FaceAlpha=0.2;
% 
% 
% 
