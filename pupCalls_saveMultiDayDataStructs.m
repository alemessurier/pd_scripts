
%% for each imaging field, generate and save out allDates,MultiDayROIs

pupCalls_gcamp8_paths;

for a=1:length(paths_2p)
    [allDates_calls_10sec,allDates_calls_5sec,allDates_calls_2sec,allDates_tones_5sec,allDates_tones_3sec,...
        MultiDayROIs_calls_2sec,MultiDayROIs_calls_5sec,MultiDayROIs_calls_10sec,MultiDayROIs_tones_3sec]= pupCall_multidayROIs_multiISI(matchFilePath{a},paths_2p{a})

    % find name of directory to save to
    tmpidx=regexp(matchFilePath{a},'/');
    path2save=matchFilePath{a}(1:tmpidx(end));
        save([path2save,'MultiDayROIs.mat'],'allDates_calls_10sec','allDates_calls_5sec','allDates_calls_2sec','allDates_tones_5sec','allDates_tones_3sec',...
        'MultiDayROIs_calls_2sec','MultiDayROIs_calls_5sec','MultiDayROIs_calls_10sec','MultiDayROIs_tones_3sec')
    
    

end
%%

pupCalls_gcamp8_paths;

for a=1:length(paths_2p)

    % find name of directory to load
    tmpidx=regexp(matchFilePath{a},'/');
    path2save=matchFilePath{a}(1:tmpidx(end));
    load([path2save,'MultiDayROIs.mat'],'allDates_calls_5sec')
    allDates_calls=allDates_calls_5sec;
    numDays=length(allDates_calls);
    dFallTrials=cell(numDays,1);
    trialIdx=dFallTrials;
    dFByTrial_calls=dFallTrials;

    for d=1:numDays

        %make index of which call each trial
        dFByTrial=allDates_calls(d).dFByTrial;
        numTrials=cellfun(@(x)size(x,1),dFByTrial(:,1));
        tmpTrialIdx=[];
        for t=1:length(numTrials) % each call
            tmp=repmat(t,numTrials(t),1);
            tmpTrialIdx=[tmpTrialIdx;tmp];
        end
        trialIdx{d}=tmpTrialIdx;
        
        % make numTrials x numSamples x numCells array of trial-by-trial
        % responses to save out as data to load into jupyter notebooks

        numCells=size(dFByTrial,2);
        dF_cells=cell(numCells,1);
        for c=1:numCells
            dF_cells{c}=cat(1,dFByTrial{:,c});
        end

        dFallTrials{d}=cat(3,dF_cells{:});

        %for each call, make numTrials x numsamples x numCells array of
        %trial-by-trial responses
        dFByTrial_calls_tmp=cell(1,size(dFByTrial,1))
        for call=1:size(dFByTrial,1)
            dFByTrial_calls_tmp{call}=cat(3,dFByTrial{call,:});
        end

        dFByTrial_calls{d}=dFByTrial_calls_tmp;


    end

    save([path2save,'dFbyTrial_all.mat'],'dFallTrials',"trialIdx",'dFByTrial_calls')
end
