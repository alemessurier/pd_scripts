function [deltaF] = pupCalls_make_deltaFall_galvo(F_calls,plotting)
%%
% plot raw dF/F traces of all ROIs

deltaF=[];
stimFrames_all=[];
for d=1:numel(F_calls)
    data=F_calls(d).FROI;

    deltaF_all=zeros(size(data));
    numCells=size(data,1);
    numFrames=size(data,2);
    stimFrames=40:40:numFrames;
    stimFrames=stimFrames+size(deltaF,2);
    stimFrames_all=[stimFrames_all,stimFrames];
    for i=1:numCells
        rawtrace=data(i,:);
        deltaF_all(i,:)  = deltaF_simple(rawtrace,0.5);



    end
    deltaF=[deltaF,deltaF_all];
end

switch plotting
    case 1
figure
samp_rate=3.91;
spacing=1;
plot_raw_deltaF( deltaF,samp_rate,spacing,stimFrames_all )
    case 0
end