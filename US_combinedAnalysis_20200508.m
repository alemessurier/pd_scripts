%% load in data for each mouse


SST131=load('F:\US\SST131\reduced\20200328\suite2p\plane0\analysis_06-May-2020.mat');
SST130=load('F:\US\SST130\reduced\suite2p\plane0\analysis_06-May-2020.mat');
VIP214=load('F:\US\VIP214\reduced\suite2p\plane0\analysis_07-May-2020.mat');
VIP212=load('F:\US\VIP212\reduced\suite2p\plane0\analysis_06-May-2020.mat');

%%
expt(1)=load('F:\US\SST131\reduced\20200328\suite2p\plane0\analysis_14-May-2020.mat');
expt(2)=load('F:\US\SST130\reduced\suite2p\plane0\analysis_14-May-2020.mat');
expt(3)=load('F:\US\VIP214\reduced\suite2p\plane0\analysis_14-May-2020.mat');
expt(4)=load('F:\US\VIP212\reduced\suite2p\plane0\analysis_14-May-2020.mat');
expt(5)=load('H:\s2p_fastdisk\SST130\deafened\reduced\suite2p\plane0\analysis_01-Jun-2020.mat')
DCs_byExpt=arrayfun(@(x)fieldnames(x.dF_byDC_Z.cell1),expt,'un',0);
DCs=cat(1,DCs_byExpt{:});
DCs=unique(DCs);
DCs={'DC5';'DC10'; 'DC20'; 'DC30'; 'DC40'; 'DC50'}

press_byExpt=arrayfun(@(x)fieldnames(x.dF_byPressure_Z.cell1),expt,'un',0);
press=cat(1,press_byExpt{:});
press=unique(press);


%%
e=5
stimFrame=150;
poststim=(stimFrame+6):(stimFrame+30);
US_summaryPlots(expt(e).dF_byDC_Z,expt(e).stimFrame,expt(e).dF_byPressure_Z,fieldnames(expt(e).dF_byDC),expt(e).DC_labels,expt(e).pressure_labels,expt(e).ops,poststim)
%%
e=5
US_plotScaledHeathmap(expt(e).dF_byDC_Z,expt(e).stimFrame,expt(e).dF_byPressure_Z,fieldnames(expt(e).dF_byDC),poststim,-2.5,2.5,-5,10)
e=2
US_plotScaledHeathmap(expt(e).dF_byDC_Z,expt(e).stimFrame,expt(e).dF_byPressure_Z,fieldnames(expt(e).dF_byDC),poststim,-2.5,2.5,-5,10)

%% median response to each duty cycle, comparing sst vs all


