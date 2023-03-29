% compare tuning for tones vs calls in PS vs IC projecting in retrievers

%% load PS data first day

paths_PS={'/Volumes/pupCalls1/reduced/PS525/20220628/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS526/20220628/field1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS526/20220628/field2/suite2p/plane0/'...
    };


% paths_PS={'/Volumes/pupcalls2/retro_GCaMP_mouse3/20210527/suite2p/plane0/',...
%     '/Volumes/pupcalls2/retro_GCaMP_mouse3/20210528_field4/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS715/20210806/f1/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS715/20210806/f2/suite2p/plane0/',...
%     '/Volumes/pupcalls2/PS12202/reduced/20220112/f1/suite2p/plane0/',...
%     '/Volumes/pupcalls2/PS12202/reduced/20220112/f2/suite2p/plane0/'};

%
% '/Volumes/pupCalls1/reduced/PS1001/20211102/f1/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1001/20211102/f2/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1001/20211103/f3/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1001/20211103/f4/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1008/20211103/f4/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1008/20211103/f5/suite2p/plane0/',...
%load galvo data
for d=1:length(paths_PS)
    [F_calls_2sec,F_calls_5sec,F_calls_10sec,F_byToneRep_3sec,F_byToneRep_5sec,...
        ops,inds_ex,Fcell]=load2p_data_pupcalls_multiISI(paths_PS{d});

    [deltaF_calls_PS_5sec{d}] = pupCalls_make_deltaFall(F_calls_5sec,3,0);
    [deltaF_calls_PS_10sec{d}] = pupCalls_make_deltaFall(F_calls_10sec,3,0);

    if ~isempty(F_calls_2sec{1})
        [deltaF_calls_PS_2sec{d}] = pupCalls_make_deltaFall(F_calls_2sec,3,0);
    else
        deltaF_calls_PS_2sec{d}=[];
    end

    [deltaF_tones_PS_5sec{d}] = tones_make_deltaFall(F_byToneRep_5sec,3,0,30);
    [deltaF_tones_PS_3sec{d}] = tones_make_deltaFall(F_byToneRep_3sec,3,0,30);

    meanDF_total_calls_PS_5sec{d}=mean(deltaF_calls_PS_5sec{d},2);
    meanDF_total_calls_PS_10sec{d}=mean(deltaF_calls_PS_10sec{d},2);
    meanDF_total_tones_PS_3sec{d}=mean(deltaF_tones_PS_3sec{d},2);
    meanDF_total_tones_PS_5sec{d}=mean(deltaF_tones_PS_5sec{d},2);

        load([paths_PS{d},'reduced_data.mat'],'meanByTrial_early_10sec','meanByTrial_early_5sec','meanByTrial_early_2sec',...
            'h_10sec','h_5sec','h_2sec');
        load([paths_PS{d},'tone_tuning.mat'],'TUNING_5sec','dFByTone_5sec','h_pass_5sec','TUNING_3sec','dFByTone_3sec','h_pass_3sec');
        PS(d).meanByTrial_10sec = meanByTrial_early_10sec;
        PS(d).meanByTrial_5sec = meanByTrial_early_5sec;
        PS(d).meanByTrial_2sec = meanByTrial_early_2sec;
        PS(d).h_10sec= h_10sec;
        PS(d).h_5sec= h_5sec;
        PS(d).h_2sec= h_2sec;
        PS(d).toneTuning_5sec=TUNING_5sec;
        PS(d).dFByTone_5sec=dFByTone_5sec;
        PS(d).h_tone_5sec=h_pass_5sec;
          PS(d).toneTuning_3sec=TUNING_3sec;
        PS(d).dFByTone_3sec=dFByTone_3sec;
        PS(d).h_tone_3sec=h_pass_3sec;

end

%% load IC data first day

paths_IC= {'/Volumes/pupCalls1/reduced/IC623/20220718/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC622/20220718/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC617/20220703/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC603/20220627/suite2p/plane0/'...
    };

% paths_IC = {'/Volumes/pupCalls1/reduced/IC824/20211001/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC929/20211019/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC929/20211021/f1/suite2p/plane0/',...%'/Volumes/pupCalls1/reduced/IC929/20211021/f2/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC928/20211022/suite2p/plane0/',...
%     '/Volumes/pupCalls2/IC1122/reduced/20211207/suite2p/plane0/'};

