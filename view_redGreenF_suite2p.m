function  [inds_red]=view_redGreenF_suite2p( Fred,Fgreen,redscore )
%GUI that loops through all ROIs, plotting raw fluorecence time series for
%ROI mask, neuropil mask, and ROI fluorescence post neuropil subtraction.
%black is ROI, red is mask, blue is subtraction


frames=1:size(Fred,2);
j=1;
inds_red=zeros(1,size(Fred,1));
g=figure; hold on
plot(frames,Fgreen(j,:),'g')
plot(frames,Fred(j,:),'r')
title(['p(red)=',num2str(redscore(j))]);



% Create push button
keep_btn = uicontrol('Style', 'pushbutton', 'String', 'red',...
    'Units','normalized','Position', [0.55 0.005 0.045 0.05],...
    'Callback', @keep_ROI);

ex_btn = uicontrol('Style', 'pushbutton', 'String', 'exclude',...
    'Units','normalized','Position', [0.45 0.005 0.045 0.05],...
    'Callback', @exclude_ROI);






% Pause until figure is closed ---------------------------------------%
waitfor(g);
inds_red=logical(inds_red);
% ROIs_exclude=cellNames(inds_red);
% for k=1:length(fns)
%     filtTimeSeries_new.(fns{k})=rmfield(filtTimeSeries.(fns{k}),ROIs_exclude);
%     npfiltTimeSeries_new.(fns{k})=rmfield(npfiltTimeSeries.(fns{k}),ROIs_exclude);
% end

    function keep_ROI(source,event)
        j=j+1;
        if j<=size(Fred,1)
            
            figure(g); hold off;
            plot(frames,Fgreen(j,:),'g'); hold on
plot(frames,Fred(j,:),'r')
title(['p(red)=',num2str(redscore(j))]);

            

        end
    end

    function exclude_ROI(source,event)
        if j<=size(Fred,1)
            inds_red(j)=1;
        end
   
        j=j+1;
        if j<=size(F,1)
            
           figure(g); hold off;
            plot(frames,Fgreen(j,:),'g'); hold on
plot(frames,Fred(j,:),'r')
title(['p(red)=',num2str(redscore(j))]);


        end
             
    end
end
