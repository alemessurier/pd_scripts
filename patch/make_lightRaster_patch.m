function make_lightRaster_patch(raster,spike_times,stimTime,timeIdx,binWidth,pulseLength,LineWidth)

%%

raster=raster(:,timeIdx(1):timeIdx(2));
stimTime=stimTime-timeIdx(1);
sweepTime=size(raster,2);
 LineFormat = struct()
                LineFormat.Color = [0 0 0];
                LineFormat.LineWidth = LineWidth;
                LineFormat.LineStyle = '-';
figure;
s(1)=subplot(2,1,1); hold on
 p=patch([stimTime,stimTime,stimTime+pulseLength,stimTime+pulseLength],[0,size(raster,1),size(raster,1),0],'b');
    p.EdgeColor='none';
    p.FaceAlpha=0.2;
    plotSpikeRaster(raster,'PlotType','vertline','LineFormat',LineFormat)
%     tmp=gca;
%     tmp.XTickLabels=[];
%     tmp.XTick=(stimTime-500):100:(stimTime+500);
    ylabel('trial')
    
    
    edges=0:binWidth:sweepTime;
    numSweeps=size(raster,1);
binCount=histcounts(spike_times,edges)/numSweeps;
maxhist=max(binCount);

s(2)=subplot(2,1,2);    hold on
    p=patch([stimTime,stimTime,stimTime+pulseLength,stimTime+pulseLength],[0,maxhist,maxhist,0],'b')
    p.EdgeColor='none';
    p.FaceAlpha=0.2;
    b=histogram(spike_times,'BinWidth',binWidth);
    b.FaceColor=[0 0 0];
    b.FaceAlpha=0.2;
    b.LineWidth=1;
    tmp=gca;
%     tmp.XTick=(stimTime-500):100:(stimTime+500);
    tmp.XTickLabels=tmp.XTick-stimTime;
    xlabel('time (ms)')
    ylabel('avg spike count')
    
    % smoothed=smooth(binCount,5,'lowess');
    % smoothed=interp1(edges,smoothed,edges(1):edges(end)/size(whisk_data,2):edges(end));
    % plot(edges,smoothed,'g')

    linkaxes(s,'x')
end