%load data
for d=1:length(paths_IC)
    [F_calls_2sec,F_calls_5sec,F_calls_10sec,F_byToneRep_3sec,F_byToneRep_5sec,...
        ops,inds_ex,Fcell]=load2p_data_pupcalls_multiISI(paths_IC{d});

    [deltaF_calls_IC_5sec{d}] = pupCalls_make_deltaFall(F_calls_5sec,3,0);
    [deltaF_calls_IC_10sec{d}] = pupCalls_make_deltaFall(F_calls_10sec,3,0);

    if ~isempty(F_calls_2sec{1})
        [deltaF_calls_IC_2sec{d}] = pupCalls_make_deltaFall(F_calls_2sec,3,0);
    else
        deltaF_calls_IC_2sec{d}=[];
    end

    [deltaF_tones_IC_5sec{d}] = tones_make_deltaFall(F_byToneRep_5sec,3,0,30);
    [deltaF_tones_IC_3sec{d}] = tones_make_deltaFall(F_byToneRep_3sec,3,0,30);

    meanDF_total_calls_IC_5sec{d}=mean(deltaF_calls_IC_5sec{d},2);
    meanDF_total_calls_IC_10sec{d}=mean(deltaF_calls_IC_10sec{d},2);
    meanDF_total_tones_IC_3sec{d}=mean(deltaF_tones_IC_3sec{d},2);
    meanDF_total_tones_IC_5sec{d}=mean(deltaF_tones_IC_5sec{d},2);

    load([paths_IC{d},'reduced_data.mat'],'meanByTrial_early_10sec','meanByTrial_early_5sec','meanByTrial_early_2sec',...
            'h_10sec','h_5sec','h_2sec');
        load([paths_IC{d},'tone_tuning.mat'],'TUNING_5sec','dFByTone_5sec','h_pass_5sec','TUNING_3sec','dFByTone_3sec','h_pass_3sec');
        IC(d).meanByTrial_10sec = meanByTrial_early_10sec;
        IC(d).meanByTrial_5sec = meanByTrial_early_5sec;
        IC(d).meanByTrial_2sec = meanByTrial_early_2sec;
        IC(d).h_10sec= h_10sec;
        IC(d).h_5sec= h_5sec;
        IC(d).h_2sec= h_2sec;
        IC(d).toneTuning_5sec=TUNING_5sec;
        IC(d).dFByTone_5sec=dFByTone_5sec;
        IC(d).h_tone_5sec=h_pass_5sec;
          IC(d).toneTuning_3sec=TUNING_3sec;
        IC(d).dFByTone_3sec=dFByTone_3sec;
        IC(d).h_tone_3sec=h_pass_3sec;

end
%% load PS data last day

paths_PS={'/Volumes/pupCalls1/reduced/PS525/20220630/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS526/20220630/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/PS526/20220629/field2/suite2p/plane0/'};


% paths_PS={'/Volumes/pupcalls2/retro_GCaMP_mouse3/20210527/suite2p/plane0/',...
%     '/Volumes/pupcalls2/retro_GCaMP_mouse3/20210528_field4/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS715/20210806/f1/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS715/20210806/f2/suite2p/plane0/',...
%     '/Volumes/pupcalls2/PS12202/reduced/20220112/f1/suite2p/plane0/',...
%     '/Volumes/pupcalls2/PS12202/reduced/20220112/f2/suite2p/plane0/'};

%
% '/Volumes/pupCalls1/reduced/PS1001/20211102/f1/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1001/20211102/f2/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1001/20211103/f3/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1001/20211103/f4/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1008/20211103/f4/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/PS1008/20211103/f5/suite2p/plane0/',...
%load galvo data
for d=1:length(paths_PS)
    [F_calls_2sec,F_calls_5sec,F_calls_10sec,F_byToneRep_3sec,F_byToneRep_5sec,...
        ops,inds_ex,Fcell]=load2p_data_pupcalls_multiISI(paths_PS{d});

    [deltaF_calls_PS_5sec{d}] = pupCalls_make_deltaFall(F_calls_5sec,3,0);
    [deltaF_calls_PS_10sec{d}] = pupCalls_make_deltaFall(F_calls_10sec,3,0);

    if ~isempty(F_calls_2sec{1})
        [deltaF_calls_PS_2sec{d}] = pupCalls_make_deltaFall(F_calls_2sec,3,0);
    else
        deltaF_calls_PS_2sec{d}=[];
    end

    [deltaF_tones_PS_5sec{d}] = tones_make_deltaFall(F_byToneRep_5sec,3,0,30);
    [deltaF_tones_PS_3sec{d}] = tones_make_deltaFall(F_byToneRep_3sec,3,0,30);

    meanDF_total_calls_PS_5sec{d}=mean(deltaF_calls_PS_5sec{d},2);
    meanDF_total_calls_PS_10sec{d}=mean(deltaF_calls_PS_10sec{d},2);
    meanDF_total_tones_PS_3sec{d}=mean(deltaF_tones_PS_3sec{d},2);
    meanDF_total_tones_PS_5sec{d}=mean(deltaF_tones_PS_5sec{d},2);

        load([paths_PS{d},'reduced_data.mat'],'meanByTrial_early_10sec','meanByTrial_early_5sec','meanByTrial_early_2sec',...
            'h_10sec','h_5sec','h_2sec');
        load([paths_PS{d},'tone_tuning.mat'],'TUNING_5sec','dFByTone_5sec','h_pass_5sec','TUNING_3sec','dFByTone_3sec','h_pass_3sec');
        PS(d).meanByTrial_10sec = meanByTrial_early_10sec;
        PS(d).meanByTrial_5sec = meanByTrial_early_5sec;
        PS(d).meanByTrial_2sec = meanByTrial_early_2sec;
        PS(d).h_10sec= h_10sec;
        PS(d).h_5sec= h_5sec;
        PS(d).h_2sec= h_2sec;
        PS(d).toneTuning_5sec=TUNING_5sec;
        PS(d).dFByTone_5sec=dFByTone_5sec;
        PS(d).h_tone_5sec=h_pass_5sec;
          PS(d).toneTuning_3sec=TUNING_3sec;
        PS(d).dFByTone_3sec=dFByTone_3sec;
        PS(d).h_tone_3sec=h_pass_3sec;

end

%% load IC data last day

paths_IC= {'/Volumes/pupCalls1/reduced/IC623/20220720/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC622/20220720/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC617/20220706/field1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC617/20220706/field2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC603/20220630/field1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC603/20220630/field2/suite2p/plane0/'...
    };

