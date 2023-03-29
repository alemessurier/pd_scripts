%% load data

T=readtable('/Users/aml717/Documents/pup_retrieval/RBP4V1.csv');
RBP4V1=table2struct(T);
RBPV(1).no_drug_retrieved=[RBP4V1(:).no_drug_retrieved];
RBPV(1).no_drug_latency=[RBP4V1(:).no_drug_latency];
RBPV(1).CNO_retrieved=[RBP4V1(:).CNO_retrieved];
RBPV(1).CNO_latency=[RBP4V1(:).CNO_latency];
RBPV(1).saline_retrieved=[RBP4V1(:).saline_retrieved];
RBPV(1).saline_latency=[RBP4V1(:).saline_latency];

T=readtable('/Users/aml717/Documents/pup_retrieval/RBP4V2.csv');
RBP4V2=table2struct(T);
RBPV(2).no_drug_retrieved=[RBP4V2(:).no_drug_retrieved];
RBPV(2).no_drug_latency=[RBP4V2(:).no_drug_latency];
RBPV(2).CNO_retrieved=[RBP4V2(:).CNO_retrieved];
RBPV(2).CNO_latency=[RBP4V2(:).CNO_latency];
RBPV(2).saline_retrieved=[RBP4V2(:).saline_retrieved];
RBPV(2).saline_latency=[RBP4V2(:).saline_latency];

T=readtable('/Users/aml717/Documents/pup_retrieval/RBP4V3.csv');
RBP4V3=table2struct(T);
RBPV(3).no_drug_retrieved=[RBP4V3(:).no_drug_retrieved];
RBPV(3).no_drug_latency=[RBP4V3(:).no_drug_latency];
RBPV(3).CNO_retrieved=[RBP4V3(:).CNO_retrieved];
RBPV(3).CNO_latency=[RBP4V3(:).CNO_latency];
RBPV(3).saline_retrieved=[RBP4V3(:).saline_retrieved];
RBPV(3).saline_latency=[RBP4V3(:).saline_latency];

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

[~,p_frac]=ttest(prob_retrieved_saline,prob_retrieved_CNO)
[~,p_late]=ttest(meanlatency_saline,meanlatency_CNO)
