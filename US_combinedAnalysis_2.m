

%% median response to each pressure intensity


samp_rate=30;
stimFrame=150;
posMedian_P=cell(length(press),1);
posSem_P=posMedian_P;
negMedian_P=cell(length(press),1);
negSem_P=negMedian_P;
negR_P=cell(numel(expt),length(press));
posR_P=cell(numel(expt),length(press));

% expt_names={'SST131','SST130','VIP214','VIP212'};
figure; hold on
for pr=1:length(press)
    %     figure; hold on
    lgend_idx=zeros(4,1);
    for e=1:length(expt)
        if sum(strcmp(press{pr},press_byExpt{e}))==1
            lgend_idx(e)=1;
            cellNames=fieldnames(expt(e).dF_byPressure_Z);
            posCells=expt(e).posCells;
            negCells=expt(e).negCells;
            posResponses_P=cellfun(@(x)median(expt(e).dF_byPressure_Z.(x).(press{pr})(1:450,:),2)',posCells,'un',0);
%             allResponses_P=cellfun(@(x)(x-mean(x(60:stimFrame),2))/std(x(60:stimFrame)),allResponses_P,'un',0)
            posResponses_P=cat(1,posResponses_P{:});
            posMedian_P{pr}{e}=median(posResponses_P);
            posSem_P{pr}{e}=std(posResponses_P)/sqrt(size(posResponses_P,1));
            posR_P{e,pr}=posResponses_P;
            
             negResponses_P=cellfun(@(x)median(expt(e).dF_byPressure_Z.(x).(press{pr})(1:450,:),2)',negCells,'un',0);
%             allResponses_P=cellfun(@(x)(x-mean(x(60:stimFrame),2))/std(x(60:stimFrame)),allResponses_P,'un',0)
            negResponses_P=cat(1,negResponses_P{:});
            negMedian_P{pr}{e}=median(negResponses_P);
            negSem_P{pr}{e}=std(negResponses_P)/sqrt(size(negResponses_P,1));
            negR_P{e,pr}=negResponses_P;
            
        end
    end
    posMedian_P{pr}=cat(1,posMedian_P{pr}{:});
    posSem_P{pr}=cat(1,posSem_P{pr}{:});
     negMedian_P{pr}=cat(1,negMedian_P{pr}{:});
    negSem_P{pr}=cat(1,negSem_P{pr}{:});
    time=((1:length(posMedian_P{pr}))-stimFrame)/samp_rate;
%             boundedline(time,medianResponse_P{pr},semResponse_P{pr},'cmap',cmap,'alpha')
%         m(pr)=subplot(length(press),1,pr)
    %     m(pr).ColorOrder=morgenstemning(5);
    figure;
    t(1)=subplot(1,2,1);
    t(1).ColorOrder=morgenstemning(5);
    hold on
    plot(time,posMedian_P{pr})
    title(['positively-modulated'])%,press{pr}])
    legend(expt_names(logical(lgend_idx)))
    xlabel('time from US pulse (s)')
    ylabel('zscored dF/F')
    
    t(2)=subplot(1,2,2);
    t(2).ColorOrder=morgenstemning(5);
    hold on
    plot(time,negMedian_P{pr})
    title(['negatively-modulated'])%,press{pr}])
    legend(expt_names(logical(lgend_idx)))
    xlabel('time from US pulse (s)')
    
    linkaxes(t);
end

% xlabel('time from US pulse (s)')
% ylabel('zscored dF/F')

%%
for p=1:length(press)
    posRall_P{p}=cat(1,posR_P{:,p});
    meanPosResponse_P{p}=mean(posRall_P{p});
    negRall_P{p}=cat(1,negR_P{:,p});
    meanNegResponse_P{p}=mean(negRall_P{p});
end

figure; hold on
s(1)=subplot(1,2,1); hold on
% maxY=max(cellfun(@max,mean_evoked));
% minY=min(cellfun(@min,mean_evoked));
% set(gca,'YLim',[minY-0.01 maxY+0.01])
cmap_p=brewermap(numel(meanPosResponse_P)+1,'PuRd');
cmap_p=cmap_p(2:end,:);
set(s(1),'ColorOrder',cmap_p);
% time=((1:length(meanResponse_DC{1}))-stimFrame)/samp_rate;
hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),meanPosResponse_P,'Uni',0);
% DC_labels_str=arrayfun(@(x)[num2str(x),'%'],DC_labels,'un',0);
legend(press)
% hold off
xlabel('time from US pulse (s)')
ylabel('dF/F')
title('population mean, positively-modulated')