% paths_IC = {'/Volumes/pupCalls1/reduced/IC824/20211001/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC929/20211019/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC929/20211021/f1/suite2p/plane0/',...%'/Volumes/pupCalls1/reduced/IC929/20211021/f2/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC928/20211022/suite2p/plane0/',...
%     '/Volumes/pupCalls2/IC1122/reduced/20211207/suite2p/plane0/'};

%load data
for d=1:length(paths_IC)
    [F_calls_2sec,F_calls_5sec,F_calls_10sec,F_byToneRep_3sec,F_byToneRep_5sec,...
        ops,inds_ex,Fcell]=load2p_data_pupcalls_multiISI(paths_IC{d});

    [deltaF_calls_IC_5sec{d}] = pupCalls_make_deltaFall(F_calls_5sec,3,0);
    [deltaF_calls_IC_10sec{d}] = pupCalls_make_deltaFall(F_calls_10sec,3,0);

    if ~isempty(F_calls_2sec{1})
        [deltaF_calls_IC_2sec{d}] = pupCalls_make_deltaFall(F_calls_2sec,3,0);
    else
        deltaF_calls_IC_2sec{d}=[];
    end

    [deltaF_tones_IC_5sec{d}] = tones_make_deltaFall(F_byToneRep_5sec,3,0,30);
    [deltaF_tones_IC_3sec{d}] = tones_make_deltaFall(F_byToneRep_3sec,3,0,30);

    meanDF_total_calls_IC_5sec{d}=mean(deltaF_calls_IC_5sec{d},2);
    meanDF_total_calls_IC_10sec{d}=mean(deltaF_calls_IC_10sec{d},2);
    meanDF_total_tones_IC_3sec{d}=mean(deltaF_tones_IC_3sec{d},2);
    meanDF_total_tones_IC_5sec{d}=mean(deltaF_tones_IC_5sec{d},2);

    load([paths_IC{d},'reduced_data.mat'],'meanByTrial_early_10sec','meanByTrial_early_5sec','meanByTrial_early_2sec',...
            'h_10sec','h_5sec','h_2sec');
        load([paths_IC{d},'tone_tuning.mat'],'TUNING_5sec','dFByTone_5sec','h_pass_5sec','TUNING_3sec','dFByTone_3sec','h_pass_3sec');
        IC(d).meanByTrial_10sec = meanByTrial_early_10sec;
        IC(d).meanByTrial_5sec = meanByTrial_early_5sec;
        IC(d).meanByTrial_2sec = meanByTrial_early_2sec;
        IC(d).h_10sec= h_10sec;
        IC(d).h_5sec= h_5sec;
        IC(d).h_2sec= h_2sec;
        IC(d).toneTuning_5sec=TUNING_5sec;
        IC(d).dFByTone_5sec=dFByTone_5sec;
        IC(d).h_tone_5sec=h_pass_5sec;
          IC(d).toneTuning_3sec=TUNING_3sec;
        IC(d).dFByTone_3sec=dFByTone_3sec;
        IC(d).h_tone_3sec=h_pass_3sec;

end

%% load IC data imaged post-retrieval

paths_IC= {'/Volumes/pupCalls1/reduced/IC623/20220812/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC622/20220812/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC617/20220811/field1/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC617/20220811/field2/suite2p/plane0/',...
    '/Volumes/pupCalls1/reduced/IC603/20220811/suite2p/plane0/'...
    };

% paths_IC = {'/Volumes/pupCalls1/reduced/IC824/20211001/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC929/20211019/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC929/20211021/f1/suite2p/plane0/',...%'/Volumes/pupCalls1/reduced/IC929/20211021/f2/suite2p/plane0/',...
%     '/Volumes/pupCalls1/reduced/IC928/20211022/suite2p/plane0/',...
%     '/Volumes/pupCalls2/IC1122/reduced/20211207/suite2p/plane0/'};

%load data
for d=1:length(paths_IC)
    [F_calls_2sec,F_calls_5sec,F_calls_10sec,F_byToneRep_3sec,F_byToneRep_5sec,...
        ops,inds_ex,Fcell]=load2p_data_pupcalls_multiISI(paths_IC{d});

    [deltaF_calls_IC_5sec{d}] = pupCalls_make_deltaFall(F_calls_5sec,3,0);
   
    if ~isempty(F_calls_10sec{1})
        [deltaF_calls_IC_10sec{d}] = pupCalls_make_deltaFall(F_calls_10sec,3,0);
    else
        deltaF_calls_IC_10sec{d}=[];
    end

    if ~isempty(F_calls_2sec{1})
        [deltaF_calls_IC_2sec{d}] = pupCalls_make_deltaFall(F_calls_2sec,3,0);
    else
        deltaF_calls_IC_2sec{d}=[];
    end

    [deltaF_tones_IC_5sec{d}] = tones_make_deltaFall(F_byToneRep_5sec,3,0,30);

    if ~isempty(F_byToneRep_3sec)
        [deltaF_tones_IC_3sec{d}] = tones_make_deltaFall(F_byToneRep_3sec,3,0,30);
    else
        deltaF_tones_IC_3sec{d}=[];
    end
    
    meanDF_total_calls_IC_5sec{d}=mean(deltaF_calls_IC_5sec{d},2);
    meanDF_total_calls_IC_10sec{d}=mean(deltaF_calls_IC_10sec{d},2);
    meanDF_total_tones_IC_3sec{d}=mean(deltaF_tones_IC_3sec{d},2);
    meanDF_total_tones_IC_5sec{d}=mean(deltaF_tones_IC_5sec{d},2);

    load([paths_IC{d},'reduced_data.mat'],'meanByTrial_early_10sec','meanByTrial_early_5sec','meanByTrial_early_2sec',...
            'h_10sec','h_5sec','h_2sec');
        load([paths_IC{d},'tone_tuning.mat'],'TUNING_5sec','dFByTone_5sec','h_pass_5sec','TUNING_3sec','dFByTone_3sec','h_pass_3sec');
        IC(d).meanByTrial_10sec = meanByTrial_early_10sec;
        IC(d).meanByTrial_5sec = meanByTrial_early_5sec;
        IC(d).meanByTrial_2sec = meanByTrial_early_2sec;
        IC(d).h_10sec= h_10sec;
        IC(d).h_5sec= h_5sec;
        IC(d).h_2sec= h_2sec;
        IC(d).toneTuning_5sec=TUNING_5sec;
        IC(d).dFByTone_5sec=dFByTone_5sec;
        IC(d).h_tone_5sec=h_pass_5sec;
          IC(d).toneTuning_3sec=TUNING_3sec;
        IC(d).dFByTone_3sec=dFByTone_3sec;
        IC(d).h_tone_3sec=h_pass_3sec;

