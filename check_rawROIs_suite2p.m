function  [inds_ex]=check_rawROIs_suite2p( F,Fneu,F_np_corr )
%GUI that loops through all ROIs, plotting raw fluorecence time series for
%ROI mask, neuropil mask, and ROI fluorescence post neuropil subtraction.
%black is ROI, red is mask, blue is subtraction


frames=1:size(F,2);
j=1;
inds_ex=zeros(1,size(F,1));
g=figure; hold on
plot(frames,F(j,:),'k')
plot(frames,Fneu(j,:),'r')
plot(frames,F_np_corr(j,:),'b')




% Create push button
keep_btn = uicontrol('Style', 'pushbutton', 'String', 'keep',...
    'Units','normalized','Position', [0.55 0.005 0.045 0.05],...
    'Callback', @keep_ROI);

ex_btn = uicontrol('Style', 'pushbutton', 'String', 'exclude',...
    'Units','normalized','Position', [0.45 0.005 0.045 0.05],...
    'Callback', @exclude_ROI);






% Pause until figure is closed ---------------------------------------%
waitfor(g);
inds_ex=logical(inds_ex);
% ROIs_exclude=cellNames(inds_ex);
% for k=1:length(fns)
%     filtTimeSeries_new.(fns{k})=rmfield(filtTimeSeries.(fns{k}),ROIs_exclude);
%     npfiltTimeSeries_new.(fns{k})=rmfield(npfiltTimeSeries.(fns{k}),ROIs_exclude);
% end

    function keep_ROI(source,event)
        j=j+1;
        if j<=size(F,1)
            
            figure(g); hold off;
            plot(frames,F(j,:),'k');
            hold on
plot(frames,Fneu(j,:),'r')
plot(frames,F_np_corr(j,:),'b')


        end
    end

    function exclude_ROI(source,event)
        if j<=size(F,1)
            inds_ex(j)=1;
        end
   
        j=j+1;
        if j<=size(F,1)
            
            figure(g); hold off;
           plot(frames,F(j,:),'k')
           hold on
plot(frames,Fneu(j,:),'r')
plot(frames,F_np_corr(j,:),'b')


        end
             
    end
end
