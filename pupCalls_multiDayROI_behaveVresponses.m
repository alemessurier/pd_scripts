%% load in multi-day ROI data
pupCalls_gcamp8_paths

%% make multi-day ROI data structures

for a=1:length(paths_2p)
    [allDates_calls_10sec{a},allDates_calls_5sec{a},allDates_calls_2sec{a},...
    allDates_tones_5sec{a},allDates_tones_3sec{a},MultiDayROIs_calls_2sec{a},...
    MultiDayROIs_calls_5sec{a},MultiDayROIs_calls_10sec{a},...
    MultiDayROIs_tones_3sec{a},meanDF_best_2sec_all{a},...
    meanDF_best_5sec_all{a},meanDF_best_10sec_all{a},...
        meanDF_best_tones_all{a},ROIidx_days{a},dayIdx{a}]= pupCalls_loadMultiDayROIs_allMice(paths_2p{a},matchFilePath{a});
end

%% for each mouse, get percent responsive to calls by day
for a=1:length(behaviorPath)
retrieve_all{a}=load(behaviorPath{a});
end

%% compile data for each mouse across days
fracRetrievedByDay=cell(length(behaviorPath),1);
dayNums=fracRetrievedByDay;
for m=1:length(behaviorPath)
    load(behaviorPath{m});
    fns=fieldnames(retrieve);
    tmp=cellfun(@(x)contains(x,'retrieved'),fns);
    fns_retrieve=fns(tmp);
    dayNum=zeros(size(fns_retrieve));
    fracRetrieved=dayNum;
    for fn=1:length(fns_retrieve)
        dayNum(fn)=str2num(fns_retrieve{fn}(4));
        thisSess=retrieve.(fns_retrieve{fn});
        fracRetrieved(fn)= nansum(thisSess)/sum(~isnan(thisSess));
    end
    fracRetrievedByDay{m}=fracRetrieved;
    dayNums{m}=dayNum
end

%% get percent responsive by day
fracResponsiveByDay=cell(length(behaviorPath),1);
for a=1:length(behaviorPath)
    numDays=length(allDates_calls_5sec{a});
    fracResponsive=zeros(numDays,1);
    for d=1:numDays
        h_calls=allDates_calls_5sec{a}(d).h_calls;
        responsive=sum(h_calls,2)>0;
        fracResponsive(d)=sum(responsive)/length(responsive);
    end
    fracResponsiveByDay{a}=fracResponsive;
end
%%
dayNums{4}=[2;3];
fracRetrievedByDay{4}=fracRetrievedByDay{4}(3:4)

dayNums{6}=[1;2;3];
fracRetrievedByDay{6}=fracRetrievedByDay{6}(2:4)

%%

fracRetrievedAll=cat(1,fracRetrievedByDay{:});
fracResponsiveAll=cat(1,fracResponsiveByDay{:});

figure; hold on
plot(fracRetrievedAll,fracResponsiveAll,'ko')

%%
cmap=flipud(brewermap(5,'Set2'));
figure; hold on
for a=[1:3,5]
    plot(dayNums{a},100*fracResponsiveByDay{a},'o-','Color',cmap(a,:));
end
xlabel('days co-housed')
ylabel('% call-responsive neurons')
tmp=gca;
tmp.XTick=0:1:4;

figure; hold on
for a=[1:3,5]
    plot(dayNums{a},100*fracRetrievedByDay{a},'o-','Color',cmap(a,:));
end
xlabel('days co-housed')
ylabel('% pups retrieved')
tmp=gca;
tmp.XTick=0:1:4;