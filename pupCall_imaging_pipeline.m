function [dFByTrial,h,p]=pupCall_imaging_pipeline(path_2p,plotting)

%% load data
[F_calls,F_byToneRep,ops,inds_ex,Fcell]=load2p_data_pupcalls(path_2p);

%%
% plot raw dF/F traces of all ROIs
numFramesFilt=3;
deltaF=[];
stimFrames_all=[];
for d=1:numel(F_calls)

    allData=F_calls{d};
    fnames=arrayfun(@(x)x.name,allData,'un',0);
    repnums=cellfun(@(x)str2num(x(end-7:end-6)),fnames);
    numreps=unique(repnums);

    for r=1:length(numreps)
        fnames_thisRep=fnames(repnums==numreps(r));
        data_thisRep=allData(repnums==numreps(r));
        fOrder=cellfun(@(x)str2num(x(end-1:end)),fnames_thisRep);
        [fOrder,sortIdx]=sort(fOrder,'ascend');
        data_thisRep=data_thisRep(sortIdx);
        F_calls_sorted(d).FROI{r}=[data_thisRep(:).FROI];
        F_calls_sorted(d).Fneu{r}=[data_thisRep(:).Fneu];


        %make temporary struct for plotting
        data=F_calls_sorted(d).FROI{r};
        data_np=F_calls_sorted(d).Fneu{r};
        data_npcorr=data-0.7*data_np;
        deltaF_all=zeros(size(data));
        numCells=size(data,1);
        numFrames=size(data,2);
        stimFrames=151:151:numFrames;
        for i=1:numCells
            rawtrace=data(i,:);%_npcorr(i,:);
            filtF=slidingAvg_rawF( rawtrace,numFramesFilt,'median' );
            F_calls_sorted(d).filt_ROI{r}(i,:)=filtF;
            deltaF_all(i,:)  = deltaF_simple(filtF,0.5);
        end


        samp_rate=30;
        switch plotting
            case 1
                figure
                spacing=2;

                plot_raw_deltaF( deltaF_all,samp_rate,spacing,stimFrames )
            case 0
        end
    end
end



%% get tuning for pup calls
samp_rate=ops.fs;
Fcell_stim=F_calls_sorted(1).filt_ROI;
stimFrames=(151:151:size(Fcell_stim{1},2))+0.5*samp_rate;
stimFrames=stimFrames(1:end-2);
frames_call1=stimFrames(1:3:end);
frames_call2=stimFrames(2:3:end);
frames_call3=stimFrames(3:3:end);
[dFByTrial{1},h(1,:),p(1,:)] = extract_USV_tuning(Fcell_stim,frames_call1,samp_rate,2,5);
[dFByTrial{2},h(2,:),p(2,:)] = extract_USV_tuning(Fcell_stim,frames_call2,samp_rate,2,5);

[dFByTrial{3},h(3,:),p(3,:)] = extract_USV_tuning(Fcell_stim,frames_call3,samp_rate,2,5);


Fcell_stim=F_calls_sorted(2).filt_ROI;
    stimFrames=151:151:size(Fcell_stim{1},2);
    stimFrames=stimFrames(1:end-2);
frames_call1=stimFrames(1:3:end);
frames_call2=stimFrames(2:3:end);
frames_call3=stimFrames(3:3:end);
[dFByTrial{4},h(4,:),p(4,:)] = extract_USV_tuning(Fcell_stim,frames_call1,samp_rate,2,5);
[dFByTrial{5},h(5,:),p(5,:)] = extract_USV_tuning(Fcell_stim,frames_call2,samp_rate,2,5);

[dFByTrial{6},h(6,:),p(6,:)] = extract_USV_tuning(Fcell_stim,frames_call3,samp_rate,2,5);

if length(F_calls)==3
    Fcell_stim=F_calls(3).filt_ROI;
    stimFrames=40:40:size(Fcell_stim,2);
    %         frames_call1=stimFrames(1:3:end);
    frames_call2=stimFrames(2:3:end);
    frames_call3=stimFrames(3:3:end);
    [dFByTrial{7},h(7,:),p(7,:)] = extract_USV_tuning(Fcell_stim,frames_call1,samp_rate,2,5);
    [dFByTrial{8},h(8,:),p(8,:)] = extract_USV_tuning(Fcell_stim,frames_call2,samp_rate,2,5);

    [dFByTrial{9},h(9,:),p(9,:)] = extract_USV_tuning(Fcell_stim,frames_call3,samp_rate,2,5);
end
dFByTrial=cat(1,dFByTrial{:});

%% make structure of mean responses by ROI, early post-stim
numCells=size(dFByTrial,2);
frames_evoked_early=61:141;
meanByTrial_early=cell(size(dFByTrial));


for c=1:numCells
    meanByTrial_early(:,c)=cellfun(@(x)mean(x(:,frames_evoked_early),2),dFByTrial(:,c),'un',0);
end

