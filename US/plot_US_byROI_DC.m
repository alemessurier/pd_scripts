function  plot_US_byROI_DC( df_byTrial,samp_rate,stimFrame,DCsweep,dF_byDS,cellsToPlot )
%GUI that loops through all ROIs, plotting raw fluorecence time series for
%ROI mask, neuropil mask, and ROI fluorescence post neuropil subtraction.
%black is ROI, red is mask, blue is subtraction
if isempty(cellsToPlot)
    cellNames=fieldnames(df_byDS);
else
    cellNames=cellsToPlot;
end

frames=1:size(dF_byDS.(cellNames{1}).DC50,1);
j=1;
g=figure; hold on
s1=subplot(1,3,1);
% s1.NextPlot='replaceall';
imagesc(dF_byDS.(cellNames{j}).DC50'); colormap gray
vline(stimFrame);
xtick=0:150:size(dF_byDS.(cellNames{j}).DC50',2);
s1.XTick=xtick;
s1.XTickLabel=(xtick-stimFrame)/samp_rate;
xlabel('time from stim onset (s)')
ylabel('trial')

fns=fieldnames(dF_byDS.cell1);
s2=subplot(1,3,2);
mean_evoked=cellfun(@(x)mean(dF_byDS.(cellNames{j}).(x),2)',fns,'un',0);
maxY=max(cellfun(@max,mean_evoked));
minY=min(cellfun(@min,mean_evoked));
set(gca,'YLim',[minY-0.01 maxY+0.01])
cmap=hsv(numel(mean_evoked));
set(gca,'ColorOrder',cmap);

time=(1:length(mean_evoked{1}))/samp_rate-5;
xlabel('time since stim (sec)')
ylabel('dF/F')
vline(0)

hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),mean_evoked,'Uni',0);
legend(fns)
hold off
subplot(1,3,3)
errorbar(DCsweep.meanByCell(j,:),DCsweep.semByCell(j,:),'k','LineWidth',1.5)
tmp=gca;
tmp.XTick=1:6;
tmp.XTickLabel=[5,10:10:50]
xlabel('duty cycle (%)')
ylabel('dF/F')

% Create push button
next_btn = uicontrol('Style', 'pushbutton', 'String', 'next',...
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
            delete(s2)
s1=subplot(1,3,1)
%      s1.NextPlot='replace';
imagesc(dF_byDS.(cellNames{j}).DC50'); colormap gray
vline(stimFrame);
xtick=0:150:size(dF_byDS.(cellNames{j}).DC50',2);
s1.XTick=xtick;s1.XTickLabel=(xtick-stimFrame)/samp_rate;
xlabel('time from stim onset (s)')
ylabel('trial')

fns=fieldnames(dF_byDS.cell1);
s2=subplot(1,3,2);
mean_evoked=cellfun(@(x)mean(dF_byDS.(cellNames{j}).(x),2)',fns,'un',0);
maxY=max(cellfun(@max,mean_evoked));
minY=min(cellfun(@min,mean_evoked));
set(gca,'YLim',[minY-0.01 maxY+0.01])

cmap=hsv(numel(mean_evoked));
set(gca,'ColorOrder',cmap);

time=(1:length(mean_evoked{1}))/samp_rate-5;
xlabel('time since stim (sec)')
ylabel('dF/F')
vline(0)
% set(gca,'XLim',[time(1) time(end)])
hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),mean_evoked,'Uni',0);
legend(fns)
hold off
subplot(1,3,3)
errorbar(DCsweep.meanByCell(j,:),DCsweep.semByCell(j,:),'k','LineWidth',1.5)
tmp=gca;
tmp.XTick=1:6;
tmp.XTickLabel=[5,10:10:50]
xlabel('duty cycle (%)')
ylabel('dF/F')

        end
    end

    
end