end
%% concatenate and plot dF/F during calls and tones for each imaging field (IC)

for d=1:length(paths_IC)
    deltaF_calls_IC{d}=cat(2,deltaF_calls_IC_2sec{d},deltaF_calls_IC_5sec{d},deltaF_calls_IC_10sec{d});
    deltaF_tones_IC{d}=cat(2,deltaF_tones_IC_3sec{d},deltaF_tones_IC_5sec{d});

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
    %     
%      figure
%      spacing=2;
%      plot_raw_deltaF([deltaF_tones_IC{d},deltaF_calls_IC{d}],30,spacing,[]);
%      vline(size(deltaF_tones_IC{d},2)/30);
%      title(paths_IC{d})
end

%% concatenate and plot dF/F during calls and tones for each imaging field (PS)

for d=1:length(paths_PS)
    deltaF_calls_PS{d}=cat(2,deltaF_calls_PS_2sec{d},deltaF_calls_PS_5sec{d},deltaF_calls_PS_10sec{d});
     

     deltaF_tones_PS{d}=cat(2,deltaF_tones_PS_3sec{d},deltaF_tones_PS_5sec{d});

     meanDF_total_calls_PS{d}=mean(deltaF_calls_PS{d},2);
    meanDF_total_tones_PS{d}=mean(deltaF_tones_PS{d},2);

figure; hold on
    plot(meanDF_total_tones_PS{d},meanDF_total_calls_PS{d},'ko')
    maxVal=max([meanDF_total_tones_PS{d};meanDF_total_calls_PS{d}]);

    tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('activity during tone blocks')
ylabel('activity during call blocks')
title(paths_PS{d})
axis square
     figure
     spacing=2;
     plot_raw_deltaF([deltaF_tones_PS{d},deltaF_calls_PS{d}],30,spacing,[]);
     vline(size(deltaF_tones_PS{d},2)/30);
     title(paths_PS{d})
end
%% plot mean dF/F during tones vs. calls for each imaging field (IC)

for d=1:length(paths_IC)

    meanDF_total_calls_IC_5sec{d}=mean(deltaF_calls_IC_5sec{d},2);
    meanDF_total_calls_IC_10sec{d}=mean(deltaF_calls_IC_10sec{d},2);
    if ~isempty(deltaF_calls_IC_2sec{d})
        meanDF_total_calls_IC_2sec{d}=mean(deltaF_calls_IC_2sec{d},2);
    end
    meanDF_total_tones_IC_3sec{d}=mean(deltaF_tones_IC_3sec{d},2);
    meanDF_total_tones_IC_5sec{d}=mean(deltaF_tones_IC_5sec{d},2);
    

    cmap_calls=brewermap(6,'oranges');
    cmap_tones=gray(10);
    figure; hold on
    p(1)=cdfplot(meanDF_total_tones_IC_5sec{d});
    p(2)=cdfplot(meanDF_total_tones_IC_3sec{d});
    p(1).Color=cmap_tones(3,:);
    p(2).Color=cmap_tones(7,:);

    p(3)=cdfplot(meanDF_total_calls_IC_10sec{d});
    p(4)=cdfplot(meanDF_total_calls_IC_5sec{d});
    p(3).Color=cmap_calls(6,:);
    p(4).Color=cmap_calls(5,:);

    if ~isempty(deltaF_calls_IC_2sec{d})
        p(5)=cdfplot(meanDF_total_calls_IC_2sec{d});
        p(5).Color=cmap_calls(4,:);
    end
    xlabel('activity during epoch (mean dF/F)')
    ylabel('cumulative fraction of ROIs')
    legend('IC,tones 5s','IC,tones 3s','IC,calls 10s','IC,calls 5s','IC,calls 2s')
    title(paths_IC{d})

    figure; hold on
    plot(meanDF_total_calls_IC_5sec{d},meanDF_total_calls_IC_10sec{d},'ko')
    maxVal=max([meanDF_total_calls_IC_5sec{d};meanDF_total_calls_IC_10sec{d}]);

    tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('activity during call blocks, 5sec')
ylabel('activity during call blocks, 10sec')
title(paths_IC{d})
axis square
end

%% plot mean dF/F during tones vs. calls for each imaging field (PS)

