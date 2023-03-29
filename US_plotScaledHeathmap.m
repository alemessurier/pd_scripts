function US_plotScaledHeathmap(dF_byDC,stimFrame,dF_byPressure,cellNames,poststim,clow,chigh,clow_Z,chigh_Z)

DCsweep = make_DCsweep( dF_byDC,cellNames,poststim );
pressSweep = make_DCsweep( dF_byPressure,cellNames,poststim );%% plot mean response of each cell to strongest stim, ordered by modulation depth

prestim=(stimFrame-60):stimFrame;
% poststim=stimFrame:(stimFrame+60);
meansDC50=cellfun(@(x)mean(dF_byDC.(x).DC50,2)',cellNames,'un',0);
z_means=cellfun(@(x)(x-mean(x(1:stimFrame),2))/std(x(1:stimFrame)),meansDC50,'un',0);
z_means=cat(1,z_means{:});
meansDC50=cat(1,meansDC50{:});

preStim_Z=mean(z_means(:,prestim),2);
postStim_Z=mean(z_means(:,poststim),2);
mean_response_Z=postStim_Z-preStim_Z;
[mean_Z_sorted, inds_sorted]=sort(mean_response_Z,'descend');
z_means_sorted=z_means(inds_sorted,:);
figure; imagesc(z_means_sorted,[clow_Z chigh_Z])
colormap gray

numFrames=size(z_means_sorted,2);
tmp=gca;
tmp.XTick=(((0:150:numFrames))/30)*30;
tmp.XTickLabel=((0:150:numFrames)-stimFrame)/30;
vline(stimFrame);
tmp.XLim=[0 450];
xlabel('time from stim onset (s)');
ylabel('ROI')
title('mean Z-scored dF/F by ROI, 50% DC')

% preStim=mean(meansDC50(:,prestim),2);
% postStim=mean(meansDC50(:,poststim),2);
% mean_response=postStim-preStim;
% [mean_response_sorted, inds_sorted]=sort(mean_response,'descend');
% meansDC50_sorted=meansDC50(inds_sorted,:);
% numFrames=size(meansDC50_sorted,2);
% figure; imagesc(meansDC50_sorted,[clow chigh])
% colormap gray
% 
% tmp=gca;
% tmp.XTick=(((0:150:numFrames))/30)*30;
% tmp.XTickLabel=((0:150:numFrames)-stimFrame)/30;
% vline(stimFrame);
% xlabel('time from stim onset (s)');
% ylabel('ROI')
% title('mean dF/F by ROI, 50% DC')

