function AML_toneTuningPlot( tuningcurve,fftrials )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% only include cells with significant tone responses
numcells=size(fftrials,2);
responsive_idx=find(sum(tuningcurve.h,1)>0);

for i=1:length(responsive_idx)
    cellnum=responsive_idx(i);
    tonesPlot=find(tuningcurve.h(:,cellnum)==1);
    alltrials=fftrials(:,cellnum);
    figure; hold on
    subplot(1,3,1)
    numpertone=size(alltrials(1).df,2);
    plotTuning(tuningcurve,cellnum,numpertone)
    title(['cell ',num2str(cellnum)])
    subplot(1,3,2)
    meanPlusTracePlot(alltrials);
    subplot(1,3,3)
    [~,bfind]=max(tuningcurve.med(:,cellnum));
    trials=fftrials(bfind,cellnum);
    plotAllReps(trials)
end


    function plotAllReps(trials)
        imagesc(trials.df');
        tmp=gca;
%          time=((1:size(trials.df,1))/3.91)-4/3.91;
          tmp.XTick=[];
%      tmp.XTickLabel='tone onset'
%      tmp.XTickLabelRotation=45;
     tmp.YTick=[];
     ylabel('stim presentations');
    xlabel(['best frequency =',num2str(trials.tone)])
        colormap gray
        vline(3.5,'g','onset')
    end
    function plotTuning(tuningcurve,cell,numpertone)
        tones=tuningcurve.tone;
        numtones=length(tones);
            sem=tuningcurve.std(:,cell)/sqrt(numpertone);
    errorbar(1:17,tuningcurve.med(:,cell),sem, 'k', 'LineWidth', 2); 
    set(gca,'XTick', 1:1:numtones, 'XTickLabel', round(tones./1000, 3, 'significant')); 
    ylabel('median df/f')
    a=gca;
    a.XTickLabelRotation=45;
xlabel('frequency (kHz)');
    end

function meanPlusTracePlot( alltrials )
    tones=[alltrials(:).tone];
    med_trace=arrayfun(@(x)median(x.df,2),alltrials,'un',0);
    med_trace=cat(2,med_trace{:});
    cmap=morgenstemning(length(tones)+3);
    time=((1:size(med_trace,1))/3.91)-4/3.91;
    for i=1:length(tones)
        hold on
        p(i)=plot(time,med_trace(:,i),'Color',cmap(i,:));
    end
    legend([p(1) p(5) p(9) p(13) p(17)],'4 kHz','8','16', '32','64')
   xlabel('time from tone onset')
   ylabel('median df/f')
end
end