for d=1:length(paths_PS)

    meanDF_total_calls_PS_5sec{d}=mean(deltaF_calls_PS_5sec{d},2);
    meanDF_total_calls_PS_10sec{d}=mean(deltaF_calls_PS_10sec{d},2);
    if ~isempty(deltaF_calls_PS_2sec{d})
        meanDF_total_calls_PS_2sec{d}=mean(deltaF_calls_PS_2sec{d},2);
    end
    meanDF_total_tones_PS_3sec{d}=mean(deltaF_tones_PS_3sec{d},2);
    meanDF_total_tones_PS_5sec{d}=mean(deltaF_tones_PS_5sec{d},2);
    

    cmap_calls=brewermap(6,'oranges');
    cmap_tones=gray(10);
    figure; hold on
    p(1)=cdfplot(meanDF_total_tones_PS_5sec{d});
    p(2)=cdfplot(meanDF_total_tones_PS_3sec{d});
    p(1).Color=cmap_tones(3,:);
    p(2).Color=cmap_tones(7,:);

    p(3)=cdfplot(meanDF_total_calls_PS_10sec{d});
    p(4)=cdfplot(meanDF_total_calls_PS_5sec{d});
    p(3).Color=cmap_calls(6,:);
    p(4).Color=cmap_calls(5,:);

    if ~isempty(deltaF_calls_PS_2sec{d})
        p(5)=cdfplot(meanDF_total_calls_PS_2sec{d});
        p(5).Color=cmap_calls(4,:);
    end
    xlabel('activity during epoch (mean dF/F)')
    ylabel('cumulative fraction of ROIs')
    legend('PS,tones 5s','PS,tones 3s','PS,calls 10s','PS,calls 5s','PS,calls 2s')
    title(paths_PS{d})

     figure; hold on
    plot(meanDF_total_calls_PS_5sec{d},meanDF_total_calls_PS_10sec{d},'ko')
    maxVal=max([meanDF_total_calls_PS_5sec{d};meanDF_total_calls_PS_10sec{d}]);

    tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('activity during call blocks, 5sec')
ylabel('activity during call blocks, 10sec')
title(paths_PS{d})
axis square
end

%% mean df/F during tone presentation vs call presentation, PS vs IC

meanDF_total_calls_IC=cat(1,meanDF_total_calls_IC{:});
meanDF_total_tones_IC=cat(1,meanDF_total_tones_IC{:});
meanDF_total_calls_PS=cat(1,meanDF_total_calls_PS{:});
meanDF_total_tones_PS=cat(1,meanDF_total_tones_PS{:});
maxVal=max([meanDF_total_calls_IC;meanDF_total_tones_IC;meanDF_total_calls_PS;meanDF_total_tones_PS]);


% tones vs calls 
figure; hold on
plot(meanDF_total_tones_IC,meanDF_total_calls_IC,'go')
plot(meanDF_total_tones_PS,meanDF_total_calls_PS,'ko')
tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('activity during tone blocks')
ylabel('activity during call blocks')
axis square



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
% [h_ic,p_ic]=ttest(meanDF_total_calls_IC_5sec,meanDF_total_tones_IC_3sec);
% [h_ps,p_ps]=ttest(meanDF_total_calls_PS_5sec,meanDF_total_tones_PS_3sec);
%% mean df/F during tone presentation, PS vs IC, 3s ISI for tones and 5s for calls

meanDF_total_calls_IC_5sec=cat(1,meanDF_total_calls_IC_5sec{:});
meanDF_total_tones_IC_3sec=cat(1,meanDF_total_tones_IC_3sec{:});
meanDF_total_calls_PS_5sec=cat(1,meanDF_total_calls_PS_5sec{:});
meanDF_total_tones_PS_3sec=cat(1,meanDF_total_tones_PS_3sec{:});
maxVal=max([meanDF_total_calls_IC_5sec;meanDF_total_tones_IC_3sec;meanDF_total_calls_PS_5sec;meanDF_total_tones_PS_3sec]);


% tones vs calls (3 sec tones, 5 sec calls)
figure; hold on
plot(meanDF_total_tones_IC_3sec,meanDF_total_calls_IC_5sec,'go')
plot(meanDF_total_tones_PS_3sec,meanDF_total_calls_PS_5sec,'ko')
tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('activity during tone blocks 3sec')
ylabel('activity during call blocks 5sec')
axis square



cmap_IC=brewermap(4,'Paired');
cmap_PS=gray(10);
figure; hold on
p(1)=cdfplot(meanDF_total_tones_IC_3sec);
p(2)=cdfplot(meanDF_total_calls_IC_5sec)
p(1).Color=cmap_IC(3,:)
p(2).Color=cmap_IC(4,:)


p(3)=cdfplot(meanDF_total_tones_PS_3sec);
p(4)=cdfplot(meanDF_total_calls_PS_5sec)
p(3).Color=cmap_PS(7,:)
p(4).Color=cmap_PS(1,:)
xlabel('activity during epoch (mean dF/F)')
ylabel('cumulative fraction of ROIs')
legend('IC,tones 3sec','IC,calls 5sec','PS,tones 3sec','PS,calls 5sec')
title('baseline activity')
[h_ic,p_ic]=ttest(meanDF_total_calls_IC_5sec,meanDF_total_tones_IC_3sec);
[h_ps,p_ps]=ttest(meanDF_total_calls_PS_5sec,meanDF_total_tones_PS_3sec);
%% mean df/F during tone presentation, PS vs IC, 5s ISI for calls vs 10s

