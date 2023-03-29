f% compare tuning for tones vs calls in PS vs IC projecting in retrievers
%% load PS data
paths_PS={'/Volumes/pupcalls2/retro_GCaMP_mouse3/20210527/suite2p/plane0/',...
    '/Volumes/pupcalls2/retro_GCaMP_mouse3/20210528_field4/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210806/f1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS715/20210806/f2/suite2p/plane0/',...
    '/Volumes/pupcalls2/PS12202/reduced/20220112/f1/suite2p/plane0/',...
    '/Volumes/pupcalls2/PS12202/reduced/20220112/f2/suite2p/plane0/'};

% 
% '/Volumes/pupCalls1/reduced/PS1001/20211102/f1/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1001/20211102/f2/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1001/20211103/f3/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1001/20211103/f4/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1008/20211103/f4/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1008/20211103/f5/suite2p/plane0/',...
%load galvo data
for d=1:2
    [F_calls,F_byToneRep,ops,inds_ex]=load2p_data_pupcalls_galvo(paths_PS{d});
    [deltaF_calls_PS{d}] = pupCalls_make_deltaFall_galvo(F_calls,0);
    [deltaF_tones_PS{d}] = tones_make_deltaFall(F_byToneRep,0,1,4);

    meanDF_total_calls_PS{d}=mean(deltaF_calls_PS{d},2);
    meanDF_total_tones_PS{d}=mean(deltaF_tones_PS{d},2);

    load([paths_PS{d},'reduced_data.mat'],'meanByTrial_early','h_calls','responsiveTrials_byCell');
    load([paths_PS{d},'tone_tuning.mat'],'TUNING','dFByTone','h_pass');
    PS(d).meanByTrial = meanByTrial_early;
    PS(d).h_calls= h_calls;
    PS(d).responsiveTrials=responsiveTrials_byCell;
    PS(d).toneTuning=TUNING;
    PS(d).dFByTone=dFByTone;
    PS(d).h_tone=h_pass;
end


%load data
for d=3:length(paths_PS)
    [F_calls,F_byToneRep,ops,inds_ex]=load2p_data_pupcalls(paths_PS{d});
    [deltaF_calls_PS{d}] = pupCalls_make_deltaFall(F_calls,3,0);
    [deltaF_tones_PS{d}] = tones_make_deltaFall(F_byToneRep,3,0,30);

    meanDF_total_calls_PS{d}=mean(deltaF_calls_PS{d},2);
    meanDF_total_tones_PS{d}=mean(deltaF_tones_PS{d},2);

    load([paths_PS{d},'reduced_data.mat'],'meanByTrial_early','h_calls','responsiveTrials_byCell');
    load([paths_PS{d},'tone_tuning.mat'],'TUNING','dFByTone','h_pass');
    PS(d).meanByTrial = meanByTrial_early;
    PS(d).h_calls= h_calls;
    PS(d).responsiveTrials=responsiveTrials_byCell;
    PS(d).toneTuning=TUNING;
    PS(d).dFByTone=dFByTone;
    PS(d).h_tone=h_pass;
end

%% load IC data

paths_IC = {'/Volumes/pupCalls1/reduced/IC824/20211001/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC929/20211019/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC929/20211021/f1/suite2p/plane0/',...%'/Volumes/pupCalls1/reduced/IC929/20211021/f2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC928/20211022/suite2p/plane0/',...
    '/Volumes/pupCalls2/IC1122/reduced/20211207/suite2p/plane0/'};

% paths_IC= {'/Volumes/pupCalls1/reduced/IC623/20220812/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC622/20220812/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC617/20220811/field1/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC617/20220811/field2/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC603/20220811/suite2p/plane0/'...
%     };

%load data
for d=1:length(paths_IC)
    [F_calls,F_byToneRep,ops,inds_ex]=load2p_data_pupcalls(paths_IC{d});
    [deltaF_calls_IC{d}] = pupCalls_make_deltaFall(F_calls,3,0);
    [deltaF_tones_IC{d}] = tones_make_deltaFall(F_byToneRep,3,0,30);

    meanDF_total_calls_IC{d}=mean(deltaF_calls_IC{d},2);
    meanDF_total_tones_IC{d}=mean(deltaF_tones_IC{d},2);

    figure; hold on
    plot(meanDF_total_tones_IC{d},meanDF_total_calls_IC{d},'ko')
    maxVal=max([meanDF_total_tones_IC{d};meanDF_total_calls_IC{d}]);

    tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('activity during tone blocks')
