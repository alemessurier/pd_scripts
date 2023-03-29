function plot_raw_deltaF( deltaF_all,samp_rate,spacing,stimFrames )
% INPUTS:   
%       deltaF_all  -   MxN array of dF/F traces, where M is each ROI an N
%                       is frames
%       samp_rate   -   frame rate
%       spacing     -   how far apart to space traces in plot
%       stimFrames  -   frame numbers on which stimuli occurred. input []
%                       if no stimuli

numCells=size(deltaF_all,1);
numFrames=size(deltaF_all,2);
time = (1:numFrames)/samp_rate;
for i=1:numCells
    plot(time, deltaF_all(i,:)'+((i-1)*spacing),'k');
    hold on
end
% stimFrames=Stimuli.(fns{j}).Time;%*sampRate(5))+1;
% %         stimFrames=stimFrames(stimFrames>0);
%         labels=cat(2,stims(Stimuli.(fns{j}).Label+1));
%         labels=labels(1:length(stimFrames));
stimFrames=stimFrames/samp_rate;
if ~isempty(stimFrames)
        vline(stimFrames,repmat({'r:'},1,length(stimFrames)));
end
    ylabel('Fluorescence (AU)'); xlabel('Time (seconds)');
% axis([1 length(rawTimeSeries.(fn).(cn)) 0 (length(fns)*spacing)]);
%      scrollplot(200, 1:length(deltaF.(fn).(cn)), deltaF.(fn).(cn));


set(gca,'YTick',[0:spacing:(numCells*spacing)])
% set(gca,'YTickLabel',num2str(1:numCells))
% title([num2str(j),'/',num2str(length(fns))])
end