meanDF_total_calls_IC_10sec=cat(1,meanDF_total_calls_IC_10sec{:});
meanDF_total_calls_PS_10sec=cat(1,meanDF_total_calls_PS_10sec{:});
maxVal=max([meanDF_total_calls_IC_5sec;meanDF_total_calls_IC_10sec;meanDF_total_calls_PS_5sec;meanDF_total_calls_PS_10sec]);


% tones vs calls (3 sec tones, 5 sec calls)
figure; hold on
plot(meanDF_total_calls_IC_5sec,meanDF_total_calls_IC_10sec,'go')
plot(meanDF_total_calls_PS_5sec,meanDF_total_calls_PS_10sec,'ko')
tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('activity during call blocks 5sec')
ylabel('activity during call blocks 10sec')
axis square



cmap_IC=brewermap(4,'Paired');
cmap_PS=gray(10);
figure; hold on
p(1)=cdfplot(meanDF_total_calls_IC_10sec);
p(2)=cdfplot(meanDF_total_calls_IC_5sec)
p(1).Color=cmap_IC(3,:)
p(2).Color=cmap_IC(4,:)


p(3)=cdfplot(meanDF_total_calls_PS_10sec);
p(4)=cdfplot(meanDF_total_calls_PS_5sec)
p(3).Color=cmap_PS(7,:)
p(4).Color=cmap_PS(1,:)
xlabel('activity during epoch (mean dF/F)')
ylabel('cumulative fraction of ROIs')
legend('IC,calls 10sec','IC,calls 5sec','PS,calls 10sec','PS,calls 5sec')
title('baseline activity')
% [h_ic,p_ic]=ttest(meanDF_total_calls_IC_5sec,meanDF_total_tones_IC_3sec);
% [h_ps,p_ps]=ttest(meanDF_total_calls_PS_5sec,meanDF_total_tones_PS_3sec);
%% mean df/F during tone presentation

meanDF_total_calls_IC_10sec=cat(1,meanDF_total_calls_IC_10sec{:});
meanDF_total_calls_IC_5sec=cat(1,meanDF_total_calls_IC_5sec{:});
% meanDF_total_calls_IC_2sec=cat(1,meanDF_total_calls_IC_2sec{:});
meanDF_total_tones_IC_3sec=cat(1,meanDF_total_tones_IC_3sec{:});
meanDF_total_tones_IC_5sec=cat(1,meanDF_total_tones_IC_5sec{:});
% meanDF_total_calls_PS=cat(1,meanDF_total_calls_PS{:});
% meanDF_total_tones_PS=cat(1,meanDF_total_tones_PS{:});
% maxVal=max([meanDF_total_calls_IC;meanDF_total_tones_IC;meanDF_total_calls_PS;meanDF_total_tones_PS]);

% figure; hold on
% plot(meanDF_total_tones_PS,meanDF_total_calls_PS,'ko')
% plot(meanDF_total_tones_IC,meanDF_total_calls_IC,'go')
% tmp=gca;
% tmp.XLim=[0 maxVal];
% tmp.YLim=[0 maxVal];
% plot([0 maxVal],[0 maxVal],'k:')
% xlabel('activity during tone blocks')
% ylabel('activity during call blocks')
% axis square



cmap_calls=brewermap(4,'Paired');
cmap_tones=gray(10);
figure; hold on
p(1)=cdfplot(meanDF_total_tones_IC_5sec);
p(2)=cdfplot(meanDF_total_calls_IC_5sec)
p(1).Color=cmap_tones(3,:)
p(2).Color=cmap_calls(2,:)
p(3)=cdfplot(meanDF_total_tones_IC_3sec);
p(4)=cdfplot(meanDF_total_calls_IC_10sec);
p(3).Color=cmap_tones(7,:)
p(4).Color=cmap_calls(1,:)


% p(3)=cdfplot(meanDF_total_tones_PS);
% p(4)=cdfplot(meanDF_total_calls_PS)
% p(3).Color=cmap_PS(7,:)
% p(4).Color=cmap_PS(1,:)
xlabel('activity during epoch (mean dF/F)')
ylabel('cumulative fraction of ROIs')
legend('IC,tones 5s','IC,calls 5s','IC,tones 3s','IC,calls 10s')
title('baseline activity')
% [h_ic,p_ic]=ttest(meanDF_total_calls_IC,meanDF_total_tones_IC);
% [h_ps,p_ps]=ttest(meanDF_total_calls_PS,meanDF_total_tones_PS);


%%

CvTplot={meanDF_total_calls_IC,meanDF_total_tones_IC,meanDF_total_calls_PS,meanDF_total_tones_PS};
figure; hold on
plotSpread(CvTplot,[],[],{'IC,calls','IC,tones','PS,calls','PS,tones'},4);
ylabel('baseline activity (meanDF)')
%% compare cell-by-cell responses to 5s ISI vs 10s ISI

% get means across stims IC