ylabel('activity during call blocks')
title(paths_IC{d})
axis square

    load([paths_IC{d},'reduced_data.mat'],'meanByTrial_early','h_calls','responsiveTrials_byCell');
    load([paths_IC{d},'tone_tuning.mat'],'TUNING','dFByTone','h_pass');
    IC(d).meanByTrial = meanByTrial_early;
    IC(d).h_calls= h_calls;
    IC(d).responsiveTrials=responsiveTrials_byCell;
     IC(d).toneTuning=TUNING;
    IC(d).dFByTone=dFByTone;
    IC(d).h_tone=h_pass;
    
end

%% mean df/F during tone presentation

meanDF_total_calls_IC=cat(1,meanDF_total_calls_IC{:});
meanDF_total_tones_IC=cat(1,meanDF_total_tones_IC{:});
meanDF_total_calls_PS=cat(1,meanDF_total_calls_PS{:});
meanDF_total_tones_PS=cat(1,meanDF_total_tones_PS{:});
maxVal=max([meanDF_total_calls_IC;meanDF_total_tones_IC;meanDF_total_calls_PS;meanDF_total_tones_PS]);

figure; hold on
plot(meanDF_total_tones_PS,meanDF_total_calls_PS,'ko')
plot(meanDF_total_tones_IC,meanDF_total_calls_IC,'go')
tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('activity during tone blocks')
ylabel('activity during call blocks')
axis square

CallvTone_IC=meanDF_total_calls_IC./meanDF_total_tones_IC;
CallvTone_PS=meanDF_total_calls_PS./meanDF_total_tones_PS;
CvTplot={CallvTone_IC,CallvTone_PS};
figure; hold on
plotSpread(CvTplot,[],[],{'IC-projecting','PS-projecting'},4);
ylabel('ratio of activity during calls vs. tones')

cmap_IC=brewermap(4,'Paired');
cmap_PS=gray(10);
figure; hold on
p(1)=cdfplot(meanDF_total_tones_IC);
p(2)=cdfplot(meanDF_total_calls_IC)
p(1).Color=cmap_IC(3,:)
p(2).Color=cmap_IC(4,:)


p(3)=cdfplot(meanDF_total_tones_PS);
p(4)=cdfplot(meanDF_total_calls_PS)
p(3).Color=cmap_PS(7,:)
p(4).Color=cmap_PS(1,:)
xlabel('activity during epoch (mean dF/F)')
ylabel('cumulative fraction of ROIs')
legend('IC,tones','IC,calls','PS,tones','PS,calls')
title('baseline activity')
[h_ic,p_ic]=ttest(meanDF_total_calls_IC,meanDF_total_tones_IC);
[h_ps,p_ps]=ttest(meanDF_total_calls_PS,meanDF_total_tones_PS);


%% 

CvTplot={meanDF_total_calls_IC,meanDF_total_tones_IC,meanDF_total_calls_PS,meanDF_total_tones_PS};
figure; hold on
plotSpread(CvTplot,[],[],{'IC,calls','IC,tones','PS,calls','PS,tones'},4);
ylabel('baseline activity (meanDF)')
%% log scale cdfplot w/negative values

t_tones_IC = sign(meanDF_total_tones_IC).*log(abs(meanDF_total_tones_IC));
t_calls_IC = sign(meanDF_total_calls_IC).*log(abs(meanDF_total_calls_IC));
t_tones_PS = sign(meanDF_total_tones_PS).*log(abs(meanDF_total_tones_PS));
t_calls_PS = sign(meanDF_total_calls_PS).*log(abs(meanDF_total_calls_PS));

cmap_IC=brewermap(4,'Paired');
cmap_PS=gray(10);
figure; hold on
p(1)=cdfplot(t_tones_IC);
p(2)=cdfplot(t_calls_IC)
p(1).Color=cmap_IC(3,:)
p(2).Color=cmap_IC(4,:)


p(3)=cdfplot(t_tones_PS);
p(4)=cdfplot(t_calls_PS)
p(3).Color=cmap_PS(7,:)
p(4).Color=cmap_PS(1,:)
xlabel('activity during epoch (mean dF/F)')
ylabel('cumulative fraction of ROIs')
legend('IC,tones','IC,calls','PS,tones','PS,calls')

tmp=gca()
xlog_labels=tmp.XTick;
xlog_labels=sign(xlog_labels).*10.^(abs(xlog_labels))
tmp.XTick=xlog_labels;
%% compare trial responses to tones vs tones