meanAll=cellfun(@mean,meanByTrial_early);
figure; imagesc(meanAll')

% view all trials across cells
for c=1:numCells
    meanByTrial_allcalls_early{c}=cat(1,meanByTrial_early{:,c});
end
meanByTrial_allcalls_early=cat(2,meanByTrial_allcalls_early{:});

switch plotting
    case 1
        figure; imagesc(meanByTrial_allcalls_early);
        colormap gray
    case 0
end

%% make structure of mean responses by ROI, starting 2 sec post-stim onset
numCells=size(dFByTrial,2);
frames_evoked_late=121:180;
meanByTrial_late=cell(size(dFByTrial));


for c=1:numCells
    meanByTrial_late(:,c)=cellfun(@(x)mean(x(:,frames_evoked_late),2),dFByTrial(:,c),'un',0);
end

meanAll=cellfun(@mean,meanByTrial_late);
figure; imagesc(meanAll')

% view all trials across cells
for c=1:numCells
    meanByTrial_allcalls_late{c}=cat(1,meanByTrial_late{:,c});
end
meanByTrial_allcalls_late=cat(2,meanByTrial_allcalls_late{:});

switch plotting
    case 1
        figure; imagesc(meanByTrial_allcalls_late);
        colormap gray
    case 0
end
%%
for i=1:size(Fcell,1)
    Fcell_filt(i,:)=slidingAvg_rawF( Fcell(i,:),3,'median' );
end

[P_early,responsiveTrials_early,bootDist]=pupCall_sigTest(meanByTrial_early,Fcell_filt,dFByTrial,10000,2,frames_evoked_early,samp_rate);
h_early=P_early<=0.05;

[P_late,responsiveTrials_late,bootDist]=pupCall_sigTest(meanByTrial_late,Fcell_filt,dFByTrial,10000,2,frames_evoked_late,samp_rate);
h_late=P_late<=0.05;

h_calls=h_early | h_late;
%%

numtrials=cellfun(@(x)length(x),responsiveTrials_early(:,1));
min_trials=min(numtrials);
responsiveTrials_tmp=cellfun(@(x)x(1:min_trials),responsiveTrials_early,'un',0);
for c=1:numCells
    responsiveTrials_byCell{c}=cat(2,responsiveTrials_tmp{:,c});
    switch plotting
        case 1
            figure; imagesc(responsiveTrials_byCell{c});
        case 0
    end
end
%%
switch plotting
    case 1
        pupCalls_plotTuning(dFByTrial,h_calls,30)
end
%%
%     pupCalls_plotTuning_single(dFByTrial,h,30,4)



%% combine dF/F across calls for each cell

dFbyCell=cell(1,size(dFByTrial,2));
for i=1:length(dFbyCell)
    dFbyCell{i}=cat(1,dFByTrial{:,i});
end

[P_allCalls,responsiveTrials_allCalls,bootDist_allCalls]=pupCall_sigTest_allCalls(meanByTrial_allcalls_early,Fcell_filt,dFbyCell,10000,2,2,samp_rate);

h_cell=P_allCalls<=0.05;
for i=1:length(dFbyCell)
    thisCell=dFbyCell{i};
   
   

    switch plotting
        case 1
            figure; hold on

            subplot(2,1,1)
            timeplot=((1:size(thisCell,2))-60)/30;

            shadedErrorBar(timeplot,mean(thisCell,1), std(thisCell,[],1)./sqrt(size(thisCell,1)));
            hold on
            if h_cell(i) == 1
                COLOR = 'r:';
            else
                COLOR = 'k:';
            end
            vline(0,COLOR)
            %         vline(0,'r:');
            tmp=gca;
            tmp.Box='off';
            %         tmp.XTickLabel=[];
            tmp.XAxisLocation='origin';
            axis square

            subplot(2,1,2)
            imagesc(thisCell);
            colormap gray
            axis square
    end
end
%%

%% tones
if isempty(F_byToneRep)
    sprintf('no passive tuning measured on this date');
    TUNING=[];
    dFByTone=[];
    h_pass=[];
    p_pass=[];
else
%         F_byToneRep_5sec_sorted = pupCall_pipeline_sort_F_tones(F_byToneRep,3,151,plotting);

    % [F_bySession,F_byToneRep,ops]=AFC_load2p_data(dir_reduced,date);
    freq_path='/Volumes/aml717/Personal/MATLAB/pd_scripts/HALFOCTAVE.txt';%'H:\Personal\MATLAB\pd_scripts\HALFOCTAVE.txt';
    filtF=cell(1,numel(F_byToneRep));
    F_corrected=filtF;
    % filter data w/moving median filter
    for f=1:length(F_byToneRep)
        F_corrected{f}=F_byToneRep(f).FROI;%-0.7*F_byToneRep(f).Fneu;
        filtF_tmp=zeros(size(F_corrected{f}));

        for i=1:size(F_corrected{f},1)
            filtF_tmp(i,:) = slidingAvg_rawF( F_corrected{f}(i,:),2,'median' );
        end
        filtF{f}=filtF_tmp;

    end

    samp_rate=ops.fs;
    stimFrames=91:91:1000;
    [TUNING,dFByTone,h_pass,p_pass] = extract_toneTuning_pupcalls(filtF,1000,stimFrames,freq_path,samp_rate);
    %     save([dir_reduced,'tuning_passive.mat'],'TUNING','dFByTone','h_pass','p_pass');
    tones=TUNING(1).tones;
    idx_plot=sum(h_pass,2)>0;
    %        KAMIA_plotIndividualNeuronsTones_AML(dFByTone(:,idx_plot'),tones,h_pass(idx_plot,:))
    switch plotting
        case 1
            KAMIA_plotIndividualNeuronsTones_AML(dFByTone,tones,h_pass)
    end
end
%%
save([path_2p,'reduced_data.mat'],'dFByTrial','meanByTrial_allcalls_early','meanByTrial_allcalls_late',...
    'meanByTrial_early','meanByTrial_late','dFbyCell','P_early','P_late','P_allCalls','h_calls',...
    'responsiveTrials_early','responsiveTrials_late','responsiveTrials_byCell','responsiveTrials_allCalls');
save([path_2p,'tone_tuning.mat'],'TUNING','dFByTone','h_pass','p_pass');