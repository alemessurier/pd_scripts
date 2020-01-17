function plot_deltaF( deltaF,samp_rate,spacing,numCells )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
j=1;
g= figure;
% Create push button
next_btn = uicontrol('Style', 'pushbutton', 'String', 'next',...
    'Units','normalized','Position', [0.55 0.005 0.045 0.05],...
    'Callback', @next_cells);
next_btn.Value=j;
cellNames=fieldnames(deltaF);
cellNumsPlot=1:numCells;
cellsPlot=cellNames(cellNumsPlot);
plotAllCells(cellsPlot,deltaF,samp_rate,spacing)

% stimFrames=Stimuli.(fns{j}).Time;%*sampRate(5))+1;
% %         stimFrames=stimFrames(stimFrames>0);
%         labels=cat(2,stims(Stimuli.(fns{j}).Label+1));
%         labels=labels(1:length(stimFrames));
%
%         vline(stimFrames,repmat({'r:'},1,length(stimFrames)),labels);
% % axis([1 length(deltaF.(cn)) 0 (length(fns)*spacing)]);
%      scrollplot(200, 1:length(.(fn).(cn)), deltaF.(fn).(cn));



    function next_cells(source,event)
%         j=next_btn.Value;
%         
        if numCells+j*numCells<length(cellNames)
            cellNumsPlot=(1:numCells)+j*numCells;
        else
            cellNumsPlot=cellNumsPlot;
        end
        
     
        cellsPlot=cellNames(cellNumsPlot)
        j=j+1;
%         next_btn.Value=j;
        figure(g); hold off;
        plotAllCells(cellsPlot,deltaF,samp_rate,spacing)
        
    end

    function plotAllCells(cellsPlot,deltaF,samp_rate,spacing)
        for i=1:length(cellsPlot)
            
            cn = cellsPlot{i};
            
            
            time = [1:length(deltaF.(cn))]/samp_rate;
            plot(time, deltaF.(cn)+((i-1)*spacing),'k');
            hold on
        end
        set(gca,'YTick',[0:spacing:((length(cellsPlot)*spacing))])
set(gca,'YTickLabel',cellsPlot)
ylabel('Fluorescence (AU)'); xlabel('Time (seconds)');

    end
end