% get means across stims IC

for d=1:length(IC)
    meanByTrial=IC(d).meanByTrial;
    meanByCall=cellfun(@mean,meanByTrial);
    meanCallbyCell_IC{d}=mean(meanByCall,1)';
    h_calls_IC{d}=sum(IC(d).h_calls,2)>0;
    
    % get tone responses
    toneTuning=IC(d).toneTuning
    meanByTone=cat(1,toneTuning(:).mean);
    meanTonebyCell_IC{d}=mean(meanByTone,2);
    h_tones_IC{d}=sum(IC(d).h_tone,2)>0;

end

meanCallbyCell_IC=cat(1,meanCallbyCell_IC{:});
meanTonebyCell_IC=cat(1,meanTonebyCell_IC{:});
h_calls_IC=cat(1,h_calls_IC{:});
h_tones_IC=cat(1,h_tones_IC{:});

% get means across stims PS

for d=1:length(PS)
    meanByTrial=PS(d).meanByTrial;
    meanByCall=cellfun(@mean,meanByTrial);
    meanCallbyCell_PS{d}=mean(meanByCall,1)';
    h_calls_PS{d}=sum(PS(d).h_calls,2)>0;

    % get tone responses
    toneTuning=PS(d).toneTuning
    meanByTone=cat(1,toneTuning(:).mean);
    meanTonebyCell_PS{d}=mean(meanByTone,2);
    h_tones_PS{d}=sum(PS(d).h_tone,2)>0;

end

meanCallbyCell_PS=cat(1,meanCallbyCell_PS{:});
meanTonebyCell_PS=cat(1,meanTonebyCell_PS{:});
h_calls_PS=cat(1,h_calls_PS{:});
h_tones_PS=cat(1,h_tones_PS{:});

h_inc_IC=h_calls_IC | h_tones_IC;
h_inc_PS=h_calls_PS | h_tones_PS;

figure; hold on
plot(meanTonebyCell_IC(h_inc_IC),meanCallbyCell_IC(h_inc_IC),'go')
plot(meanTonebyCell_PS(h_inc_PS),meanCallbyCell_PS(h_inc_PS),'ko')
maxVal=max([meanCallbyCell_PS(h_inc_PS);meanCallbyCell_IC(h_inc_IC);meanTonebyCell_PS(h_inc_PS);meanTonebyCell_IC(h_inc_IC)])
minVal=min([meanCallbyCell_PS(h_inc_PS);meanCallbyCell_IC(h_inc_IC);meanTonebyCell_PS(h_inc_PS);meanTonebyCell_IC(h_inc_IC)])
xlabel('mean tone response (all tones)');
ylabel('mean call response (all calls)');
title('significantly responsive ROIs');
tmp=gca;
tmp.XLim=[minVal maxVal];
tmp.YLim=[minVal maxVal];
plot([minVal maxVal],[minVal maxVal],'k:')
axis square


[h_ic_response_all,p_ic_response_all]=ttest(meanTonebyCell_IC,meanCallbyCell_IC);
[h_ps_response_all,p_ps_response_all]=ttest(meanTonebyCell_PS,meanCallbyCell_PS);

[h_ic_response_sig,p_ic_response_sig]=ttest(meanTonebyCell_IC(h_inc_IC),meanCallbyCell_IC(h_inc_IC))
[h_ps_response_sig,p_ps_response_sig]=ttest(meanTonebyCell_PS(h_inc_PS),meanCallbyCell_PS(h_inc_PS))

%% 

CvTplot={meanCallbyCell_IC,meanTonebyCell_IC,meanCallbyCell_PS,meanTonebyCell_PS};
figure; hold on
plotSpread(CvTplot,[],[],{'IC,calls','IC,tones','PS,calls','PS,tones'},4);
ylabel('time-locked responses (meanDF)')
%%
cmap_IC=brewermap(4,'Paired');
cmap_PS=gray(10);
figure; hold on
p(1)=cdfplot(meanTonebyCell_IC);
p(2)=cdfplot(meanCallbyCell_IC)
p(1).Color=cmap_IC(3,:)
p(2).Color=cmap_IC(4,:)


