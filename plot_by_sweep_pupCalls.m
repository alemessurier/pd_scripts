function [filtSweeps,threshold]=plot_by_sweep_pupCalls( data,param,sampRate,minVal,maxVal )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

h=figure;
i=1;

data_plot=squeeze(data(:,1,:))';
stims_plot=squeeze(data(:,2,:))';
% if invert==1;
%     data_plot=-data_plot;
% end
if isempty(maxVal)
    maxVal=max(max(data_plot));
    minVal=min(min(data_plot));
end
numSweeps = size(data_plot,1);
datapts=param.dataPtsPerChan;
time=(1:datapts)/(sampRate);
% hold on

% filter data
for j=1:numSweeps
    baseline=mean(data_plot(j,1:0.2*sampRate));
    normSweeps(j,:)=double(data_plot(j,:)-baseline);
%     filtSweeps(j,:)=bandpass(normSweeps(j,:),[100,1000],sampRate);
  filtSweeps(j,:)=genButterFilter(normSweeps(j,:),100,3000,4,'butter_acausal',sampRate);
end

maxFilt=ceil(max(max(filtSweeps)));
minFilt=floor(min(min(filtSweeps)));

s(1)=subplot(3,1,3);
plot(time,stims_plot(i,:),'c')
% stimThresh=0;
% sth=hline(stimThresh,'r');
s(2)=subplot(3,1,1);
plot(time,filtSweeps(i,:),'k')
hold on
tempThresh=floor(maxFilt/2);
th=hline(tempThresh,'r');
threshold=tempThresh;

%       hold off
zoom on
axis([time(1) time(end)  minFilt maxFilt])
title(strcat('sweep ',num2str(i)))

s(3)=subplot(3,1,2);
plot(time,normSweeps(i,:),'k')
hold on

zoom on
axis([time(1) time(end)  minVal maxVal])
linkaxes(s,'xy')



%
%
sweep_sld=uicontrol(h,'Style', 'slider',...
    'Min',1,'Max',size(data_plot,1),'Value',1,'SliderStep',[1/size(data_plot,1) 10/(size(data_plot,1))],...
    'Units','normalized','Position', [0.3 0.01 0.6 0.05],...
    'Callback', @setSweep);

threshold_sld = uicontrol(h,'Style', 'slider',...
    'Min',minFilt,'Max',maxFilt,'Value',floor(minFilt+((maxFilt-minFilt)/2)),...
    'Units','normalized','Position', [0.05 0.1 0.05 0.8],...
    'Callback', @setThresh);

%     threshold_stim = uicontrol('Style', 'slider',...
%         'Min',minVal,'Max',maxVal,'Value',floor(minVal+((maxVal-minVal)/2)),...
%         'Units','normalized','Position', [0.05 0.1 0.85 0.8],...
%         'Callback', @setThresh_stim);

plotAllButton=uicontrol(h,'Style','pushbutton','Units','normalized','Position', [0.1 .01 0.15 0.05], 'String', 'all sweeps', ...
    'Callback', @plotAll);



    function setSweep(source,callbackdata)
        i=ceil(get(source,'Value'));
        if i>numSweeps
            i=numSweeps;
        else
        end
        figure(h)
        s(1)=subplot(3,1,3); hold off
        plot(time,stims_plot(i,:),'c')
        hold on
        % %         axis([time(1) time(end) minVal maxVal])
        %             if length(stimThresh)<i
        %                 stimThresh(length(stimThresh):i)=stimThresh(end);
        %             else
        %             end
        %             sth=hline(stimThresh(i),'r');
        
        s(3)=subplot(3,1,2);
        hold off
        plot(time,normSweeps(i,:),'k')
        hold on
        
        zoom on
        axis([time(1) time(end)  minVal maxVal])
        
        
        s(2)=subplot(3,1,1);
        hold off
        plot(time,filtSweeps(i,:),'k')
        hold on
        axis([time(1) time(end) minFilt maxFilt])
        if length(threshold)<i
            threshold(length(threshold):i)=threshold(end);
        else
        end
        th=hline(threshold(i),'r');
        title(strcat('sweep ',num2str(i)))
        %       hold off
        
        linkaxes(s,'x')
    end

    function setThresh(source,callbackdata)
        delete(th)
        axis(s(2));
        threshold(i)=get(source,'Value');
        th=hline(threshold(i),'r');
    end


    function plotAll(hObject,EventData,Handles)
        figure(h)
        hold on
        
        plot(time,stims_plot(i,:),'c')
        plot(time,data_plot(i,:),'k')
        
        axis([time(1) time(end) minVal maxVal])
        %              delay=param.stim.preDelay(i);
        %             isi=param.stim.isi(i);
        %             riseFall=param.stim.riseFall(i);
        %             dur=param.stim.dur(i);
        %             for j=1:param.stim.numImpulses(i)
        %                 xdata=[(delay+(j-1)*(2*riseFall+dur+isi)) (delay+(j-1)*(2*riseFall+dur+isi)) (delay+(j-1)*(2*riseFall+dur+isi))+(2*riseFall+dur) (delay+(j-1)*(2*riseFall+dur+isi))+(2*riseFall+dur)];
        %                 patch(xdata,[minVal maxVal maxVal minVal],'g','FaceColor','g','FaceAlpha',0.2,'EdgeColor','none')
        %                 hold on
        %             end
        th=hline(tempThresh,'r');
        hold off
        
    end
% function done(hObject,eventdata,Handles)
%         % Assign Output
%         outputPos = inputPos;
%         % Close figure
%         delete(f); % close GUI
%     end
%
% Pause until figure is closed ---------------------------------------%
waitfor(h);


end

