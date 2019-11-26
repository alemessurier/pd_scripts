function plot_raw_deltaF( deltaF_all,samp_rate,spacing,stimFrames )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

numCells=size(deltaF_all,2);
numFrames=size(deltaF_all,1);
time = (1:numFrames)/samp_rate;
for i=1:numCells
    plot(time, deltaF_all(:,i)'+((i-1)*spacing),'k');
    hold on
end
% stimFrames=Stimuli.(fns{j}).Time;%*sampRate(5))+1;
% %         stimFrames=stimFrames(stimFrames>0);
%         labels=cat(2,stims(Stimuli.(fns{j}).Label+1));
%         labels=labels(1:length(stimFrames));
stimFrames=stimFrames/samp_rate;         
        vline(stimFrames,repmat({'r:'},1,length(stimFrames)));
    ylabel('Fluorescence (AU)'); xlabel('Time (seconds)');
% axis([1 length(rawTimeSeries.(fn).(cn)) 0 (length(fns)*spacing)]);
%      scrollplot(200, 1:length(deltaF.(fn).(cn)), deltaF.(fn).(cn));


set(gca,'YTick',[0:spacing:(numCells*spacing)])
% set(gca,'YTickLabel',num2str(1:numCells))
% title([num2str(j),'/',num2str(length(fns))])
end

