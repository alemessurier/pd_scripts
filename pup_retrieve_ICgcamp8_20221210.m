%% pup_retrieve_ICgcamp8_20221210 
% load, extract, and plot retrieval probability and latency for RBP4 
% virgins (left auditory cortex injected with inhibitory DREADDs virus) 
% with saline vs CNO injected IP  
%% get csv paths for each mouse

cd('/Users/aml717/Documents/pup_retrieval/IC_gcamp8/')
cont=dir("*.csv");
paths_behave={cont(:).name};
paths_save={'/Users/aml717/data/reduced/IC603/',...
    '/Users/aml717/data/reduced/IC617/',...
    '/Users/aml717/data/reduced/IC622/',...
    '/Users/aml717/data/reduced/IC623/'};
%% load data

for m=1:length(paths_behave)
    T=readtable(['/Users/aml717/Documents/pup_retrieval/IC_gcamp8/',paths_behave{m}]);
    tmpstruct=table2struct(T);
    fns=fieldnames(tmpstruct);
    clear retrieve
    for fn=1:length(fns)
        retrieve.(fns{fn})=[tmpstruct(:).(fns{fn})];
    end
    save([paths_save{m},'retrieve.mat'],'retrieve')
    retrieve_all{m}=retrieve;
end

%% compile data for each mouse across days
fracRetrievedByDay=cell(length(retrieve_all),1);
dayNums=fracRetrievedByDay;
for m=1:length(retrieve_all)
    fns=fieldnames(retrieve_all{m});
    tmp=cellfun(@(x)contains(x,'retrieved'),fns);
    fns_retrieve=fns(tmp);
    dayNum=zeros(size(fns_retrieve));
    fracRetrieved=dayNum;
    for fn=1:length(fns_retrieve)
        dayNum(fn)=str2num(fns_retrieve{fn}(4));
        thisSess=retrieve_all{m}.(fns_retrieve{fn});
        fracRetrieved(fn)= nansum(thisSess)/sum(~isnan(thisSess));
    end
    fracRetrievedByDay{m}=fracRetrieved;
    dayNums{m}=dayNum
end
%% plot
figure; hold on
cmap=brewermap(4,'Set3');
for m=1:length(dayNums)
    plot(dayNums{m},fracRetrievedByDay{m},'o-','Color',cmap(m,:))
end
xlabel('days cohoused')
ylabel('fraction pups retrieved')
tmp=gca;
tmp.XTick=[0:1:4]
%% make plots
prob_retrieved_no_drug=arrayfun(@(x)nansum(x.no_drug_retrieved)/sum(~isnan(x.no_drug_retrieved)),RBPV);
meanlatency_no_drug=arrayfun(@(x)nanmean(x.no_drug_latency),RBPV);
semLatency_no_drug=arrayfun(@(x)std(x.no_drug_latency)/sqrt(nansum(x.no_drug_retrieved)),RBPV);

prob_retrieved_CNO=arrayfun(@(x)nansum(x.CNO_retrieved)/sum(~isnan(x.CNO_retrieved)),RBPV);
meanlatency_CNO=arrayfun(@(x)nanmean(x.CNO_latency),RBPV);
semLatency_CNO=arrayfun(@(x)std(x.CNO_latency)/sqrt(nansum(x.CNO_retrieved)),RBPV);

prob_retrieved_saline=arrayfun(@(x)nansum(x.saline_retrieved)/sum(~isnan(x.saline_retrieved)),RBPV);
meanlatency_saline=arrayfun(@(x)nanmean(x.saline_latency),RBPV);
semLatency_saline=arrayfun(@(x)std(x.saline_latency)/sqrt(nansum(x.saline_retrieved)),RBPV);
[~,p_frac]=ttest(prob_retrieved_saline,prob_retrieved_CNO)
[~,p_late]=ttest(meanlatency_saline,meanlatency_CNO)


figure; hold on
plot([0.5 1],[meanlatency_saline',meanlatency_CNO'],'ko-')
meanLateAll_saline=mean(meanlatency_saline);
semLateAll_saline=std(meanlatency_saline)/sqrt(length(meanlatency_saline));
meanLateAll_CNO=mean(meanlatency_CNO);
semLateAll_CNO=std(meanlatency_CNO)/sqrt(length(meanlatency_CNO));
plot([0.5 1],[meanLateAll_saline meanLateAll_CNO],'ro-','MarkerSize',10,'LineWidth',2)
e=errorbar([0.5 1],[meanLateAll_saline meanLateAll_CNO],[semLateAll_saline semLateAll_CNO],'r','LineWidth',2);
tmp=gca;
tmp.XLim=[0.25 1.25];
tmp.XTick=[0.5 1];
tmp.XTickLabel={'saline','CNO'};
tmp.XTickLabelRotation=45;
tmp.YLim=[0 60];
ylabel('time retrieved (sec)')
title(['p=',num2str(p_late)])

figure; hold on
plot([0.5 1],[prob_retrieved_saline',prob_retrieved_CNO'],'ko-')
meanProb_saline=mean(prob_retrieved_saline);
semProb_saline=std(prob_retrieved_saline)/sqrt(length(prob_retrieved_saline));
meanProb_CNO=mean(prob_retrieved_CNO);
semProb_CNO=std(prob_retrieved_CNO)/sqrt(length(prob_retrieved_CNO));
plot([0.5 1],[meanProb_saline meanProb_CNO],'ro-','MarkerSize',10,'LineWidth',2)
e=errorbar([0.5 1],[meanProb_saline meanProb_CNO],[semProb_saline semProb_CNO],'r','LineWidth',2);
tmp=gca;
tmp.XLim=[0.25 1.25];
tmp.XTick=[0.5 1];
tmp.XTickLabel={'saline','CNO'};
tmp.XTickLabelRotation=45;
tmp.YLim=[0 1];
ylabel('fraction of pups retrieved')
title(['p=',num2str(p_frac)])