for d=1:length(IC)
    meanByTrial=IC(d).meanByTrial_5sec;
    meanByCall=cellfun(@mean,meanByTrial);
    meanCallbyCell_5s_IC{d}=mean(meanByCall,1)';
    bestCallbyCell_5s_IC{d}=max(meanByCall,[],1)';
    h_calls_5s_IC{d}=sum(IC(d).h_5sec,2)>0;

    meanByTrial=IC(d).meanByTrial_10sec;
    meanByCall=cellfun(@mean,meanByTrial);
    meanCallbyCell_10s_IC{d}=mean(meanByCall,1)';
    bestCallbyCell_10s_IC{d}=max(meanByCall,[],1)';
    h_calls_10s_IC{d}=sum(IC(d).h_10sec,2)>0;

    % get tone responses
    toneTuning=IC(d).toneTuning_3sec;
    meanByTone=cat(1,toneTuning(:).mean);
    meanTonebyCell_3s_IC{d}=mean(meanByTone,2);
    bestTonebyCell_3s_IC{d}=max(meanByTone,[],2);
    h_tones_3s_IC{d}=sum(IC(d).h_tone_3sec,2)>0;

    toneTuning=IC(d).toneTuning_5sec;
    meanByTone=cat(1,toneTuning(:).mean);
    meanTonebyCell_5s_IC{d}=mean(meanByTone,2);
    bestTonebyCell_5s_IC{d}=max(meanByTone,[],2);
    h_tones_5s_IC{d}=sum(IC(d).h_tone_5sec,2)>0;

end

meanCallbyCell_5s_IC=cat(1,meanCallbyCell_5s_IC{:});
meanCallbyCell_10s_IC=cat(1,meanCallbyCell_10s_IC{:});
meanTonebyCell_5s_IC=cat(1,meanTonebyCell_5s_IC{:});
meanTonebyCell_3s_IC=cat(1,meanTonebyCell_3s_IC{:});

bestCallbyCell_5s_IC=cat(1,bestCallbyCell_5s_IC{:});
bestCallbyCell_10s_IC=cat(1,bestCallbyCell_10s_IC{:});
bestTonebyCell_5s_IC=cat(1,bestTonebyCell_5s_IC{:});
bestTonebyCell_3s_IC=cat(1,bestTonebyCell_3s_IC{:});

% h_calls_IC=cat(1,h_calls_IC{:});
% h_tones_IC=cat(1,h_tones_IC{:});

% get means across stims PS


for d=1:length(PS)
    meanByTrial=PS(d).meanByTrial_5sec;
    meanByCall=cellfun(@mean,meanByTrial);
    meanCallbyCell_5s_PS{d}=mean(meanByCall,1)';
    bestCallbyCell_5s_PS{d}=max(meanByCall,[],1)';
    h_calls_5s_PS{d}=sum(PS(d).h_5sec,2)>0;

    meanByTrial=PS(d).meanByTrial_10sec;
    meanByCall=cellfun(@mean,meanByTrial);
    meanCallbyCell_10s_PS{d}=mean(meanByCall,1)';
    bestCallbyCell_10s_PS{d}=max(meanByCall,[],1)';
    h_calls_10s_PS{d}=sum(PS(d).h_10sec,2)>0;

    % get tone responses
    toneTuning=PS(d).toneTuning_3sec;
    meanByTone=cat(1,toneTuning(:).mean);
    meanTonebyCell_3s_PS{d}=mean(meanByTone,2);
    bestTonebyCell_3s_PS{d}=max(meanByTone,[],2);
    h_tones_3s_PS{d}=sum(PS(d).h_tone_3sec,2)>0;

    toneTuning=PS(d).toneTuning_5sec;
    meanByTone=cat(1,toneTuning(:).mean);
    meanTonebyCell_5s_PS{d}=mean(meanByTone,2);
    bestTonebyCell_5s_PS{d}=max(meanByTone,[],2);
    h_tones_5s_PS{d}=sum(PS(d).h_tone_5sec,2)>0;

end

meanCallbyCell_5s_PS=cat(1,meanCallbyCell_5s_PS{:});
meanCallbyCell_10s_PS=cat(1,meanCallbyCell_10s_PS{:});
meanTonebyCell_5s_PS=cat(1,meanTonebyCell_5s_PS{:});
meanTonebyCell_3s_PS=cat(1,meanTonebyCell_3s_PS{:});

bestCallbyCell_5s_PS=cat(1,bestCallbyCell_5s_PS{:});
bestCallbyCell_10s_PS=cat(1,bestCallbyCell_10s_PS{:});
bestTonebyCell_5s_PS=cat(1,bestTonebyCell_5s_PS{:});
bestTonebyCell_3s_PS=cat(1,bestTonebyCell_3s_PS{:});
% h_calls_PS=cat(1,h_calls_PS{:});
% h_tones_PS=cat(1,h_tones_PS{:});
% 
% h_inc_IC=h_calls_IC | h_tones_IC;
% h_inc_PS=h_calls_PS | h_tones_PS;

%% plots - calls 10s vs 5s
figure; hold on
plot(meanCallbyCell_5s_IC,meanCallbyCell_10s_IC,'go')
plot(meanCallbyCell_5s_PS,meanCallbyCell_10s_PS,'ko')
maxVal=max([meanCallbyCell_5s_IC;meanCallbyCell_10s_IC;meanCallbyCell_5s_PS;meanCallbyCell_10s_PS]);
minVal=min([meanCallbyCell_5s_IC;meanCallbyCell_10s_IC;meanCallbyCell_5s_PS;meanCallbyCell_10s_PS]);
xlabel('mean call response (all calls), 5s ISI');
ylabel('mean call response (all calls), 10s ISI');
% title('significantly responsive ROIs');
tmp=gca;
tmp.XLim=[minVal maxVal];
tmp.YLim=[minVal maxVal];
plot([minVal maxVal],[minVal maxVal],'k:')
axis square

