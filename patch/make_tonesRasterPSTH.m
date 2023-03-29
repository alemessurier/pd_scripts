function make_tonesRasterPSTH(spike_raster,spikesByStim,freq_order,timeIdx,binWidth)

%% make plots
tones=dlmread(freq_order);
tones=tones(1:9);
tones=round(tones/1000);
[tones,sortIDX]=sort(tones,'ascend');

numSweeps=cellfun(@(x)size(x,1),spike_raster);
numSweeps=sum(numSweeps);

figure;
for i=1:9
    subplot(3,9,i)
    hold on
    p=patch(([202,202,252,252]-timeIdx(1)),[0,size(spike_raster{i},1),size(spike_raster{i},1),0],'c');
    p.EdgeColor='none';
    p.FaceAlpha=0.5;
    plotSpikeRaster(spike_raster{i}(:,timeIdx(1):timeIdx(2)),'PlotType','vertline')
    tmp=gca;
%     tmp.XTickLabels=[];
    ylabel('trial')
    title([num2str(tones(i)),' kHz'])
end
% edges=0:binWidth:;
% binWidthSec=binWidth/1000;
% firingRate=cellfun(@(x)histcounts(x,edges)/(numSweeps/9),spikesByStim,'un',0);
% maxes=cellfun(@max,firingRate);
% maxhist=max(maxes);

for i=1:9
    subplot(3,9,i+9)
    hold on

     b(i)=histogram(spikesByStim{i},binWidth);%'BinEdges',edges,'BinCounts',firingRate{i});
    b(i).FaceColor=[0 0 0];
    b(i).FaceAlpha=0.2;
    b(i).LineWidth=1;
    tmp=gca;
    tmp.XTick=0:100:(timeIdx(2)-timeIdx(1));
    tmp.XTickLabels=(0:0.1:(timeIdx(2)-timeIdx(1))/1000)-(0.2-timeIdx(1)/1000);
    xlabel('time (s)')
    ylabel('num spikes')
    maxhist(i)=max(b(i).Values);

%     p=patch([202,202,252,252],[0,maxhist,maxhist,0],'c');
%     p.EdgeColor='none';
%     p.FaceAlpha=0.5;
%     b=histogram(firingRate{i},edges);
%     b.FaceColor=[0 0 0];
%     b.FaceAlpha=0.2;
%     b.LineWidth=1;
%     tmp=gca;
%     tmp.XTick=0:200:400;
%     tmp.XTickLabels=0:0.2:0.4;
%     xlabel('time (s)')
%     ylabel('avg spike count')
   


 % plot instantaneous firing rate (from Jorritz et al. 2020)
  
        trialSec=(timeIdx(2)-timeIdx(1))/1000;
        spikeRasterMS=spike_raster{i}(:,timeIdx(1):timeIdx(2)); % correct for shortened trial if removing sections
        [trial,ms]=find(spikeRasterMS);
        spikeTimesTmp=(ms/1000)+(trial-1)*trialSec;
  numTrials=size(spike_raster{i},1);
        stimStart=((1:numTrials)-1)*trialSec; % use start of each trial for calculating IFR; use corrected trial
        vecStimTimes=stimStart';
    
    
    
    
    subplot(3,9,i+18)
    if numel(spikeTimesTmp)>2
    [vecTime,vecRate,sIFR] = getIFR(spikeTimesTmp,vecStimTimes,trialSec,[],[],[],0);
    maxIFR(i)=max(vecRate);
    minIFR(i)=min(vecRate);
    plot(vecTime,vecRate);
    hold on
    xlabel('time, s')
    ylabel('IFR (Hz)')
    else
        maxIFR(i)=0.01;
        minIFR(i)=0
        maxhist(i)=1;
    end

end
maxhist=max(maxhist);
maxIFR=max(maxIFR);
minIFR=min(minIFR)
for i=1:9
    subplot(3,9,i+9)
         p=patch(([202,202,252,252]-timeIdx(1)),[0,maxhist,maxhist,0],'c');


     p.EdgeColor='none';
     p.FaceAlpha=0.5;
    tmp=gca;
    tmp.YLim=[0 maxhist];

   
    
    subplot(3,9,i+18)
    p=patch(([0.2,0.2,0.25,0.25]-timeIdx(1)/1000),[minIFR,maxIFR,maxIFR,minIFR],'c');
    tmp=gca;
    tmp.YLim=[0 maxIFR];
     p.EdgeColor='none';
     p.FaceAlpha=0.5;

    
    tmp.XTick=0:0.1:(timeIdx(2)-timeIdx(1))/1000;
    tmp.XTickLabels=(0:0.1:(timeIdx(2)-timeIdx(1))/1000)-(0.2-timeIdx(1)/1000);
end
% vline(stimTimes*param.settings.fskHz)