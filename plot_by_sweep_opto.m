function threshold=plot_by_sweep_opto( data,param,sampRate,minVal,maxVal )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

h=figure;
i=1;

data_plot=squeeze(data(:,1,:))';
% if invert==1
%     data_plot=-data_plot;
% end
if isempty(maxVal)
    maxVal=max(max(data_plot));
    minVal=min(min(data_plot));
end
numSweeps = size(data_plot,2);

time=(1:param.dataPtsPerChan)/(sampRate);
% hold on

plot(time,data_plot(i,:),'k')
hold on
 tempThresh=0;%floor(maxVal/2);
            th=hline(tempThresh,'r');
            threshold=tempThresh;
            
%       hold off
zoom on
axis([time(1) time(end)  minVal maxVal])
title(strcat('sweep ',num2str(i)))



 
%             
% 
sweep_sld=uicontrol('Style', 'slider',...
        'Min',1,'Max',size(data_plot,1),'Value',1,'SliderStep',[1/size(data_plot,1) 10/(size(data_plot,1))],...
        'Units','normalized','Position', [0.3 0.01 0.6 0.05],...
        'Callback', @setSweep); 
        
threshold_sld = uicontrol('Style', 'slider',...
        'Min',minVal,'Max',maxVal,'Value',floor(minVal+((maxVal-minVal)/2)),...
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
        
       	
         hold off
          plot(time,data_plot(i,:),'k')
            hold on
             axis([time(1) time(end) minVal maxVal])
            if length(threshold)<i
                threshold(length(threshold):i)=threshold(end);
            else
            end
            th=hline(threshold(i),'r');
            title(strcat('sweep ',num2str(i)))
%       hold off
    end

    function setThresh(source,callbackdata)
        delete(th)
        threshold(i)=get(source,'Value');
        th=hline(threshold(i),'r');
    end
        

    function plotAll(hObject,EventData,Handles)
            hold on
            
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

