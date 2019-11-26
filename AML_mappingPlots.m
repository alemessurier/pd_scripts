function  AML_mappingPlots( data,tuningcurve,fftrials )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% plot raw dF/F traces of all ROIs
deltaF_all=zeros(size(data));
numCells=size(data,2);
numFrames=size(data,1);

for i=1:numCells
    rawtrace=data(:,i);
    deltaF_all(:,i)  = deltaF_simple(rawtrace);
end

figure
samp_rate=3.91;
spacing=10;
stimFrames=10:20:numFrames;
plot_raw_deltaF( deltaF_all,samp_rate,spacing,stimFrames )

% look at tuning of field

figure;
s1=subplot(1,2,1)
imagesc(tuningcurve.mean');
s1.XTick=1:17;
s1.XTickLabel=tuningcurve.tone;
s1.XTickLabelRotation=45;
title('mean tone responses')
s2=subplot(1,2,2)
imagesc(tuningcurve.med');
s2.XTick=1:17;
s2.XTickLabel=tuningcurve.tone;
s2.XTickLabelRotation=45;
title('median tone responses')

mean_all=mean(tuningcurve.mean,2)';
med_all=mean(tuningcurve.med,2)';
sem_mean=(std(tuningcurve.mean,[],2)/sqrt(size(tuningcurve.std,2))');
sem_med=(std(tuningcurve.med,[],2)/sqrt(size(tuningcurve.std,2))');
figure; hold on
errorbar(1:17,mean_all,sem_mean,'k')
errorbar(1:17,med_all,sem_med,'r')
a=gca;
a.XTick=1:17;
a.XTickLabel=tuningcurve.tone;
a.XTickLabelRotation=45;
xlabel('frequency (Hz)');
ylabel('df/f')
legend('mean','median')
title('average responses, all cells')

numResponsiveCells=sum(tuningcurve.h,2);
percResponsiveCells=numResponsiveCells/(size(tuningcurve.h,2));
figure; plot(1:17,percResponsiveCells,'k+')
h=gca;
h.XTick=1:17;
h.XTickLabel=tuningcurve.tone;
h.XTickLabelRotation=45;
xlabel('frequency');
ylabel(' % cells w/significant responses');


end