s(2)=subplot(1,2,2); hold on
% maxY=max(cellfun(@max,mean_evoked));
% minY=min(cellfun(@min,mean_evoked));
% set(gca,'YLim',[minY-0.01 maxY+0.01])
% cmap_dc=brewermap(numel(negPosResponse_P)+1,'YlGnBu');
% cmap_dc=cmap_dc(2:end,:);
set(s(2),'ColorOrder',cmap_p);
% time=((1:length(meanResponse_DC{1}))-stimFrame)/samp_rate;
hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),meanNegResponse_P,'Uni',0);
% DC_labels_str=arrayfun(@(x)[num2str(x),'%'],DC_labels,'un',0);
legend(press)
% hold off
xlabel('time from US pulse (s)')
ylabel('dF/F')
title('population mean, negatively-modulated')

linkaxes(s)

%%
poststim=(stimFrame+6):(stimFrame+30);

for p=1:length(press)
    all=posRall_P{p};
    meanAllcellsPos=mean(all(:,poststim),2);
    meanAllPos(p)=mean(meanAllcellsPos);
    semAllPos(p)=std(meanAllcellsPos)/sqrt(length(meanAllcellsPos));
    
    all=negRall_P{p};
    meanAllcellsNeg=mean(all(:,poststim),2)
    meanAllNeg(p)=mean(meanAllcellsNeg);
    semAllNeg(p)=std(meanAllcellsNeg)/sqrt(length(meanAllcellsNeg));
    
end
% DCsPlot=[5,10:10:50];
PressPlot=[0,0.1,0.2:0.2:0.8]
figure; hold on
errorbar(PressPlot,meanAllPos,semAllPos,'k','LineWidth',1.5)
errorbar(PressPlot,meanAllNeg,semAllNeg,'r','LineWidth',1.5)
title('mean response across cells, pressure')
xlabel('pressure (MPa%)')
ylabel('z-scored dF/F')
legend('+ modulated','- modulated')
ylim([-0.4 1])
%% median response to each pressure intensity


samp_rate=30;
stimFrame=150;
posMedian_P=cell(length(DCs),1);
posSem_P=posMedian_P;
negMedian_P=cell(length(DCs),1);
negSem_P=negMedian_P;
negR_P=cell(numel(expt),length(press));
posR_P=cell(numel(expt),length(press));

expt_names={'SST131','SST130','VIP214','VIP212'};
figure; hold on
for pr=1:length(DCs)
    %     figure; hold on
    lgend_idx=zeros(4,1);
    for e=1:length(expt)
        if sum(strcmp(DCs{pr},DCs_byExpt{e}))==1
            lgend_idx(e)=1;
            cellNames=fieldnames(expt(e).dF_byDC_Z);
            posCells=expt(e).posCells;
            negCells=expt(e).negCells;
            posResponses_P=cellfun(@(x)median(expt(e).dF_byDC_Z.(x).(DCs{pr})(1:450,:),2)',posCells,'un',0);
%             allResponses_P=cellfun(@(x)(x-mean(x(60:stimFrame),2))/std(x(60:stimFrame)),allResponses_P,'un',0)
            posResponses_P=cat(1,posResponses_P{:});
            posMedian_P{pr}{e}=median(posResponses_P);
            posSem_P{pr}{e}=std(posResponses_P)/sqrt(size(posResponses_P,1));
                        posR_P{e,pr}=posResponses_P;

            
             negResponses_P=cellfun(@(x)median(expt(e).dF_byDC_Z.(x).(DCs{pr})(1:450,:),2)',negCells,'un',0);
%             allResponses_P=cellfun(@(x)(x-mean(x(60:stimFrame),2))/std(x(60:stimFrame)),allResponses_P,'un',0)
            negResponses_P=cat(1,negResponses_P{:});
            negMedian_P{pr}{e}=median(negResponses_P);
            negSem_P{pr}{e}=std(negResponses_P)/sqrt(size(negResponses_P,1));
                        negR_P{e,pr}=negResponses_P;

        end
    end
    posMedian_P{pr}=cat(1,posMedian_P{pr}{:});
    posSem_P{pr}=cat(1,posSem_P{pr}{:});
     negMedian_P{pr}=cat(1,negMedian_P{pr}{:});
    negSem_P{pr}=cat(1,negSem_P{pr}{:});
    time=((1:length(posMedian_P{pr}))-stimFrame)/samp_rate;
%             boundedline(time,medianResponse_P{pr},semResponse_P{pr},'cmap',cmap,'alpha')
%         m(pr)=subplot(length(press),1,pr)
    %     m(pr).ColorOrder=morgenstemning(5);
    figure;
    t(1)=subplot(1,2,1);
    t(1).ColorOrder=morgenstemning(5);
    hold on
    plot(time,posMedian_P{pr})
    title(['positively-modulated'])%,press{pr}])
    legend(expt_names(logical(lgend_idx)))
    xlabel('time from US pulse (s)')
    ylabel('zscored dF/F')
    
    t(2)=subplot(1,2,2);
    t(2).ColorOrder=morgenstemning(5);
    hold on
    plot(time,negMedian_P{pr})
    title(['negatively-modulated'])%,press{pr}])
    legend(expt_names(logical(lgend_idx)))
    xlabel('time from US pulse (s)')
    
    linkaxes(t);
