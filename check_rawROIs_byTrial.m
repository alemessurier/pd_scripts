function  [inds_ex]=check_rawROIs_byTrial(dF,inds_ex)
%GUI that loops through all ROIs, plotting raw fluorecence time series for
%ROI mask, neuropil mask, and ROI fluorescence post neuropil subtraction.
%black is ROI, red is mask, blue is subtraction



j=1;
thisTrial=cellfun(@(x)x(:,j),dF,'un',0);
thisTrial=cat(2,thisTrial{:})';
g=figure; hold on
plotAllCells(thisTrial,100)

numTrials=size(dF{1},2);


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
        if j<=numTrials
            
            figure(g); hold off;
            thisTrial=cellfun(@(x)x(:,j),dF,'un',0);
            thisTrial=cat(2,thisTrial{:})';
            plotAllCells(thisTrial,100)
            
            
        end
    end

    function exclude_ROI(source,event)
        if j<=numTrials
            inds_ex(j)=1;
        end
        
        j=j+1;
        if j<=numTrials
             figure(g); hold off;
            thisTrial=cellfun(@(x)x(:,j),dF,'un',0);
            thisTrial=cat(2,thisTrial{:})';
            plotAllCells(thisTrial,100)
        end
        
    end

    function plotAllCells(trial_dF,spacing)
        time = 1:size(trial_dF,2);
        cmap=morgenstemning(size(trial_dF,1)+2);
        for i=1:size(trial_dF,1)
            plot(time, trial_dF(i,:)+((i-1)*spacing),'Color',cmap(i,:),'LineWidth',0.5);
            hold on
        end
        
        
    end
end