p(3)=cdfplot(meanTonebyCell_PS);
p(4)=cdfplot(meanCallbyCell_PS)
p(3).Color=cmap_PS(7,:)
p(4).Color=cmap_PS(1,:)
xlabel('mean response (dF/F)')
ylabel('cumulative fraction of ROIs (all)')
legend('IC,tones','IC,calls','PS,tones','PS,calls')
title('mean time-locked response')

%%
cmap_IC=brewermap(4,'Paired');
cmap_PS=gray(10);
figure; hold on
p(1)=cdfplot(meanTonebyCell_IC(h_inc_IC));
p(2)=cdfplot(meanCallbyCell_IC(h_inc_IC))
p(1).Color=cmap_IC(3,:)
p(2).Color=cmap_IC(4,:)


p(3)=cdfplot(meanTonebyCell_PS(h_inc_PS));
p(4)=cdfplot(meanCallbyCell_PS(h_inc_PS))
p(3).Color=cmap_PS(7,:)
p(4).Color=cmap_PS(1,:)
xlabel('mean response (dF/F)')
ylabel('cumulative fraction of ROIs (sig only)')
legend('IC,tones','IC,calls','PS,tones','PS,calls')
title('mean time-locked response')
%%
figure; hold on
plot(meanTonebyCell_IC,meanCallbyCell_IC,'go')
plot(meanTonebyCell_PS,meanCallbyCell_PS,'ko')
maxVal=max([meanCallbyCell_PS;meanCallbyCell_IC;meanTonebyCell_PS;meanTonebyCell_IC])
minVal=min([meanCallbyCell_PS;meanCallbyCell_IC;meanTonebyCell_PS;meanTonebyCell_IC])
xlabel('mean tone response (all tones)');
ylabel('mean call response (all calls)');
title('all ROIs');
tmp=gca;
tmp.XLim=[minVal maxVal];
tmp.YLim=[minVal maxVal];
plot([minVal maxVal],[minVal maxVal],'k:')
axis square

%% compare ratio of mean responses (across stimuli)

CallvTone_IC=meanCallbyCell_IC./meanTonebyCell_IC;
CallvTone_PS=meanCallbyCell_PS./meanTonebyCell_PS;
CvTplot={CallvTone_IC,CallvTone_PS};
figure; hold on
plotSpread(CvTplot,[],[],{'IC-projecting','PS-projecting'},4);
ylabel('ratio of activity during calls vs. tones')

%% compare trial responses to tones vs tones, best stimuli

% get means across stims IC

for d=1:length(IC)
    meanByTrial=IC(d).meanByTrial;
    meanByCall=cellfun(@mean,meanByTrial)';
    bestCallbyCell_IC{d}=max(meanByCall,[],2);
%     h_calls_IC{d}=sum(IC(d).h_calls,2)>0;
    
    % get tone responses
    toneTuning=IC(d).toneTuning;
    meanByTone=cat(1,toneTuning(:).mean);
    bestTonebyCell_IC{d}=max(meanByTone,[],2);
%     h_tones_IC{d}=sum(IC(d).h_tone,2)>0;

end

bestCallbyCell_IC=cat(1,bestCallbyCell_IC{:});
bestTonebyCell_IC=cat(1,bestTonebyCell_IC{:});

% get means across stims PS

for d=1:length(PS)
    meanByTrial=PS(d).meanByTrial;
    meanByCall=cellfun(@mean,meanByTrial)';
    bestCallbyCell_PS{d}=max(meanByCall,[],2);
%     h_calls_PS{d}=sum(PS(d).h_calls,2)>0;

    % get tone responses
    toneTuning=PS(d).toneTuning;
    meanByTone=cat(1,toneTuning(:).mean);
    bestTonebyCell_PS{d}=max(meanByTone,[],2);
%     h_tones_PS{d}=sum(PS(d).h_tone,2)>0;

end

bestCallbyCell_PS=cat(1,bestCallbyCell_PS{:});
bestTonebyCell_PS=cat(1,bestTonebyCell_PS{:});
% h_calls_PS=cat(1,h_calls_PS{:});
% h_tones_PS=cat(1,h_tones_PS{:});

% h_inc_IC=h_calls_IC | h_tones_IC;
% h_inc_PS=h_calls_PS | h_tones_PS;

figure; hold on
plot(bestTonebyCell_IC(h_inc_IC),bestCallbyCell_IC(h_inc_IC),'go')
plot(bestTonebyCell_PS(h_inc_PS),bestCallbyCell_PS(h_inc_PS),'ko')
maxVal=max([bestCallbyCell_PS(h_inc_PS);bestCallbyCell_IC(h_inc_IC);bestTonebyCell_PS(h_inc_PS);bestTonebyCell_IC(h_inc_IC)])
minVal=min([bestCallbyCell_PS(h_inc_PS);bestCallbyCell_IC(h_inc_IC);bestTonebyCell_PS(h_inc_PS);bestTonebyCell_IC(h_inc_IC)])