end

%%
for p=1:length(DCs)
    posRall_P{p}=cat(1,posR_P{:,p});
    meanPosResponse_P{p}=mean(posRall_P{p});
    negRall_P{p}=cat(1,negR_P{:,p});
    meanNegResponse_P{p}=mean(negRall_P{p});
end

figure; hold on
s(1)=subplot(1,2,1); hold on
% maxY=max(cellfun(@max,mean_evoked));
% minY=min(cellfun(@min,mean_evoked));
% set(gca,'YLim',[minY-0.01 maxY+0.01])
cmap_p=brewermap(numel(meanPosResponse_P)+1,'YlGnBu');
cmap_p=cmap_p(2:end,:);
set(s(1),'ColorOrder',cmap_p);
% time=((1:length(meanResponse_DC{1}))-stimFrame)/samp_rate;
hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),meanPosResponse_P,'Uni',0);
% DC_labels_str=arrayfun(@(x)[num2str(x),'%'],DC_labels,'un',0);
legend(DCs)
% hold off
xlabel('time from US pulse (s)')
ylabel('dF/F')
title('population mean, positively-modulated')

s(2)=subplot(1,2,2); hold on
% maxY=max(cellfun(@max,mean_evoked));
% minY=min(cellfun(@min,mean_evoked));
% set(gca,'YLim',[minY-0.01 maxY+0.01])
% cmap_dc=brewermap(numel(negPosResponse_P)+1,'YlGnBu');
% cmap_dc=cmap_dc(2:end,:);
set(s(2),'ColorOrder',cmap_p);
% time=((1:length(meanResponse_DC{1}))-stimFrame)/samp_rate;
hold on
h=cellfun(@(x)plot(time,x,'LineWidth',1.5),meanNegResponse_P,'Uni',0);
% DC_labels_str=arrayfun(@(x)[num2str(x),'%'],DC_labels,'un',0);
legend(DCs)
% hold off
xlabel('time from US pulse (s)')
ylabel('dF/F')
title('population mean, negatively-modulated')

linkaxes(s)
%%
poststim=(stimFrame+6):(stimFrame+30);

for p=1:length(DCs)
    all=posRall_P{p};
    meanAllcellsPos=mean(all(:,poststim),2);
    meanAllPos(p)=mean(meanAllcellsPos);
    semAllPos(p)=std(meanAllcellsPos)/sqrt(length(meanAllcellsPos));
    
    all=negRall_P{p};
    meanAllcellsNeg=mean(all(:,poststim),2)
    meanAllNeg(p)=mean(meanAllcellsNeg);
    semAllNeg(p)=std(meanAllcellsNeg)/sqrt(length(meanAllcellsNeg));
    
end
DCsPlot=[5,10:10:50];    
figure; hold on
errorbar(DCsPlot,meanAllPos,semAllPos,'k','LineWidth',1.5)
errorbar(DCsPlot,meanAllNeg,semAllNeg,'r','LineWidth',1.5)
title('mean response across cells, DC')
xlabel('duty cycle (%)')
ylabel('z-scored dF/F')
legend('+ modulated','- modulated')
