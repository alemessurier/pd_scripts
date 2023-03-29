function [dFByTrial,h,p]=pupCall_imaging_pipeline_multiISI_spikes(path_2p,plotting)

%% load data
[F_calls_2sec,F_calls_5sec,F_calls_10sec,F_byToneRep_3sec,F_byToneRep_5sec,ops,inds_ex,Fcell]=load2p_data_pupcalls_multiISI_spks(path_2p);

%%
if ~isempty(F_calls_2sec{1})
    F_calls_sorted_2sec = pupCall_pipeline_sort_F_calls(F_calls_2sec,3,61,plotting); %updated stim ISI to include an additional frame due to code error, 20220829
end

if ~isempty(F_calls_5sec{1})
    F_calls_sorted_5sec = pupCall_pipeline_sort_F_calls(F_calls_5sec,3,151,plotting);
end

if ~isempty(F_calls_10sec{1})
    F_calls_sorted_10sec = pupCall_pipeline_sort_F_calls(F_calls_10sec,3,301,plotting);
end
%% get tuning for pup calls
if ~isempty(F_calls_2sec{1})
    dFByTrial_2sec = pupCall_pipeline_get_dFbyTrial(F_calls_sorted_2sec,ops,61,1,2);
else
    dFByTrial_2sec={};
end

if ~isempty(F_calls_5sec{1})
    dFByTrial_5sec = pupCall_pipeline_get_dFbyTrial(F_calls_sorted_5sec,ops,151,2,5);
end

if ~isempty(F_calls_10sec{1})
    dFByTrial_10sec = pupCall_pipeline_get_dFbyTrial(F_calls_sorted_10sec,ops,301,2,10);
else
    dFByTrial_10sec={};
end
%% make structure of mean responses by ROI

% 2sec isi
meanByTrial_early_2sec=cell(size(dFByTrial_2sec));

if ~isempty(F_calls_2sec{1})
    numCells=size(dFByTrial_2sec,2);
    frames_evoked_early=31:90;


    for c=1:numCells
        meanByTrial_early_2sec(:,c)=cellfun(@(x)mean(x(:,frames_evoked_early),2),dFByTrial_2sec(:,c),'un',0);
    end
end
% 5sec isi
numCells=size(dFByTrial_5sec,2);
frames_evoked_early=61:141;
meanByTrial_early_5sec=cell(size(dFByTrial_5sec));


for c=1:numCells
    meanByTrial_early_5sec(:,c)=cellfun(@(x)mean(x(:,frames_evoked_early),2),dFByTrial_5sec(:,c),'un',0);
end

