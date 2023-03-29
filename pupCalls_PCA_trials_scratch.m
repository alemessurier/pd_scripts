%% 
pupCalls_gcamp8_paths
matchFilePath=matchFilePath{3}
paths_2p=paths_2p{3};
%% load data

[allDates_calls_10sec,allDates_calls_5sec,allDates_calls_2sec,allDates_tones_5sec,allDates_tones_3sec,...
    MultiDayROIs_calls_2sec,MultiDayROIs_calls_5sec,MultiDayROIs_calls_10sec,MultiDayROIs_tones_3sec]= pupCall_multidayROIs_multiISI(matchFilePath,paths_2p)

    numROIs=length(MultiDayROIs_calls_5sec);
     numDays=size(MultiDayROIs_calls_5sec(1).meanR,2);
%     ROI_ID=repmat(1:numROIs,numDays,1);
%     ROI_ID=ROI_IDtmp(:);


%% concatenate trial-by-trial responses across cells
allROItrials=arrayfun(@(x)x.meanByTrial',MultiDayROIs_calls_5sec,'UniformOutput',0);
allROItrials=cat(2,allROItrials{:});

allROItrialsTone=arrayfun(@(x)x.meanByTrial',MultiDayROIs_tones_3sec,'UniformOutput',0);
allROItrialsTone=cat(2,allROItrialsTone{:});

%loop through all ROIs, replacing empty cells (for empty days) with 6x1
%empty cells

for d=1:numDays
    
    % find ROIs that weren't active on this day and thus have empty trials
    emptyIdx=(cellfun(@(x)isempty(x),allROItrials(d,:)));
    isEmptyIdx=find(emptyIdx);
    notEmptyIdx=find(~emptyIdx);
    
    % find number of trials for each call, make array of nans to replace
    % empty cells
    numTrials=cellfun(@length,allROItrials{d,notEmptyIdx(1)});
    nanTrials=nan(sum(numTrials),1);
    
    numTrialsTones=cellfun(@length,allROItrialsTone{d,notEmptyIdx(1)});
    nanTones=nan(sum(numTrialsTones),1);
    
    for i=isEmptyIdx
        allROItrials{d,i}=nanTrials;
         allROItrialsTone{d,i}=nanTones;
    end

    % concatenate all trials into one array for each ROI active on this day
    for r=notEmptyIdx
        allROItrials{d,r}=cat(1,allROItrials{d,r}{:});
        allROItrialsTone{d,r}=cat(1,allROItrialsTone{d,r}{:});
    end
    
    for r=1:numROIs
    allTrialsCat{d,r}=[allROItrials{d,r}; allROItrialsTone{d,r}];
    end

    % for this day, make index of which call was played on each trial
    tmpTrialIdx=[];
    for t=1:length(numTrials) % each call
        tmp=repmat(t,numTrials(t),1);
        tmpTrialIdx=[tmpTrialIdx;tmp];
    end
    
        for t=1:length(numTrialsTones) % each tone
        tmp=repmat(t+length(numTrials),numTrialsTones(t),1);
        tmpTrialIdx=[tmpTrialIdx;tmp];
    end

    
    trialIdx{d}=tmpTrialIdx;

    % make index of which day for each trial
    dayIdx{d}=repmat(d,length(tmpTrialIdx),1);

    % make index of calls (1) or tone (2)
    callVtoneIdx{d}=[repmat(1,sum(numTrials),1); repmat(2,sum(numTrialsTones),1)];
end


% cat arrays
for r=1:numROIs
    allTrials{r}=cat(1,allTrialsCat{:,r});
end
allTrials=cat(2,allTrials{:});
trialIdx=cat(1,trialIdx{:});
dayIdx=cat(1,dayIdx{:});
callVtoneIdx=cat(1,callVtoneIdx{:});
%% make array of trials for cells present every day
nans=sum(isnan(allTrials));
allDayROI_idx=nans==0;
allTrials_trackedROIs=allTrials(:,allDayROI_idx);
%%

[PCs, SCORE, LATENT, TSQUARED, explained,mu] = pca(allTrials_trackedROIs);
figure; plot(cumsum(explained));
figure; imagesc(PCs')
colormap gray
cmap=brewermap(6,'Set2');
figure; hold on
for i=1:6
    figure; hold on
    plot(PCs(:,i))%,'color',cmap(i,:))
    title(['PC ',num2str(i)])
end

%% plot distributions of weights of each PCA by day

cmap=brewermap(numDays,'Set3');
for p=1:length(explained)
    figure; hold on
    for f=1:numDays
        idx=dayIdx==f;
    pl(f)=cdfplot(SCORE(idx,p));
    pl(f).Color=cmap(f,:);
    end
    title(['PC',num2str(p)])
    legend
end

%% plot distributions of weights of each PCA by call

cmap=brewermap(6,'Set3');
for p=1:length(explained)
    figure; hold on
    for f=1:6
        idx=trialIdx==f;
    pl(f)=cdfplot(SCORE(idx,p));
    pl(f).Color=cmap(f,:);
    end
    title(['PC',num2str(p)])
    legend
end

%% 

for d=1:numDays
    weightsDay=SCORE(dayIdx==d,:);
    figure; imagesc(weightsDay)
    colormap gray
    title(['day ',num2str(d)])
end

%% 

for d=1:6
    weightsCall=SCORE(trialIdx==d,:);
    figure; imagesc(weightsCall)
    colormap gray
    title(['call ',num2str(d)])
end

%% LDA classifier - single
classIdx=dayIdx;
rng('default') % For reproducibility
cv = cvpartition(classIdx,'holdOut');
trainInds = training(cv);
sampleInds = test(cv);
trainingData = allTrials_trackedROIs(trainInds,:);
sampleData = allTrials_trackedROIs(sampleInds,:);
[class,err,posterior,logp,coeff]= classify(sampleData,trainingData,classIdx(trainInds),'mahalanobis');
cm = confusionchart(classIdx(sampleInds),class);

%%
[class,err,coeff]=LDA_population(allTrials_trackedROIs,trialIdx,'Mahalanobis')
[class,err,coeff]=LDA_population(allTrials_trackedROIs,dayIdx,'Mahalanobis')

%% classify based on PCs
groupIdx=callVtoneIdx;
for PC=1:size(PCs,2)
    data=SCORE(:,1:PC);
    figure;
    [class{PC},err,coeff]=LDA_population(data,groupIdx,'linear');
    err(PC)=1-sum(class{PC}'==groupIdx)/length(groupIdx);
    title([num2str(PC),' PCs, err=',num2str(err(PC))]);
end

%%
clear err
clear class
for d=1:numDays
groupIdx=callVtoneIdx(dayIdx==d);
    data=allTrials(dayIdx==d,:);
    nanidx=sum(isnan(data),1)>0;
    data=data(:,~nanidx);
    figure;
    [class{d},err,coeff]=LDA_population(data,groupIdx,'linear');
    err(d)=1-sum(class{d}'==groupIdx)/length(groupIdx);
    title(['day ',num2str(d), ', err=',num2str(err(d))]);
end