tmp=gca;
tmp.XLim=[minVal maxVal];
tmp.YLim=[minVal maxVal];
plot([minVal maxVal],[minVal maxVal],'k:')
axis square
xlabel('mean tone response (best tone)');
ylabel('mean call response (best call)');
title('significantly responsive ROIs');


figure; hold on
plot(bestTonebyCell_IC,bestCallbyCell_IC,'go')
plot(bestTonebyCell_PS,bestCallbyCell_PS,'ko')
maxVal=max([bestCallbyCell_PS;bestCallbyCell_IC;bestTonebyCell_PS;bestTonebyCell_IC])
minVal=min([bestCallbyCell_PS;bestCallbyCell_IC;bestTonebyCell_PS;bestTonebyCell_IC])

tmp=gca;
tmp.XLim=[minVal maxVal];
tmp.YLim=[minVal maxVal];
plot([minVal maxVal],[minVal maxVal],'k:')
axis square
xlabel('mean tone response (best tone)');
ylabel('mean call response (best call)');
title('all ROIs');


%%
[h_ic_best_all,p_ic_best_all]=ttest(bestTonebyCell_IC,bestCallbyCell_IC)
[h_ps_best_all,p_ps_best_all]=ttest(bestTonebyCell_PS,bestCallbyCell_PS)

[h_ic_best_sig,p_ic_best_sig]=ttest(bestTonebyCell_IC(h_inc_IC),bestCallbyCell_IC(h_inc_IC))
[h_ps_best_sig,p_ps_best_sig]=ttest(bestTonebyCell_PS(h_inc_PS),bestCallbyCell_PS(h_inc_PS))

%%
cmap_IC=brewermap(4,'Paired');
cmap_PS=gray(10);
figure; hold on
p(1)=cdfplot(bestTonebyCell_IC);
p(2)=cdfplot(bestCallbyCell_IC)
p(1).Color=cmap_IC(3,:)
p(2).Color=cmap_IC(4,:)


p(3)=cdfplot(bestTonebyCell_PS);
p(4)=cdfplot(bestCallbyCell_PS)
p(3).Color=cmap_PS(7,:)
p(4).Color=cmap_PS(1,:)
xlabel('best response, all stimuli')
ylabel('cumulative fraction of ROIs (all)')
legend('IC,tones','IC,calls','PS,tones','PS,calls')

%% swarm plot of responses to best stims

CvTplot={bestCallbyCell_IC,bestTonebyCell_IC,bestCallbyCell_PS,bestTonebyCell_PS};
figure; hold on
plotSpread(CvTplot,[],[],{'IC,calls','IC,tones','PS,calls','PS,tones'},4);
ylabel('response to best call or tone (meanDF)')

[h_bestCall_sig,p_bestCall_sig]=ttest2(bestCallbyCell_PS(h_inc_PS),bestCallbyCell_IC(h_inc_IC))
[h_bestCall_sig,p_bestCall_sig]=ttest2(bestCallbyCell_PS,bestCallbyCell_IC)

meanIC=mean(bestCallbyCell_IC)
semIC=std(bestCallbyCell_IC)/sqrt(length(bestCallbyCell_IC))

meanPS=mean(bestCallbyCell_PS)
semPS=std(bestCallbyCell_PS)/sqrt(length(bestCallbyCell_PS))

%%
cmap_IC=brewermap(4,'Paired');
cmap_PS=gray(10);
figure; hold on
p(1)=cdfplot(bestTonebyCell_IC(h_inc_IC));
p(2)=cdfplot(bestCallbyCell_IC(h_inc_IC))
p(1).Color=cmap_IC(3,:)
p(2).Color=cmap_IC(4,:)


p(3)=cdfplot(bestTonebyCell_PS(h_inc_PS));
p(4)=cdfplot(bestCallbyCell_PS(h_inc_PS))
p(3).Color=cmap_PS(7,:)
p(4).Color=cmap_PS(1,:)
xlabel('best response, all stimuli')
ylabel('cumulative fraction of ROIs (sig only)')
legend('IC,tones','IC,calls','PS,tones','PS,calls')