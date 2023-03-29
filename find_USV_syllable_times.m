function times=find_USV_syllable_times( data,param )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
sampRate=20000;
h=figure;
i=1;

% data_plot=squeeze(data(:,1,:))';
stims_plot=squeeze(data(:,4,:))';
numSweeps = size(stims_plot,2);

time=(1:param.dataPtsPerChan)/(sampRate);
% hold on

times=cell(numSweeps,1);
plot(time,stims_plot(i,:),'k')
% stimThresh=0;
% sth=hline(stimThresh,'r');
zoom on
% axis([time(1) time(end)  minVal maxVal])
title(strcat('sweep ',num2str(i)))


sel_btn = uicontrol('Style', 'pushbutton', 'String', 'select points',...
    'Units','normalized','Position', [0.1 0.005 0.045 0.05],...
    'Callback', @OnClickAxes);
 
%             
% 
sweep_sld=uicontrol('Style', 'slider',...
        'Min',1,'Max',size(stims_plot,1),'Value',1,'SliderStep',[1/size(stims_plot,1) 10/(size(stims_plot,1))],...
        'Units','normalized','Position', [0.3 0.01 0.6 0.05],...
        'Callback', @setSweep); 
       
        
 
    function setSweep(source,callbackdata)
        i=ceil(get(source,'Value'));
        if i>numSweeps
            i=numSweeps;
        else
        end
        
%        	subplot(2,1,2); hold off
        plot(time,stims_plot(i,:),'k')
        hold on
% %         axis([time(1) time(end) minVal maxVal])
%             if length(stimThresh)<i
%                 stimThresh(length(stimThresh):i)=stimThresh(end);
%             else
%             end
%             sth=hline(stimThresh(i),'r');
            
        
        
            title(strcat('sweep ',num2str(i)))
      hold off
    end

    function OnClickAxes( source, event )
        [x,y]=ginput(2);
        times{i}=[times{i};[x(1),x(2)]];
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

