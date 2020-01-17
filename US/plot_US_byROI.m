function  plot_US_byROI( df_byTrial,sampRate,stimFrame )
%GUI that loops through all ROIs, plotting raw fluorecence time series for
%ROI mask, neuropil mask, and ROI fluorescence post neuropil subtraction.
%black is ROI, red is mask, blue is subtraction
cellNames=fieldnames(df_byTrial);

frames=1:size(df_byTrial.(cellNames{1}),1);
j=1;
g=figure; hold on
s1=subplot(1,2,1);
% s1.NextPlot='replaceall';
imagesc(df_byTrial.(cellNames{j})'); colormap gray
vline(stimFrame);

median_df=median(df_byTrial.(cellNames{j}),2);
std_df=std(df_byTrial.(cellNames{j}),[],2);
s2=subplot(1,2,2);
hold on
plot(df_byTrial.(cellNames{j}),'k','LineWidth',0.5);
plot(frames,median_df,'r','LineWidth',1.5);
% tmp=gca;
% tmp.YLim=[-0.5 1];
%      boundedline(frames,median_df,std_df,'r.','alpha')
%      s2.NextPlot='replaceall';
vline(stimFrame);



% Create push button
next_btn = uicontrol('Style', 'pushbutton', 'String', 'keep',...
    'Units','normalized','Position', [0.55 0.005 0.045 0.05],...
    'Callback', @plot_ROI);







% Pause until figure is closed ---------------------------------------%
waitfor(g);

% ROIs_exclude=cellNames(inds_ex);
% for k=1:length(fns)
%     filtTimeSeries_new.(fns{k})=rmfield(filtTimeSeries.(fns{k}),ROIs_exclude);
%     npfiltTimeSeries_new.(fns{k})=rmfield(npfiltTimeSeries.(fns{k}),ROIs_exclude);
% end

    function plot_ROI(source,event)
        j=j+1;
        if j<=length(cellNames)
            figure(g); hold off
            g.NextPlot='replacechildren';
subplot(1,2,1)
%      s1.NextPlot='replace';
imagesc(df_byTrial.(cellNames{j})'); colormap gray
vline(stimFrame);

median_df=median(df_byTrial.(cellNames{j}),2);
std_df=std(df_byTrial.(cellNames{j}),[],2);
subplot(1,2,2); hold off
% s2.NextPlot='replace';
%      boundedline(frames,median_df,std_df,'r.','alpha')

plot(df_byTrial.(cellNames{j}),'k','LineWidth',0.5); hold on
plot(frames,median_df,'r','LineWidth',1.5);
vline(stimFrame);
% tmp=gca;
% tmp.YLim=[-0.5 1];

        end
    end

    
end