figure; hold on
plot(bestCallbyCell_5s_IC,bestCallbyCell_10s_IC,'go')
plot(bestCallbyCell_5s_PS,bestCallbyCell_10s_PS,'ko')
maxVal=max([bestCallbyCell_5s_IC;bestCallbyCell_10s_IC;bestCallbyCell_5s_PS;bestCallbyCell_10s_PS]);
minVal=min([bestCallbyCell_5s_IC;bestCallbyCell_10s_IC;bestCallbyCell_5s_PS;bestCallbyCell_10s_PS]);
xlabel('best call response (all calls), 5s ISI');
ylabel('best call response (all calls), 10s ISI');
% title('significantly responsive ROIs');
tmp=gca;
tmp.XLim=[minVal maxVal];
tmp.YLim=[minVal maxVal];
plot([minVal maxVal],[minVal maxVal],'k:')
axis square

%% plots - tones 3s vs 5s
figure; hold on
plot(meanTonebyCell_5s_IC,meanTonebyCell_3s_IC,'go')
plot(meanTonebyCell_5s_PS,meanTonebyCell_3s_PS,'ko')
maxVal=max([meanTonebyCell_5s_IC;meanTonebyCell_3s_IC;meanTonebyCell_5s_PS;meanTonebyCell_3s_PS]);
minVal=min([meanTonebyCell_5s_IC;meanTonebyCell_3s_IC;meanTonebyCell_5s_PS;meanTonebyCell_3s_PS]);
xlabel('mean Tone response (all Tones), 5s ISI');
ylabel('mean Tone response (all Tones), 3s ISI');
% title('significantly responsive ROIs');
tmp=gca;
tmp.XLim=[minVal maxVal];
tmp.YLim=[minVal maxVal];
plot([minVal maxVal],[minVal maxVal],'k:')
axis square

figure; hold on
plot(bestTonebyCell_5s_IC,bestTonebyCell_3s_IC,'go')
plot(bestTonebyCell_5s_PS,bestTonebyCell_3s_PS,'ko')
maxVal=max([bestTonebyCell_5s_IC;bestTonebyCell_3s_IC;bestTonebyCell_5s_PS;bestTonebyCell_3s_PS]);
minVal=min([bestTonebyCell_5s_IC;bestTonebyCell_3s_IC;bestTonebyCell_5s_PS;bestTonebyCell_3s_PS]);
xlabel('best Tone response (all Tones), 5s ISI');
ylabel('best Tone response (all Tones), 3s ISI');
% title('significantly responsive ROIs');
tmp=gca;
tmp.XLim=[minVal maxVal];
tmp.YLim=[minVal maxVal];
plot([minVal maxVal],[minVal maxVal],'k:')
axis square

%% compare trial responses to tones vs tones

% get means across stims IC

for d=1:length(IC)
    meanByTrial=IC(d).meanByTrial_5sec;
    meanByCall=cellfun(@mean,meanByTrial);
    meanCallbyCell_IC{d}=mean(meanByCall,1)';
    h_calls_IC{d}=sum(IC(d).h_5sec,2)>0;

    % get tone responses
    toneTuning=IC(d).toneTuning_3sec;
    meanByTone=cat(1,toneTuning(:).mean);
    meanTonebyCell_IC{d}=mean(meanByTone,2);
    h_tones_IC{d}=sum(IC(d).h_tone_3sec,2)>0;

end

meanCallbyCell_IC=cat(1,meanCallbyCell_IC{:});
meanTonebyCell_IC=cat(1,meanTonebyCell_IC{:});
h_calls_IC=cat(1,h_calls_IC{:});
h_tones_IC=cat(1,h_tones_IC{:});

% get means across stims PS

for d=1:length(PS)
    meanByTrial=PS(d).meanByTrial_5sec;
    meanByCall=cellfun(@mean,meanByTrial);
    meanCallbyCell_PS{d}=mean(meanByCall,1)';
    h_calls_PS{d}=sum(PS(d).h_5sec,2)>0;

    % get tone responses
    toneTuning=PS(d).toneTuning_3sec;
    meanByTone=cat(1,toneTuning(:).mean);
    meanTonebyCell_PS{d}=mean(meanByTone,2);
    h_tones_PS{d}=sum(PS(d).h_tone_3sec,2)>0;

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


%% compare trial responses to tones vs tones, best stimuli

% get means across stims IC

for d=1:length(IC)
    meanByTrial=IC(d).meanByTrial_5sec;
    meanByCall=cellfun(@mean,meanByTrial)';
    bestCallbyCell_IC{d}=max(meanByCall,[],2);
    %     h_calls_IC{d}=sum(IC(d).h_calls,2)>0;

    % get tone responses
    toneTuning=IC(d).toneTuning_3sec;
    meanByTone=cat(1,toneTuning(:).mean);
    bestTonebyCell_IC{d}=max(meanByTone,[],2);
    %     h_tones_IC{d}=sum(IC(d).h_tone,2)>0;

end

bestCallbyCell_IC=cat(1,bestCallbyCell_IC{:});
bestTonebyCell_IC=cat(1,bestTonebyCell_IC{:});

% get means across stims PS

for d=1:length(PS)
    meanByTrial=PS(d).meanByTrial_5sec;
    meanByCall=cellfun(@mean,meanByTrial)';
    bestCallbyCell_PS{d}=max(meanByCall,[],2);
    %     h_calls_PS{d}=sum(PS(d).h_calls,2)>0;

    % get tone responses
    toneTuning=PS(d).toneTuning_3sec;
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