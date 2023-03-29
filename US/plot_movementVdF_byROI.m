function  plot_movementVdF_byROI( match_vid_2p,frameRate_2p,frameRate_vid)
%GUI that loops through all ROIs, plotting raw fluorecence time series for
%ROI mask, neuropil mask, and ROI fluorescence post neuropil subtraction.
%black is ROI, red is mask, blue is subtraction

j=1;
g=figure; hold on
s1=subplot(1,2,1);
% s1.NextPlot='replaceall';

plotAllReps(match_vid_2p.dF{j},frameRate_2p,1)
      
s2=subplot(1,2,2);
plotAllReps(match_vid_2p.nose_posZ,frameRate_vid,2)

% Create push button
next_btn = uicontrol('Style', 'pushbutton', 'String', 'next',...
    'Units','normalized','Position', [0.55 0.005 0.045 0.05],...
    'Callback', @plot_ROI);







% Pause until figure is closed ---------------------------------------%
waitfor(g);

% ROIs_exclude=cellNames(inds_ex);
% for k=1:length(fns)
%     filtTimeSeries_new.(fns{k})=rmfield(filtTimeSeries.(fns{k}),ROIs_exclude);
%     npfiltTimeSeries_new.(fns{k})=rmfield(npfiltTimeSeries.(fns{k}),ROIs_exclude);
% end

    function plot_ROI(source,event)
        j=j+1;
       s1=subplot(1,2,1);
% s1.NextPlot='replaceall';
hold off
plotAllReps(match_vid_2p.dF{j},frameRate_2p,1)

    end
function plotAllReps(dF,samp_rate,spacing)
      time = (1:size(dF,1))/samp_rate;
     
        for i=1:size(dF,2)
             hold on
            plot(time, dF(:,i)+((i-1)*spacing),'k','LineWidth',0.75);
            
        end
%         set(gca,'YTick',[0:spacing:((length(cellsPlot)*spacing))])
% set(gca,'YTickLabel',cellsPlot)
% ylabel('Fluorescence (AU)'); xlabel('Time (seconds)');

    end
    
end
