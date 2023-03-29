function [dFByTrial,h,p]=pupCall_imaging_pipeline_galvo(path_2p,plotting)

%% load data
[F_calls,F_byToneRep,ops,inds_ex]=load2p_data_pupcalls_galvo(path_2p);

%%
% plot raw dF/F traces of all ROIs
deltaF=[];
stimFrames_all=[];
for d=1:numel(F_calls)
    data=F_calls(d).FROI;

    deltaF_all=zeros(size(data));
    numCells=size(data,1);
    numFrames=size(data,2);
    stimFrames=40:40:numFrames;
    stimFrames=stimFrames+size(deltaF,2);
    stimFrames_all=[stimFrames_all,stimFrames];
    for i=1:numCells
        rawtrace=data(i,:);
        deltaF_all(i,:)  = deltaF_simple(rawtrace,0.5);



    end
    deltaF=[deltaF,deltaF_all];
end
figure
samp_rate=3.91;
spacing=1;
stimFrames=40:40:numFrames;
plot_raw_deltaF( deltaF,samp_rate,spacing,stimFrames_all )


%% get tuning for pup calls
samp_rate=ops.fs;
Fcell=F_calls(1).FROI;
stimFrames=(40:40:size(Fcell,2))+0.5*samp_rate;
stimFrames=stimFrames(1:end-1);
frames_call1=stimFrames(1:3:end);
frames_call2=stimFrames(2:3:end);
frames_call3=stimFrames(3:3:end);
[dFByTrial{1},h(1,:),p(1,:)] = extract_USV_tuning_galvo(Fcell,frames_call1,samp_rate);
[dFByTrial{2},h(2,:),p(2,:)] = extract_USV_tuning_galvo(Fcell,frames_call2,samp_rate);

[dFByTrial{3},h(3,:),p(3,:)] = extract_USV_tuning_galvo(Fcell,frames_call3,samp_rate);


Fcell=F_calls(2).FROI;
stimFrames=40:40:size(Fcell,2);
frames_call1=stimFrames(1:3:end);
frames_call2=stimFrames(2:3:end);
frames_call3=stimFrames(3:3:end);
[dFByTrial{4},h(4,:),p(4,:)] = extract_USV_tuning_galvo(Fcell,frames_call1,samp_rate);
[dFByTrial{5},h(5,:),p(5,:)] = extract_USV_tuning_galvo(Fcell,frames_call2,samp_rate);

[dFByTrial{6},h(6,:),p(6,:)] = extract_USV_tuning_galvo(Fcell,frames_call3,samp_rate);

if length(F_calls)==3
    Fcell=F_calls(3).FROI;
    stimFrames=40:40:size(Fcell,2);
    frames_call1=stimFrames(1:3:end);
    frames_call2=stimFrames(2:3:end);
    frames_call3=stimFrames(3:3:end);
    [dFByTrial{7},h(7,:),p(7,:)] = extract_USV_tuning_galvo(Fcell,frames_call1,samp_rate);
    [dFByTrial{8},h(8,:),p(8,:)] = extract_USV_tuning_galvo(Fcell,frames_call2,samp_rate);

    [dFByTrial{9},h(9,:),p(9,:)] = extract_USV_tuning_galvo(Fcell,frames_call3,samp_rate);
end
dFByTrial=cat(1,dFByTrial{:});



%% make structure of mean responses by ROI, early post-stim
numCells=size(dFByTrial,2);
frames_evoked_early=9:17;
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
frames_evoked_late=18:25;
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
[P_early,responsiveTrials_early,bootDist]=pupCall_sigTest(meanByTrial_early,{Fcell},dFByTrial,10000,2,frames_evoked_early,4);
h_early=P_early<=0.05;

[P_late,responsiveTrials_late,bootDist]=pupCall_sigTest(meanByTrial_late,{Fcell},dFByTrial,10000,2,frames_evoked_late,4);
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
        pupCalls_plotTuning(dFByTrial,h_calls,4)
end
%%
%     pupCalls_plotTuning_single(dFByTrial,h,30,4)



%% combine dF/F across calls for each cell

dFbyCell=cell(1,size(dFByTrial,2));
for i=1:length(dFbyCell)
    dFbyCell{i}=cat(1,dFByTrial{:,i});
end

[P_allCalls,responsiveTrials_allCalls,bootDist_allCalls]=pupCall_sigTest_allCalls(meanByTrial_allcalls_early,{Fcell},dFbyCell,10000,2,2,4);

h_cell=P_allCalls<=0.05;
for i=1:length(dFbyCell)
    thisCell=dFbyCell{i};



    switch plotting
        case 1
            figure; hold on

            subplot(2,1,1)
            timeplot=((1:size(thisCell,2))-8)/4;

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
if isempty(F_byToneRep)
    sprintf('no passive tuning measured on this date');
    TUNING=[];
    dFByTone=[];
    h_pass=[];
    p_pass=[];
else
    % plot raw dF/F traces of all ROIs
    data=F_byToneRep(1).FROI;

    deltaF_all=zeros(size(data));
    numCells=size(data,1);
    numFrames=size(data,2);

    for i=1:numCells
        rawtrace=data(i,:);
        deltaF_all(i,:)  = deltaF_simple(rawtrace,0.5);
    end

    figure
    samp_rate=3.91;
    spacing=1;
    stimFrames=20:20:numFrames;
    plot_raw_deltaF( deltaF_all,samp_rate,spacing,stimFrames )

    freq_path='/Volumes/pupcalls2/retro_GCaMP_mouse3/QUARTEROCTAVE.txt';

    [TUNING,dFByTone,h_pass,p_pass,tones]=froemke2p_analysis_tones(path_2p, freq_path);
   
    switch plotting
        case 1
             pupCalls_plotTuning_tones(dFByTone,tones,h_pass)
        case 0
    end
end

%%
save([path_2p,'reduced_data.mat'],'dFByTrial','meanByTrial_allcalls_early','meanByTrial_allcalls_late',...
    'meanByTrial_early','meanByTrial_late','dFbyCell','P_early','P_late','P_allCalls','h_calls',...
    'responsiveTrials_early','responsiveTrials_late','responsiveTrials_byCell','responsiveTrials_allCalls');
save([path_2p,'tone_tuning.mat'],'TUNING','dFByTone','h_pass','p_pass');