meanAll=cellfun(@mean,meanByTrial_early_5sec);
figure; imagesc(meanAll')

% 10sec isi

if ~isempty(F_calls_10sec{1})
    numCells=size(dFByTrial_10sec,2);
    frames_evoked_early=61:141;
    for c=1:numCells
        meanByTrial_early_10sec(:,c)=cellfun(@(x)mean(x(:,frames_evoked_early),2),dFByTrial_10sec(:,c),'un',0);
    end

meanAll=cellfun(@mean,meanByTrial_early_10sec);
figure; imagesc(meanAll')
else
    meanByTrial_early_10sec=[];
end

% % view all trials across cells
% for c=1:numCells
%     meanByTrial_allcalls_early{c}=cat(1,meanByTrial_early{:,c});
% end
% meanByTrial_allcalls_early=cat(2,meanByTrial_allcalls_early{:});
%
% switch plotting
%     case 1
%         figure; imagesc(meanByTrial_allcalls_early);
%         colormap gray
%     case 0
% end


%%

for i=1:size(Fcell,1)
    Fcell_filt(i,:)=slidingAvg_rawF( Fcell(i,:),3,'median' );
end

samp_rate=30;

if ~isempty(F_calls_2sec{1})

    [P_2sec,responsiveTrials_2sec,bootDist]=pupCall_sigTest(meanByTrial_early_2sec,Fcell_filt,dFByTrial_2sec,10000,2,31:90,samp_rate);
    h_2sec=P_2sec<=0.05;
else
    P_2sec=[];
    h_2sec=[];
    responsiveTrials_2sec=[];
end


[P_5sec,responsiveTrials_5sec,bootDist]=pupCall_sigTest(meanByTrial_early_5sec,Fcell_filt,dFByTrial_5sec,10000,2,frames_evoked_early,samp_rate);
h_5sec=P_5sec<=0.05;


if ~isempty(F_calls_10sec{1})

    [P_10sec,responsiveTrials_10sec,bootDist]=pupCall_sigTest(meanByTrial_early_10sec,Fcell_filt,dFByTrial_10sec,10000,2,frames_evoked_early,samp_rate);
    h_10sec=P_10sec<=0.05;
else
    P_10sec=[];
    h_10sec=[];
    responsiveTrials_10sec=[];
end
% h_calls=h_early | h_late;
% %%
%
% numtrials=cellfun(@(x)length(x),responsiveTrials_early(:,1));
% min_trials=min(numtrials);
% responsiveTrials_tmp=cellfun(@(x)x(1:min_trials),responsiveTrials_early,'un',0);
% for c=1:numCells
%     responsiveTrials_byCell{c}=cat(2,responsiveTrials_tmp{:,c});
%     switch plotting
%         case 1
%             figure; imagesc(responsiveTrials_byCell{c});
%         case 0
%     end
% end
%%
switch plotting
    case 1
        pupCalls_plotTuning(dFByTrial_5sec,h_5sec,30)
end

%%
switch plotting
    case 1
        pupCalls_plotTuning(dFByTrial_10sec,h_10sec,30)
end

%%
switch plotting
    case 1
        pupCalls_plotTuning(dFByTrial_2sec,h_2sec,30)
end

%%
%     pupCalls_plotTuning_single(dFByTrial,h,30,4)



% %% combine dF/F across calls for each cell
%
% dFbyCell=cell(1,size(dFByTrial,2));
% for i=1:length(dFbyCell)
%     dFbyCell{i}=cat(1,dFByTrial{:,i});
% end
%
% [P_allCalls,responsiveTrials_allCalls,bootDist_allCalls]=pupCall_sigTest_allCalls(meanByTrial_allcalls_early,Fcell,dFbyCell,10000,2,2,samp_rate);
%
% h_cell=P_allCalls<=0.05;
% for i=1:length(dFbyCell)
%     thisCell=dFbyCell{i};
%
%
%
%     switch plotting
%         case 1
%             figure; hold on
%
%             subplot(2,1,1)
%             timeplot=((1:size(thisCell,2))-60)/30;
%
%             shadedErrorBar(timeplot,mean(thisCell,1), std(thisCell,[],1)./sqrt(size(thisCell,1)));
%             hold on
%             if h_cell(i) == 1
%                 COLOR = 'r:';
%             else
%                 COLOR = 'k:';
%             end
%             vline(0,COLOR)
%             %         vline(0,'r:');
%             tmp=gca;
%             tmp.Box='off';
%             %         tmp.XTickLabel=[];
%             tmp.XAxisLocation='origin';
%             axis square
%
%             subplot(2,1,2)
%             imagesc(thisCell);
%             colormap gray
%             axis square
%     end
% end
%%

%% tones 3sec
if isempty(F_byToneRep_3sec)
    sprintf('no passive tuning measured on this date');
    TUNING_3sec=[];
    dFByTone_3sec=[];
    h_pass_3sec=[];
    p_pass_3sec=[];
else
    F_byToneRep_3sec_sorted = pupCall_pipeline_sort_F_tones(F_byToneRep_3sec,3,91,plotting);

    freq_path='/Volumes/aml717/Personal/MATLAB/pd_scripts/HALFOCTAVE.txt';%'H:\Personal\MATLAB\pd_scripts\HALFOCTAVE.txt';
    %     filtF=cell(1,numel(F_byToneRep_3sec_sorted));
    %     F_corrected=filtF;
    %     % filter data w/moving median filter
    %     for f=1:length(F_byToneRep_3sec_sorted)
    %         F_corrected{f}=F_byToneRep_3sec_sorted(f).FROI;%-0.7*F_byToneRep(f).Fneu;
    %         filtF_tmp=zeros(size(F_corrected{f}));
    %
    %         for i=1:size(F_corrected{f},1)
    %             filtF_tmp(i,:) = slidingAvg_rawF( F_corrected{f}(i,:),2,'median' );
    %         end
    %         filtF{f}=filtF_tmp;
    %
    %     end

    samp_rate=ops.fs;
    stimFrames=91:91:1000;
    [TUNING_3sec,dFByTone_3sec,h_pass_3sec,p_pass_3sec] = extract_toneTuning_pupcalls(F_byToneRep_3sec_sorted.filt_ROI,1000,stimFrames,freq_path,samp_rate);
    %     save([dir_reduced,'tuning_passive.mat'],'TUNING','dFByTone','h_pass','p_pass');
    tones=TUNING_3sec(1).tones;
    idx_plot=sum(h_pass_3sec,2)>0;
    %        KAMIA_plotIndividualNeuronsTones_AML(dFByTone(:,idx_plot'),tones,h_pass(idx_plot,:))
    switch plotting
        case 1
            KAMIA_plotIndividualNeuronsTones_AML(dFByTone_3sec,tones,h_pass_3sec)
    end
end

%% tones 5sec
if isempty(F_byToneRep_5sec)
    sprintf('no passive tuning measured on this date');
    TUNING=[];
    dFByTone=[];
    h_pass=[];
    p_pass=[];
else
    F_byToneRep_5sec_sorted = pupCall_pipeline_sort_F_tones(F_byToneRep_5sec,3,151,plotting);
    % [F_bySession,F_byToneRep,ops]=AFC_load2p_data(dir_reduced,date);
    freq_path='/Volumes/aml717/Personal/MATLAB/pd_scripts/HALFOCTAVE.txt';%'H:\Personal\MATLAB\pd_scripts\HALFOCTAVE.txt';
    %     filtF=cell(1,numel(F_byToneRep_5sec));
    %     F_corrected=filtF;
    %     % filter data w/moving median filter
    %     for f=1:length(F_byToneRep_5sec)
    %         F_corrected{f}=F_byToneRep_5sec(f).FROI;%-0.7*F_byToneRep(f).Fneu;
    %         filtF_tmp=zeros(size(F_corrected{f}));
    %
    %         for i=1:size(F_corrected{f},1)
    %             filtF_tmp(i,:) = slidingAvg_rawF( F_corrected{f}(i,:),2,'median' );
    %         end
    %         filtF{f}=filtF_tmp;
    %
    %     end

    samp_rate=ops.fs;
    stimFrames=151:151:1500;
    [TUNING_5sec,dFByTone_5sec,h_pass_5sec,p_pass_5sec] = extract_toneTuning_pupcalls(F_byToneRep_5sec_sorted.filt_ROI,1500,stimFrames,freq_path,samp_rate);
    %     save([dir_reduced,'tuning_passive.mat'],'TUNING','dFByTone','h_pass','p_pass');
    tones=TUNING_5sec(1).tones;
    idx_plot=sum(h_pass_5sec,2)>0;
    %        KAMIA_plotIndividualNeuronsTones_AML(dFByTone(:,idx_plot'),tones,h_pass(idx_plot,:))
    switch plotting
        case 1
            KAMIA_plotIndividualNeuronsTones_AML(dFByTone_5sec,tones,h_pass_5sec)
    end
end

%% get overall spike rates during calls and tones
if ~isempty(F_calls_10sec{1})
    FR_calls_10sec=arrayfun(@(x)sum([x.spikes{:}],2)/(size([x.spikes{:}],2)/samp_rate),F_calls_sorted_10sec,'un',0);
else
    FR_calls_10sec={};
end
FR_calls_5sec=arrayfun(@(x)sum([x.spikes{:}],2)/(size([x.spikes{:}],2)/samp_rate),F_calls_sorted_5sec,'un',0);
if ~isempty(F_calls_2sec{1})
    FR_calls_2sec=arrayfun(@(x)sum([x.spikes{:}],2)/(size([x.spikes{:}],2)/samp_rate),F_calls_sorted_2sec,'un',0);
else
    FR_calls_2sec={};
end

if ~isempty(F_byToneRep_3sec )
    FR_tones_3sec=arrayfun(@(x)sum([x.spikes{:}],2)/(size([x.spikes{:}],2)/samp_rate),F_byToneRep_3sec_sorted,'un',0);
else
    FR_tones_3sec={};
end

FR_tones_5sec=arrayfun(@(x)sum([x.spikes{:}],2)/(size([x.spikes{:}],2)/samp_rate),F_byToneRep_5sec_sorted,'un',0);

%%
CvTplot=[FR_calls_10sec,FR_calls_5sec,FR_calls_2sec,FR_tones_5sec,FR_tones_3sec];
figure; hold on
if ~isempty(F_calls_2sec{1})
plotSpread(CvTplot,[],[],{'10sec,calls1','10sec,calls2','5sec,calls1','5sec,calls2','2sec,calls1','2sec,calls2','5ec,tones','3sec,tones'},4);
else
    plotSpread(CvTplot,[],[],{'10sec,calls1','10sec,calls2','5sec,calls1','5sec,calls2','5ec,tones','3sec,tones'},4);
end
ylabel('overall FR')


%  %% imaging immediately post-retrieval
% CvTplot=[FR_calls_10sec,FR_calls_5sec,FR_calls_2sec,FR_tones_5sec,FR_tones_3sec];
% figure; hold on
% 
% plotSpread(CvTplot,[],[],{'5sec,calls1','5sec,calls2','5ec,tones'},4);
% ylabel('overall FR')

%%
% % tones vs calls (3 sec tones, 5 sec calls)
% figure; hold on
% maxVal=max([FR_calls_5sec{1};FR_calls_5sec{2};FR_tones_5sec{:}]);
% 
% plot(FR_tones_5sec{:},FR_calls_5sec{1},'ko')
% tmp=gca;
% tmp.XLim=[0 maxVal];
% tmp.YLim=[0 maxVal];
% plot([0 maxVal],[0 maxVal],'k:')
% xlabel('tone blocks 3sec')
% ylabel('call block 1 5sec')
% axis square
% 
% figure; hold on
% plot(FR_calls_5sec{1},FR_calls_5sec{2},'ko')
% tmp=gca;
% tmp.XLim=[0 maxVal];
% tmp.YLim=[0 maxVal];
% plot([0 maxVal],[0 maxVal],'k:')
% xlabel('call blocks 1 5sec')
% ylabel('call block 2 5sec')
% axis square
% 
% figure; hold on
% plot(FR_tones_5sec{1},FR_calls_5sec{2},'ko')
% tmp=gca;
% tmp.XLim=[0 maxVal];
% tmp.YLim=[0 maxVal];
% plot([0 maxVal],[0 maxVal],'k:')
% xlabel('tone block 5sec')
% ylabel('call block 2 5sec')
% axis square
%%
% tones vs calls (3 sec tones, 5 sec calls)
figure; hold on
maxVal=max([FR_tones_3sec{:};FR_calls_5sec{1};FR_calls_5sec{2};FR_tones_5sec{:}]);

plot(FR_tones_3sec{:},FR_calls_5sec{1},'ko')
tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('tone blocks 3sec')
ylabel('call block 1 5sec')
axis square

figure; hold on
plot(FR_calls_5sec{1},FR_calls_5sec{2},'ko')
tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('call blocks 1 5sec')
ylabel('call block 2 5sec')
axis square

figure; hold on
plot(FR_tones_5sec{1},FR_calls_5sec{1},'ko')
tmp=gca;
tmp.XLim=[0 maxVal];
tmp.YLim=[0 maxVal];
plot([0 maxVal],[0 maxVal],'k:')
xlabel('tone block 5sec')
ylabel('call block 1 5sec')
axis square
%%
save([path_2p,'reduced_data.mat'],'dFByTrial_10sec','dFByTrial_5sec','dFByTrial_2sec',...
    'meanByTrial_early_10sec','meanByTrial_early_5sec','meanByTrial_early_2sec',...
    'P_10sec','P_5sec','P_2sec','h_10sec','h_5sec','h_2sec',...
    'responsiveTrials_10sec','responsiveTrials_5sec','responsiveTrials_2sec',...
    'FR_calls_10sec','FR_calls_5sec','FR_calls_2sec');
save([path_2p,'tone_tuning.mat'],'TUNING_5sec','dFByTone_5sec','h_pass_5sec','p_pass_5sec',...
    'TUNING_3sec','dFByTone_3sec','h_pass_3sec','p_pass_3sec','FR_tones_5sec','FR_tones_3sec');