samp_rate=30;
stimFrame=150;
medianResponse_DC=cell(length(DCs),1);
semResponse_DC=medianResponse_DC;
expt_names={'SST131','SST130','VIP214','VIP212'};
figure; hold on
for dc=1:length(DCs)
    %     figure; hold on
    lgend_idx=zeros(4,1);
    for e=1:length(expt)
        if sum(strcmp(DCs{dc},DCs_byExpt{e}))==1
            lgend_idx(e)=1;
            cellNames=fieldnames(expt(e).dF_byDC_Z);
            allResponses_DC=cellfun(@(x)median(expt(e).dF_byDC_Z.(x).(DCs{dc})(1:450,:),2)',cellNames,'un',0);
%             allResponses_DC=cellfun(@(x)(x-mean(x(60:stimFrame),2))/std(x(60:stimFrame)),allResponses_DC,'un',0)
            allResponses_DC=cat(1,allResponses_DC{:});
            medianResponse_DC{dc}{e}=median(allResponses_DC);
            semResponse_DC{dc}{e}=std(allResponses_DC)/sqrt(size(allResponses_DC,1));
        end
    end
    medianResponse_DC{dc}=cat(1,medianResponse_DC{dc}{:});
    semResponse_DC{dc}=cat(1,semResponse_DC{dc}{:});
    time=((1:length(medianResponse_DC{dc}))-stimFrame)/samp_rate;
    %         boundedline(time,medianResponse_DC{dc},semResponse_DC{dc},'cmap',cmap,'alpha')
%         m(dc)=subplot(length(DCs),1,dc)
%         m(dc).ColorOrder=morgenstemning(5);
    figure;
    t=gca;
    t.ColorOrder=morgenstemning(5);
    hold on
    plot(time,medianResponse_DC{dc})
    title(DCs{dc})
    legend(expt_names(logical(lgend_idx)))
    xlabel('time from US pulse (s)')
    ylabel('zscored dF/F')
    
end

xlabel('time from US pulse (s)')
ylabel('zscored dF/F')
linkaxes(m,'x')

%% median response to each pressure intensity


samp_rate=30;
stimFrame=150;
medianResponse_P=cell(length(DCs),1);
semResponse_P=medianResponse_P;
expt_names={'SST131','SST130','VIP214','VIP212'};
figure; hold on
for pr=1:length(press)
    %     figure; hold on
    lgend_idx=zeros(4,1);
    for e=1:length(expt)
        if sum(strcmp(press{pr},press_byExpt{e}))==1
            lgend_idx(e)=1;
            cellNames=fieldnames(expt(e).dF_byDC_Z);
            allResponses_P=cellfun(@(x)median(expt(e).dF_byPressure_Z.(x).(press{pr})(1:450,:),2)',cellNames,'un',0);
%             allResponses_P=cellfun(@(x)(x-mean(x(60:stimFrame),2))/std(x(60:stimFrame)),allResponses_P,'un',0)
            allResponses_P=cat(1,allResponses_P{:});
            medianResponse_P{pr}{e}=median(allResponses_P);
            semResponse_P{pr}{e}=std(allResponses_P)/sqrt(size(allResponses_P,1));
        end
    end
    medianResponse_P{pr}=cat(1,medianResponse_P{pr}{:});
    semResponse_P{pr}=cat(1,semResponse_P{pr}{:});
    time=((1:length(medianResponse_P{pr}))-stimFrame);%/samp_rate;
%             boundedline(time,medianResponse_P{pr},semResponse_P{pr},'cmap',cmap,'alpha')
%         m(pr)=subplot(length(press),1,pr)
    %     m(pr).ColorOrder=morgenstemning(5);
    figure;
    t=gca;
    t.ColorOrder=morgenstemning(5);
    hold on
    plot(time,medianResponse_P{pr})
    title(press{pr})
    legend(expt_names(logical(lgend_idx)))
    xlabel('time from US pulse (s)')
    ylabel('zscored dF/F')
    
end

xlabel('time from US pulse (s)')
ylabel('zscored dF/F')
% linkaxes(m,'x')
%% plot modulation curves by ROI for each expt
poststim=(stimFrame+5):(stimFrame+15)
for e=1:length(expt)
    cellNames=fieldnames(expt(e).dF_byDC_Z);
    DCsweep = make_DCsweep( expt(e).dF_byDC_Z,cellNames,poststim );
    allCellCurves=DCsweep.medianByCell;
    %zscore
    meanByCell=mean(allCellCurves,2);
    stdByCell=std(allCellCurves,[],2);
    tmp=bsxfun(@minus,allCellCurves,meanByCell);
    allCellsZ=bsxfun(@rdivide,tmp,stdByCell);
    [~,maxDC]=max(allCellsZ,[],2)
    for i=1:size(allCellsZ,2)
        maxThisDC=allCellsZ(maxDC==i,:);
        figure; plot(maxThisDC','k-','LineWidth',0.25)
        hold on;
        means=mean(maxThisDC,1);
        sem=std(maxThisDC,[],1)/sqrt(size(maxThisDC,1));
        errorbar(means,sem,'r','Linewidth',1.5)
        title(DCs_byExpt{e}{i})
        tmp=gca;
        tmp.XTickLabels=DCs_byExpt{e};
    end
end

%% plot modulation curves by ROI for each expt, multiple
poststim=(stimFrame+5):(stimFrame+15)
for e=1:length(expt)
    cellNames=fieldnames(expt(e).dF_byPressure_Z);
    pressSweep = make_DCsweep( expt(e).dF_byPressure_Z,cellNames,poststim );
    allCellCurves=pressSweep.medianByCell;
    %zscore
    meanByCell=mean(allCellCurves,2);
    stdByCell=std(allCellCurves,[],2);
    tmp=bsxfun(@minus,allCellCurves,meanByCell);
    %     allCellsZ=bsxfun(@rdivide,tmp,stdByCell);
    allCellsZ=allCellCurves;
    [~,maxDC]=max(allCellsZ,[],2)
    for i=1:size(allCellsZ,2)
        maxThisDC=allCellsZ(maxDC==i,:);
        figure; plot(maxThisDC','k-','LineWidth',0.25)
        hold on;
        means=mean(maxThisDC,1);
        sem=std(maxThisDC,[],1)/sqrt(size(maxThisDC,1));
        errorbar(means,sem,'r','Linewidth',1.5)
        title(press_byExpt{e}{i})
        tmp=gca;
        tmp.XTick=1:size(allCellsZ,2);
        tmp.XTickLabels=press_byExpt{e};
    end
end

%%
postStim=cell(3,1);
postStim{1}=(stimFrame+5):(stimFrame+30);
postStim{2}=(stimFrame+31):(stimFrame+60);
postStim{3}=(stimFrame+61):(stimFrame+150);

mods_press_mean=cell(3,3);
mods_press_sem=cell(3,3);
mods_press_int=cell(3,1);
mods_DC_mean=cell(3,3);
mods_DC_sem=cell(3,3);
mods_DC_int=cell(3,1);

neg_press_mean=cell(3,3);
neg_press_sem=cell(3,3);
neg_press_int=cell(3,1);
neg_DC_mean=cell(3,3);
neg_DC_sem=cell(3,3);
neg_DC_int=cell(3,1);


for e=1:3
    cellNames=fieldnames(expt(e).dF_byDC_Z);
    pr=figure; hold on
    dc=figure; hold on
    mods_press_int{e}=expt(e).pressure_labels;
    mods_DC_int{e}=expt(e).DC_labels;
    for ps=1:2
        [pvals_pos,pvals_neg ] = find_USmodulation_Pmeans( expt(e).dF_byDC_Z,expt(e).dF_byPressure_Z,stimFrame,60,postStim{ps} );
        idx_pos=zeros(length(cellNames),1);
        idx_neg=idx_pos;
        alpha=0.05/length(pvals_pos.(cellNames{1}));
        for c=1:length(cellNames)
            idx_pos(c)=sum(pvals_pos.(cellNames{c})<alpha)>0;
            idx_neg(c)=sum(pvals_neg.(cellNames{c})<alpha)>0;
        end
        idx_pos=logical(idx_pos);
        idx_neg=logical(idx_neg);
        posCells=cellNames(idx_pos);
        negCells=cellNames(idx_neg);
        BDcells=cellNames(idx_neg & idx_pos);
        
        %positive responders
        pressSweep=make_DCsweep(expt(e).dF_byPressure_Z,posCells,postStim{ps});
        mods_press_mean{e,ps}=pressSweep.meanAll;
        mods_press_sem{e,ps}=pressSweep.semAll;
        
        %negative responders
        pressSweep=make_DCsweep(expt(e).dF_byPressure_Z,negCells,postStim{ps});
        neg_press_mean{e,ps}=pressSweep.meanAll;
        neg_press_sem{e,ps}=pressSweep.semAll;
%         allCellCurves=pressSweep.medianByCell;
         %zscore
%     meanByCell=mean(allCellCurves,2);
%     stdByCell=std(allCellCurves,[],2);
%     tmp=bsxfun(@minus,allCellCurves,meanByCell);
%         allCellsZ=bsxfun(@rdivide,tmp,stdByCell);

%       means=mean(allCellCurves,1);
%         sem=std(allCellsZ,[],1)/sqrt(size(allCellsZ,1));
%         mods_press_mean{e,ps}=means;
%         mods_press_sem{e,ps}=sem;
        figure(pr);
        prs(ps)=subplot(2,1,ps);
%         plot(allCellCurves','k-','LineWidth',0.25)
        hold on;
        
        errorbar(mods_press_mean{e,ps},mods_press_sem{e,ps},'k','Linewidth',1.5)
        errorbar(neg_press_mean{e,ps},neg_press_sem{e,ps},'r','Linewidth',1.5)
% errorbar(means,sem,'r','Linewidth',1.5)
        
        title([expt_names{e},', posttim period ',num2str(ps)]);
        
        prs(ps).XTick=1:size(allCellCurves,2);
        prs(ps).XTickLabels=mods_press_int{e};
        ylim([-1 1.5])
        ylabel('Z-scored dF/F')
        xlabel('pressure intensity (MPa)')
        %positive responders
        DCsweep=make_DCsweep(expt(e).dF_byDC_Z,posCells,postStim{ps});
        mods_DC_mean{e,ps}=DCsweep.meanAll;
        mods_DC_sem{e,ps}=DCsweep.semAll;
        
        %negative responders
        DCsweep=make_DCsweep(expt(e).dF_byDC_Z,negCells,postStim{ps});
        neg_DC_mean{e,ps}=DCsweep.meanAll;
        neg_DC_sem{e,ps}=DCsweep.semAll;
%         allCellCurves=DCsweep.medianByCell;
%         meanByCell=mean(allCellCurves,2);
%     stdByCell=std(allCellCurves,[],2);
%     tmp=bsxfun(@minus,allCellCurves,meanByCell);
%         allCellsZ=bsxfun(@rdivide,tmp,stdByCell);
% 
%       means=mean(allCellsZ,1);
%         sem=std(allCellsZ,[],1)/sqrt(size(allCellsZ,1));
%         mods_DC_mean{e,ps}=means;
%         mods_DC_sem{e,ps}=sem;
         figure(dc);
        dcs(ps)=subplot(2,1,ps);
%         plot(allCellCurves','k-','LineWidth',0.25)
        hold on;
        errorbar(mods_DC_mean{e,ps},mods_DC_sem{e,ps},'k','Linewidth',1.5)
        errorbar(neg_DC_mean{e,ps},neg_DC_sem{e,ps},'r','Linewidth',1.5)
        ylim([-1 1.5])
%         plot(allCellsZ','k-','LineWidth',0.25)
%         hold on;
%         errorbar(mods_press_mean{e,ps},mods_press_sem{e,ps},'r','Linewidth',1.5)
% errorbar(means,sem,'r','Linewidth',1.5)
       
        title([expt_names{e},', posttim period ',num2str(ps)]);
%         tmp=gca;
        dcs(ps).XTick=1:size(allCellCurves,2);
        dcs(ps).XTickLabels=mods_DC_int{e};
        xlabel('duty cycle (%)')
        ylabel('Z-scored dF/F')
    end
    linkaxes(prs)
    linkaxes(dcs)
end
% for e=1:length(expt)

%%
pr=figure;
for ps=1:2
    figure(pr); s(ps)= subplot(1,2,ps)
    hold on
    errorbar(mods_press_int{1},mods_press_mean{1,ps},mods_press_sem{1,ps},'k','LineWidth',1.5)
    errorbar(mods_press_int{2},mods_press_mean{2,ps},mods_press_sem{2,ps},'r','LineWidth',1.5)
    errorbar(mods_press_int{3},mods_press_mean{3,ps},mods_press_sem{3,ps},'b','LineWidth',1.5)
    ylim([-1.5 1.5])
    xlim([-0.2 1])
    xlabel('pressure intensity (MPa)')
    ylabel('Z-scored dF/F')
    legend(expt_names(1:3))
%     boundedline(mods_press_int{1},mods_press_mean{1,ps},mods_press_sem{1,ps},'k','alpha')
%     boundedline(mods_press_int{2},mods_press_mean{2,ps},mods_press_sem{2,ps},'r','alpha')
%     boundedline(mods_press_int{3},mods_press_mean{3,ps},mods_press_sem{3,ps},'b','alpha')
end
linkaxes(s)

%%
dc=figure;
for ps=1:2
    figure(dc); s(ps)=subplot(1,2,ps)
    hold on
     errorbar(mods_DC_int{1},mods_DC_mean{1,ps},mods_DC_sem{1,ps},'k','LineWidth',1.5)
    errorbar(mods_DC_int{2},mods_DC_mean{2,ps},mods_DC_sem{2,ps},'r','LineWidth',1.5)
    errorbar(mods_DC_int{3},mods_DC_mean{3,ps},mods_DC_sem{3,ps},'b','LineWidth',1.5)
     xlabel('duty cycle (%)')
    ylabel('Z-scored dF/F')
    legend(expt_names(1:3))
    ylim([-1.5 1.5])
    xlim([0 60])
    
%     boundedline(mods_DC_int{1},mods_DC_mean{1,ps},mods_DC_sem{1,ps},'k','alpha')
%     boundedline(mods_DC_int{2},mods_DC_mean{2,ps},mods_DC_sem{2,ps},'r','alpha')
%     boundedline(mods_DC_int{3},mods_DC_mean{3,ps},mods_DC_sem{3,ps},'b','alpha')
end
linkaxes(s)
%%
pr=figure;
for ps=1:2
    figure(pr); s(ps)=subplot(1,2,ps);
    hold on
    errorbar(mods_press_int{1},neg_press_mean{1,ps},neg_press_sem{1,ps},'k','LineWidth',1.5)
    errorbar(mods_press_int{2},neg_press_mean{2,ps},neg_press_sem{2,ps},'r','LineWidth',1.5)
    errorbar(mods_press_int{3},neg_press_mean{3,ps},neg_press_sem{3,ps},'b','LineWidth',1.5)
      xlabel('pressure intensity (MPa)')
    ylabel('Z-scored dF/F')
    legend(expt_names(1:3))
    ylim([-1.5 1.5])
    xlim([-0.2 1])
%     boundedline(mods_press_int{1},mods_press_mean{1,ps},mods_press_sem{1,ps},'k','alpha')
%     boundedline(mods_press_int{2},mods_press_mean{2,ps},mods_press_sem{2,ps},'r','alpha')
%     boundedline(mods_press_int{3},mods_press_mean{3,ps},mods_press_sem{3,ps},'b','alpha')
end
linkaxes(s);
%%
dc=figure;
for ps=1:2
    figure(dc); s(ps)=subplot(1,2,ps);
    hold on
     errorbar(mods_DC_int{1},neg_DC_mean{1,ps},neg_DC_sem{1,ps},'k','LineWidth',1.5)
    errorbar(mods_DC_int{2},neg_DC_mean{2,ps},neg_DC_sem{2,ps},'r','LineWidth',1.5)
    errorbar(mods_DC_int{3},neg_DC_mean{3,ps},neg_DC_sem{3,ps},'b','LineWidth',1.5)
    xlabel('duty cycle (%)')
    ylabel('Z-scored dF/F')
    legend(expt_names(1:3))
     ylim([-1.5 1.5])
    xlim([0 60])
%     boundedline(mods_DC_int{1},mods_DC_mean{1,ps},mods_DC_sem{1,ps},'k','alpha')
%     boundedline(mods_DC_int{2},mods_DC_mean{2,ps},mods_DC_sem{2,ps},'r','alpha')
%     boundedline(mods_DC_int{3},mods_DC_mean{3,ps},mods_DC_sem{3,ps},'b','alpha')
end
linkaxes(s);

% %% 
% figure;
% for ps=1:2
%     subplot(2,2,

%% VIP modulation curves

cells_press_mean=cell(4,1);
cells_press_sem=cell(4,1);
cells_press_int=cell(4,1);

cells_DC_mean=cell(4,1);
cells_DC_sem=cell(4,1);
cells_DC_int=cell(4,1);

red_press_mean=cell(4,1);
red_press_sem=cell(4,1);
red_press_int=cell(4,1);

red_DC_mean=cell(4,1);
red_DC_sem=cell(4,1);
red_DC_int=cell(4,1);

for e=1:4
   
    cells_press_int{e}=expt(e).pressure_labels;
    cells_DC_int{e}=expt(e).DC_labels;
   
        
        % unlabeled cells
        pressSweep=make_DCsweep(expt(e).dF_byPressure_Z,expt(e).cells_noLabel,postStim{1});
        cells_press_mean{e}=pressSweep.meanAll;
        cells_press_sem{e}=pressSweep.semAll;
        
        %vip cells
        pressSweep=make_DCsweep(expt(e).dF_byPressure_Z,expt(e).cellsRed,postStim{1});
        red_press_mean{e}=pressSweep.meanAll;
        red_press_sem{e}=pressSweep.semAll;
%         allCellCurves=pressSweep.medianByCell;
         %zscore
%     meanByCell=mean(allCellCurves,2);
%     stdByCell=std(allCellCurves,[],2);
%     tmp=bsxfun(@minus,allCellCurves,meanByCell);
%         allCellsZ=bsxfun(@rdivide,tmp,stdByCell);

%       means=mean(allCellCurves,1);
%         sem=std(allCellsZ,[],1)/sqrt(size(allCellsZ,1));
%         cells_press_mean{e,ps}=means;
%         cells_press_sem{e,ps}=sem;
        figure;
%         prs(ps)=subplot(2,1,ps);
%         plot(allCellCurves','k-','LineWidth',0.25)
        hold on;
        
        errorbar(cells_press_mean{e},cells_press_sem{e},'k','Linewidth',1.5)
        errorbar(red_press_mean{e},red_press_sem{e},'r','Linewidth',1.5)
% errorbar(means,sem,'r','Linewidth',1.5)
        
        title(expt_names{e});
        tmp=gca;
        tmp.XTick=1:size(allCellCurves,2);
        tmp.XTickLabels=cells_press_int{e};
        ylim([-1 1.5])
        ylabel('Z-scored dF/F')
        xlabel('pressure intensity (MPa)')
        %positive responders
        DCsweep=make_DCsweep(expt(e).dF_byDC_Z,expt(e).cells_noLabel,postStim{1});
        cells_DC_mean{e}=DCsweep.meanAll;
        cells_DC_sem{e}=DCsweep.semAll;
        
        %redative responders
        DCsweep=make_DCsweep(expt(e).dF_byDC_Z,expt(e).cellsRed,postStim{1});
        red_DC_mean{e}=DCsweep.meanAll;
        red_DC_sem{e}=DCsweep.semAll;
%         allCellCurves=DCsweep.medianByCell;
%         meanByCell=mean(allCellCurves,2);
%     stdByCell=std(allCellCurves,[],2);
%     tmp=bsxfun(@minus,allCellCurves,meanByCell);
%         allCellsZ=bsxfun(@rdivide,tmp,stdByCell);
% 
%       means=mean(allCellsZ,1);
%         sem=std(allCellsZ,[],1)/sqrt(size(allCellsZ,1));
%         cells_DC_mean{e,ps}=means;
%         cells_DC_sem{e,ps}=sem;
         figure;
%         dcs(ps)=subplot(2,1,ps);
%         plot(allCellCurves','k-','LineWidth',0.25)
        hold on;
        errorbar(cells_DC_mean{e},cells_DC_sem{e},'k','Linewidth',1.5)
        errorbar(red_DC_mean{e},red_DC_sem{e},'r','Linewidth',1.5)
        ylim([-1 1.5])
%         plot(allCellsZ','k-','LineWidth',0.25)
%         hold on;
%         errorbar(cells_press_mean{e,ps},cells_press_sem{e,ps},'r','Linewidth',1.5)
% errorbar(means,sem,'r','Linewidth',1.5)
       
        title(expt_names{e});
        tmp=gca;
        tmp.XTick=1:size(allCellCurves,2);
        tmp.XTickLabels=cells_DC_int{e};
        xlabel('duty cycle (%)')
        ylabel('Z-scored dF/F')
   
%     linkaxes(prs)
%     linkaxes(dcs)
end
% for e=1:length(expt)


%% make figures comparing reg-shift to df/f

stimFrame=150
poststim=stimFrame:(stimFrame+60);

for e=1:length(expt)
    dF_byTrial=expt(e).dF_byTrial;
    cellNames=fieldnames(dF_byTrial);
evokedByTrial=cellfun(@(x)mean(dF_byTrial.(x)(poststim,:),1),cellNames,'un',0);
evokedByTrial=cat(1,evokedByTrial{:});
evokedByTrial_Z=cellfun(@(x)(mean(dF_byTrial.(x)(poststim,:),1)...
    -mean(dF_byTrial.(x)(1:stimFrame,:),1))./std(dF_byTrial.(x)(1:stimFrame,:),[],1),cellNames,'un',0);
evokedByTrial_Z=cat(1,evokedByTrial_Z{:});

xoff_blocks=expt(e).xoff_blocks;
yoff_blocks=expt(e).yoff_blocks;
xyoff_blocks=sqrt(xoff_blocks.^2 + yoff_blocks.^2);
% 
% meanAllCellsTrials=mean(z_means,1);
% figure; plot(meanAllCellsTrials)
% hold on; plot(mean_xoff_z,'k')

% find corrcoef for each trial,cell
% rawF_ps=cellfun(@(x)expt(e).rawF_byTrial.(x),cellNames,'un',0);
rawF_ps=cellfun(@(x)expt(e).dF_byTrial.(x)(poststim,:),cellNames,'un',0);
xyoff_allTrials=xyoff_blocks(poststim,:);
corrVals=cellfun(@(x)corrcoef(x,xyoff_allTrials),rawF_ps,'un',0);
corrVals=cellfun(@(x)x(2),corrVals);
corr_shuff=zeros(size(corrVals));
corrByT=zeros(length(corrVals),size(xyoff_allTrials,2));
corrByT_shuff=corrByT;
for c=1:length(cellNames)
    raw=rawF_ps{c};
    raw_shuff=zeros(size(raw));
    rows=size(raw,1);
    xyshuff=xyoff_allTrials;
    for r=1:size(raw,2)
        tmp=corrcoef(raw(:,r),xyoff_allTrials(:,r));
        corrByT(c,r)=tmp(2);
        idx_r=randperm(rows);
        idx_s=randperm(rows);
        raw_shuff(:,r)=raw(idx_r,r);
        xyshuff(:,r)=xyshuff(idx_s,r);
        tmp=corrcoef(raw_shuff(:,r),xyshuff(:,r));
        corrByT_shuff(c,r)=tmp(2);
    end
    tmp=corrcoef(raw_shuff,xyshuff);
    corr_shuff(c)=tmp(2);
end
    
% plot histogram of corr coeff and shuffled
figure; hold on
histogram(corrVals,20,'Normalization','probability','FaceColor','k','FaceAlpha',0.6,'EdgeColor','k');%,'FaceAlpha',0.5);
histogram(corr_shuff,20,'Normalization','probability','FaceColor','g','FaceAlpha',0.4,'EdgeColor','g');
xlabel('correlation coefficient');
ylabel('probability')
legend('real','shuffled (time)')
title(' correlation of raw F and pixel shifts for each cell')

% plot histogram of corr coeff and shuffled
figure; hold on
histogram(corrByT(:),'Normalization','probability','FaceColor','k','FaceAlpha',0.6,'EdgeColor','k');%,'FaceAlpha',0.5);
histogram(corrByT_shuff(:),'Normalization','probability','FaceColor','g','FaceAlpha',0.4,'EdgeColor','g');
xlabel('correlation coefficient');
ylabel('probability')
legend('real','shuffled (time)')
title('trial-by-trial correlation of raw F and pixel shifts for each cell')


% calculate pixel offset for each trial
xoff_byTrial=mean(xoff_blocks(poststim,:),1);
yoff_byTrial=mean(yoff_blocks(poststim,:),1);
xyoff_byTrial=mean(xyoff_blocks(poststim,:),1);
evokedByTrial_mean=mean(evokedByTrial,1);
figure; hold on
plot_scatterRLine( xyoff_byTrial,evokedByTrial_mean )
xlabel('post-stim offset (pixels)')
ylabel('population post-stim dF/F')
% title(['trial-by-trial pixel offset vs. dF/F, ', expt_names{e}])
% plot(xyoff_byTrial,evokedByTrial_Z_mean,'ko')
% hold on; plot(abs(yoff_byTrial),evokedByTrial_Z_mean,'ro')

reg_xyoff=repmat(xyoff_byTrial,size(evokedByTrial,1),1);
% figure; hold on
[~,ax]=scatterPlot_marginals(reg_xyoff(:),evokedByTrial(:),[],[]);
ax(1).XLabel.String='post-stim offset (pixels)';
ax(1).YLabel.String='post-stim dF/F';
% figure; plot(abs(mean_xoff_z),meanAllCellsTrials,'ko')

end