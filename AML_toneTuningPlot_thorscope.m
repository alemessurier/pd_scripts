function AML_toneTuningPlot_thorscope( tuning )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% only include cells with significant tone responses
j=1
%     tonesPlot=find(tuningcurve.h(:,cellnum)==1);
   
    fig=figure; hold on
    subplot(1,3,1)
   
    plotTuning(tuning(j))
    axis square
    title(tuning(j).cellName)
    subplot(1,3,2)
    meanPlusTracePlot(tuning(j));
    axis square
    subplot(1,3,3)
    [~,bfind]=max(tuning(j).median);
    trials=tuning(j).byTone{bfind};
    plotAllReps(trials)
    axis square
    fig.Position= [50 50 1584 523];

    % Create push button
next_btn = uicontrol('Style', 'pushbutton', 'String', 'next',...
    'Units','normalized','Position', [0.55 0.005 0.045 0.05],...
    'Callback', @plot_ROI);



waitfor(fig)

    function plotAllReps(trials)
        imagesc(trials);
        tmp=gca;
%          time=((1:size(trials.df,1))/3.91)-4/3.91;
          tmp.XTick=[];
%      tmp.XTickLabel='tone onset'
%      tmp.XTickLabelRotation=45;
     tmp.YTick=[];
     ylabel('best frequency presentations');
%     xlabel(['best frequency =',num2str(trials.tone)])
        colormap gray
%         vline(3.5,'g','onset')
    end
    function plotTuning(tuning)
        tones=tuning.tones;
        numtones=length(tones);
            sem=tuning.sem;
    errorbar(1:length(sem),tuning.median,sem, 'k', 'LineWidth', 2); 
    set(gca,'XTick', 1:1:numtones, 'XTickLabel', round(tones./1000, 3, 'significant')); 
    ylabel('median dF/F')
    a=gca;
    a.XTickLabelRotation=45;
xlabel('frequency (kHz)');
    end

function meanPlusTracePlot( tuning )
    tones=[tuning.tones];
    med_trace=cellfun(@(x)median(x,1),tuning.byTone,'un',0);
    med_trace=cat(1,med_trace{:});
    cmap=morgenstemning(length(tones)+3);
    time=((1:size(med_trace,2))/30)-1/30;
    p(1)=plot(time,med_trace(1,:),'Color',cmap(1,:));
    for i=2:length(tones)
        hold on
        p(i)=plot(time,med_trace(i,:),'Color',cmap(i,:));
    end
%     legend([p(1) p(5) p(9) p(13) p(17)],'4 kHz','8','16', '32','64')
   xlabel('time from tone onset')
   ylabel('median dF/F')
   hold off
end


    function plot_ROI(source,event)
        j=j+1;
        if j<=length(tuning)
            figure(fig); hold off
            fig.NextPlot='replacechildren';
            subplot(1,3,1)
   
    plotTuning(tuning(j))
    axis square
    title(tuning(j).cellName)
    subplot(1,3,2)
    meanPlusTracePlot(tuning(j));
    axis square
    subplot(1,3,3)
    [~,bfind]=max(tuning(j).median);
    trials=tuning(j).byTone{bfind};
    plotAllReps(trials)
    axis square
    fig.Position= [50 50 1584 523];
        end
    end
end
