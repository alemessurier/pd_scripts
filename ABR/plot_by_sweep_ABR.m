function threshold=plot_by_sweep_ABR( data,sampRate )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
maxVal=max(max(data));
minVal=min(min(data));
h=figure;
i=1;

time=(1:size(data,1))/sampRate;
plot(time,data(:,1))
axis([time(1) time(end)  minVal maxVal])
title(strcat('sweep ',num2str(i)))
%  delay=param.stim.preDelay(i);
%             isi=param.stim.isi(i);
%             riseFall=param.stim.riseFall(i);
%             dur=param.stim.dur(i);
%             for j=1:param.stim.numImpulses(i)
%                 xdata=[(delay+(j-1)*(2*riseFall+dur+isi)) (delay+(j-1)*(2*riseFall+dur+isi)) (delay+(j-1)*(2*riseFall+dur+isi))+(2*riseFall+dur) (delay+(j-1)*(2*riseFall+dur+isi))+(2*riseFall+dur)];
%                 patch(xdata,[minVal maxVal maxVal minVal],'g','FaceColor','g','FaceAlpha',0.2,'EdgeColor','none')
%                 hold on
%             end
            threshold=floor(maxVal/2);
            th=hline(threshold,'r');
      hold off
zoom on



% nextButton=uicontrol(h,'Style','pushbutton','Units','normalized','Position', [0.3 .01 0.05 0.05], 'String', '>', ...
%             'Callback', @nextSweep);%'UserData',1,'String','done!')
%         
% lastButton=uicontrol(h,'Style','pushbutton','Units','normalized','Position', [0.25 .01 0.05 0.05], 'String', '<', ...
%             'Callback', @lastSweep);%'UserData',1,'String','done!')
% 
sweep_sld=uicontrol('Style', 'slider',...
        'Min',1,'Max',size(data,1),'Value',1,'SliderStep',[1/size(data,1) 10/(size(data,1))],...
        'Units','normalized','Position', [0.3 0.01 0.6 0.05],...
        'Callback', @setSweep); 
        
threshold_sld = uicontrol('Style', 'slider',...
        'Min',minVal,'Max',maxVal,'Value',floor(minVal+((maxVal-minVal)/2)),...
        'Units','normalized','Position', [0.05 0.1 0.05 0.8],...
        'Callback', @setThresh); 

plotAllButton=uicontrol(h,'Style','pushbutton','Units','normalized','Position', [0.1 .01 0.15 0.05], 'String', 'all sweeps', ...
            'Callback', @plotAll);

        
%     function nextSweep(hObject,EventData,Handles)
%         if i<size(data,1)
%             i=i+1;
%             plot(time,data(i,:))
%             axis([time(1) time(end) minVal maxVal])
%             delay=param.stim.preDelay(i);
%             isi=param.stim.isi(i);
%             riseFall=param.stim.riseFall(i);
%             dur=param.stim.dur(i);
%             for j=1:param.stim.numImpulses(i)
%                 xdata=[(delay+(j-1)*(2*riseFall+dur+isi)) (delay+(j-1)*(2*riseFall+dur+isi)) (delay+(j-1)*(2*riseFall+dur+isi))+(2*riseFall+dur) (delay+(j-1)*(2*riseFall+dur+isi))+(2*riseFall+dur)];
%                 patch(xdata,[minVal maxVal maxVal minVal],'g','FaceColor','g','FaceAlpha',0.2,'EdgeColor','none')
%                 hold on
%             end
%             title(strcat('sweep ',num2str(i)))
%             th=hline(threshold,'r')
%       hold off
%             
%         else
%         end
%     end
% 
%  function lastSweep(hObject,EventData,Handles)
%         if i>1
%             i=i-1;
%             plot(time,data(i,:))
%              axis([time(1) time(end) minVal maxVal])
%              delay=param.stim.preDelay(i);
%             isi=param.stim.isi(i);
%             riseFall=param.stim.riseFall(i);
%             dur=param.stim.dur(i);
%             for j=1:param.stim.numImpulses(i)
%                 xdata=[(delay+(j-1)*(2*riseFall+dur+isi)) (delay+(j-1)*(2*riseFall+dur+isi)) (delay+(j-1)*(2*riseFall+dur+isi))+(2*riseFall+dur) (delay+(j-1)*(2*riseFall+dur+isi))+(2*riseFall+dur)];
%                 patch(xdata,[minVal maxVal maxVal minVal],'g','FaceColor','g','FaceAlpha',0.2,'EdgeColor','none')
%                 hold on
%             end
%             th=hline(threshold,'r');
%             title(strcat('sweep ',num2str(i)))
%       hold off
%         else
%         end
%  end
 
    function setSweep(source,callbackdata)
        i=ceil(get(source,'Value'));
        if i>size(data,2)
            i=size(data,2);
        else
        end
            
         plot(time,data(:,i))
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
            if length(threshold)<i
                threshold(length(threshold):i)=threshold(end);
            else
            end
            th=hline(threshold(i),'r');
            title(strcat('sweep ',num2str(i)))
      hold off
    end

    function setThresh(source,callbackdata)
        delete(th)
        threshold(i)=get(source,'Value');
        th=hline(threshold(i),'r');
    end
        

    function plotAll(hObject,EventData,Handles)
            hold on
            plot(time,data,'c');
            
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
            th=hline(threshold,'r');
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

