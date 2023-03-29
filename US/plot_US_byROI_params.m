function  plot_US_byROI_params( samp_rate,stimFrame,DCsweep,dF_byDS,pressSweep,dF_byPressure,cellsToPlot,pressure_labels,DC_labels )
%GUI that loops through all ROIs, plotting raw fluorecence time series for
%ROI mask, neuropil mask, and ROI fluorescence post neuropil subtraction.
%black is ROI, red is mask, blue is subtraction
if isempty(cellsToPlot)
    cellNames=fieldnames(dF_byDS);
else
    cellNames=cellsToPlot;
end
%plot first cell to initiate

frames=1:size(dF_byDS.(cellNames{1}).DC50,1);
j=1;
g=figure; hold on

%% duty cycle
%trial-by-trial responses to 50%, 0.8 MPa
s1=subplot(2,3,1); 
% s1.NextPlot='replaceall';
imagesc(dF_byDS.(cellNames{j}).DC50'); colormap gray
vline(stimFrame);
xtick=0:150:size(dF_byDS.(cellNames{j}).DC50',2);
s1.XTick=xtick;
s1.XTickLabel=(xtick-stimFrame)/samp_rate;
xlabel('time from stim onset (s)')
ylabel('trial')

% mean responses by duty cycle
s2=subplot(2,3,2);
fns=fieldnames(dF_byDS.(cellNames{1}));
mean_evoked=cellfun(@(x)mean(dF_byDS.(cellNames{j}).(x)(1:450,:),2)',fns,'un',0);
maxY=max(cellfun(@max,mean_evoked));
minY=min(cellfun(@min,mean_evoked));
set(gca,'YLim',[minY-0.01 maxY+0.01])
cmap_dc=brewermap(numel(mean_evoked)+1,'YlGnBu');
cmap_dc=cmap_dc(2:end,:);
set(gca,'ColorOrder',cmap_dc);
time=(1:length(mean_evoked{1}))/samp_rate-stimFrame/samp_rate;
xlabel('time since stim (sec)')
ylabel('dF/F')
vline(0)
hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),mean_evoked,'Uni',0);
legend(fns)
hold off

% mean response to each duty cycle
subplot(2,3,3)
errorbar(DCsweep.meanByCell(j,:),DCsweep.semByCell(j,:),'k','LineWidth',1.5)
tmp=gca;
tmp.XTick=1:length(DC_labels);
tmp.XTickLabel=DC_labels;
xlabel('duty cycle (%)')
ylabel('dF/F')

%% pressure

% mean responses by pressure
s4=subplot(2,3,5);
fns=fieldnames(dF_byPressure.(cellNames{1}));
mean_evoked=cellfun(@(x)mean(dF_byPressure.(cellNames{j}).(x)(1:450,:),2)',fns,'un',0);
maxY=max(cellfun(@max,mean_evoked));
minY=min(cellfun(@min,mean_evoked));
set(gca,'YLim',[minY-0.01 maxY+0.01])
cmap_p=brewermap(numel(mean_evoked)+1,'PuRd');
cmap_p=cmap_p(2:end,:);
set(gca,'ColorOrder',cmap_p);
time=(1:length(mean_evoked{1}))/samp_rate-stimFrame/samp_rate;
xlabel('time since stim (sec)')
ylabel('dF/F')
vline(0)
hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),mean_evoked,'Uni',0);
legend(fns)
hold off

% mean response to each pressure level
subplot(2,3,6)
errorbar(pressSweep.meanByCell(j,:),pressSweep.semByCell(j,:),'k','LineWidth',1.5)
tmp=gca;
tmp.XTick=1:length(pressure_labels);
tmp.XTickLabel=pressure_labels;
xlabel('pressure level (MPa)')
ylabel('dF/F')

%%
% Create push button
next_btn = uicontrol('Style', 'pushbutton', 'String', 'next',...
    'Units','normalized','Position', [0.55 0.005 0.045 0.05],...
    'Callback', @plot_ROI);

% Pause until figure is closed ---------------------------------------%
waitfor(g);

%%
    function plot_ROI(source,event)
        j=j+1;
        if j<=length(cellNames)
            figure(g); hold off
            g.NextPlot='replacechildren';
            delete(s2)
            delete(s4)
s1=subplot(2,3,1)
%      s1.NextPlot='replace';
imagesc(dF_byDS.(cellNames{j}).DC50'); colormap gray
vline(stimFrame);
xtick=0:150:size(dF_byDS.(cellNames{j}).DC50',2);
s1.XTick=xtick;s1.XTickLabel=(xtick-stimFrame)/samp_rate;
xlabel('time from stim onset (s)')
ylabel('trial')

fns=fieldnames(dF_byDS.(cellNames{1}));
s2=subplot(2,3,2);
mean_evoked=cellfun(@(x)mean(dF_byDS.(cellNames{j}).(x)(1:450,:),2)',fns,'un',0);
maxY=max(cellfun(@max,mean_evoked));
minY=min(cellfun(@min,mean_evoked));
set(gca,'YLim',[minY-0.01 maxY+0.01])

% cmap=hsv(numel(mean_evoked));
set(gca,'ColorOrder',cmap_dc);

time=(1:length(mean_evoked{1}))/samp_rate-stimFrame/samp_rate;
xlabel('time since stim (sec)')
ylabel('dF/F')
vline(0)
% set(gca,'XLim',[time(1) time(end)])
hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),mean_evoked,'Uni',0);
legend(fns)
hold off
subplot(2,3,3)
errorbar(DCsweep.meanByCell(j,:),DCsweep.semByCell(j,:),'k','LineWidth',1.5)
tmp=gca;
tmp.XTick=1:length(DC_labels);
tmp.XTickLabel=DC_labels;
xlabel('duty cycle (%)')
ylabel('dF/F')



% mean responses by pressure
s4=subplot(2,3,5);
fns=fieldnames(dF_byPressure.(cellNames{1}));
mean_evoked=cellfun(@(x)mean(dF_byPressure.(cellNames{j}).(x)(1:450,:),2)',fns,'un',0);
maxY=max(cellfun(@max,mean_evoked));
minY=min(cellfun(@min,mean_evoked));
set(gca,'YLim',[minY-0.01 maxY+0.01])
% cmap=hsv(numel(mean_evoked));
set(gca,'ColorOrder',cmap_p);
time=(1:length(mean_evoked{1}))/samp_rate-stimFrame/samp_rate;
xlabel('time since stim (sec)')
ylabel('dF/F')
vline(0)
hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),mean_evoked,'Uni',0);
legend(fns)
hold off

% mean response to each pressure level
subplot(2,3,6)
errorbar(pressSweep.meanByCell(j,:),pressSweep.semByCell(j,:),'k','LineWidth',1.5)
tmp=gca;
tmp.XTick=1:length(pressure_labels);
tmp.XTickLabel=pressure_labels;
xlabel('pressure level (MPa)')
ylabel('dF/F')

        end
    end

    
end
