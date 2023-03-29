function pupCall_multidayROIs(matchFilePath,paths_2p)

%% load in meanByTrial, P, h_calls, dFByTrial, matchFileData

for d=1:length(paths_2p)
    load([paths_2p{d},'reduced_data.mat'],'meanByTrial_early','meanByTrial_late','h_calls','responsiveTrials_byCell','dFByTrial');
    load([paths_2p{d},'tone_tuning.mat'],'TUNING','dFByTone','h_pass');
    [F_calls,F_byToneRep]=load2p_data_pupcalls(paths_2p{d});
    [deltaF_calls] = pupCalls_make_deltaFall(F_calls,3,0);
    [deltaF_tones] = tones_make_deltaFall(F_byToneRep,3,0,30);

    allDates(d).meanDF_total_calls=mean(deltaF_calls,2);
    allDates(d).meanDF_total_tones=mean(deltaF_tones,2);
    allDates(d).meanByTrial_early = meanByTrial_early;
    allDates(d).meanByTrial_late = meanByTrial_late;
    allDates(d).h_calls= h_calls;
    allDates(d).responsiveTrials=responsiveTrials_byCell;
    allDates(d).dFByTrial=dFByTrial;
    allDates(d).dFByTone=dFByTone;
    allDates(d).tones=TUNING(1).tones;
    allDates(d).meanRTones=cat(1,TUNING(:).mean);
    allDates(d).h_tones=h_pass;
end

load(matchFilePath);
%% find multi-day ROIs

load(matchFilePath);

% match roi matching dates to alldates
matchDates=roiMatchData.allRois';
roiMatchOrder=zeros(length(paths_2p),1);
for d=1:length(paths_2p)
    tmpmatch=cellfun(@(x)contains(x,paths_2p{d}),matchDates);
    roiMatchOrder(d)=find(tmpmatch);
end

mapping=unique(roiMatchData.mapping,'rows');    % find rows that aren't copies
mapping=mapping(:,roiMatchOrder);   % reorder columns so the dates match chronological order
idx_multiDay=find(sum(mapping>0,2)>1);
mapping=mapping(idx_multiDay,:);
[~,isUn]=unique(mapping(:,1));
mapping=mapping(isUn,:);
%% Index matched ROIs based on 'iscell'

for d=1:length(paths_2p)
    load([paths_2p{d},'Fall.mat'],'iscell');
    iscellIDs{d}=find(iscell(:,1));
    numROIs(d)=length(iscell);
end
%% make structure of dFByTrial for each multi-day ROI

for d=1:length(allDates)
    % call responses
    meanResponsesTmp=cellfun(@(x)mean(x,1),allDates(d).dFByTrial,'un',0);
    meanResponses=cell(1,size(allDates(d).dFByTrial,2));
    SEMresponsesTmp=cellfun(@(x)std(x,[],1)/sqrt(size(x,1)),allDates(d).dFByTrial,'un',0);
    SEMresponses=cell(1,size(allDates(d).dFByTrial,2));

    % tone responses
    meanResponsesToneTmp=cellfun(@(x)mean(x,1),allDates(d).dFByTone,'un',0);
    meanResponsesTone=cell(1,size(allDates(d).dFByTone,2));
    SEMresponsesToneTmp=cellfun(@(x)std(x,[],1)/sqrt(size(x,1)),allDates(d).dFByTone,'un',0);
    SEMresponsesTone=cell(1,size(allDates(d).dFByTone,2));

    for c=1:size(allDates(d).dFByTrial,2)
        meanResponses{c}=cat(1,meanResponsesTmp{:,c});
        SEMresponses{c}=cat(1,SEMresponsesTmp{:,c});
    end
    allDates(d).meanResponses=meanResponses;
    allDates(d).SEMresponses=SEMresponses;

    % tone responses
    meanResponsesToneTmp=cellfun(@(x)mean(x,1),allDates(d).dFByTone,'un',0);
    meanResponsesTone=cell(1,size(allDates(d).dFByTone,2));
    SEMresponsesToneTmp=cellfun(@(x)std(x,[],1)/sqrt(size(x,1)),allDates(d).dFByTone,'un',0);
    SEMresponsesTone=cell(1,size(allDates(d).dFByTone,2));

    for c=1:size(allDates(d).dFByTone,2)
        meanResponsesTone{c}=cat(1,meanResponsesToneTmp{:,c});
        SEMresponsesTone{c}=cat(1,SEMresponsesToneTmp{:,c});
    end
    allDates(d).meanResponsesTone=meanResponsesTone;
    allDates(d).SEMresponsesTone=SEMresponsesTone;

end

% make structure with tuning for each multi-day ROI
tones=allDates(1).tones;

% roiMatches=roiMatchData.allSessionMapping;
for r=1:size(mapping,1)
    meanResponsesByDay=cell(1,size(mapping,2));
    SEMresponsesByDay=cell(1,size(mapping,2));

    meanToneByDay=cell(1,size(mapping,2));
    SEMToneByDay=cell(1,size(mapping,2));
meanByTrial_early=cell(1,size(mapping,2));
             meanByTrial_late=meanByTrial_early;
             meanEarly=zeros(6,size(mapping,2));
             meanLate=meanEarly;
             meanR=meanEarly;
             meanRTones=zeros(length(tones),size(mapping,2));
             meanDF_total_calls=zeros(1,size(mapping,2));
             meanDF_total_tones=meanDF_total_calls;
             h_calls=zeros(1,size(mapping,2));
             h_tones=h_calls;
          meanCalls_Z(:,d)=zeros(6,1);
             meanTones_Z(:,d)=zeros(length(tones),1);
          


    for d=1:length(allDates)
        idx_ROI=mapping(r,d);
         if idx_ROI==0
              meanResponsesByDay{d}=[];
          SEMresponsesByDay{d}=[];
             meanToneByDay{d}=[];
             SEMToneByDay{d}=[];
             meanByTrial_early{d}=[];
             meanByTrial_late{d}=[];
             meanEarly(:,d)=nan(6,1);
             meanLate(:,d)=nan(6,1);
             meanR(:,d)=nan(6,1);
             meanRTones(:,d)=nan(length(tones),1);

             meanDF_total_calls(d)=nan;
             meanDF_total_tones(d)=nan;
             h_calls(d)=nan;
             h_tones(d)=nan;
            meanCalls_Z(:,d)=nan(6,1);
             meanTones_Z(:,d)=nan(length(tones),1);
          

         elseif sum(sum(isnan(allDates(d).meanResponses{idx_ROI})))>0 || sum(sum(isnan(allDates(d).meanResponsesTone{idx_ROI})))>0
             meanResponsesByDay{d}=[];
             SEMresponsesByDay{d}=[];
             meanToneByDay{d}=[];
             SEMToneByDay{d}=[];
             meanByTrial_early{d}=[];
             meanByTrial_late{d}=[];
             meanEarly(:,d)=nan(6,1);
             meanLate(:,d)=nan(6,1);
             meanR(:,d)=nan(6,1);
             meanRTones(:,d)=nan(length(tones),1);
             meanDF_total_calls(d)=nan;
             meanDF_total_tones(d)=nan;
             h_calls(d)=nan;
             h_tones(d)=nan;
             meanCalls_Z(:,d)=nan(6,1);
             meanTones_Z(:,d)=nan(length(tones),1);
          
         else
            meanResponsesByDay{d}=allDates(d).meanResponses{idx_ROI};
            SEMresponsesByDay{d}=allDates(d).SEMresponses{idx_ROI};

            meanToneByDay{d}=allDates(d).meanResponsesTone{idx_ROI};
            SEMToneByDay{d}=allDates(d).SEMresponsesTone{idx_ROI};
   
            meanByTrial_late{d}=allDates(d).meanByTrial_late(:,idx_ROI);
            meanByTrial_early{d}=allDates(d).meanByTrial_early(:,idx_ROI);
            meanEarly(:,d)=cellfun(@mean,meanByTrial_early{d});
            meanLate(:,d)=cellfun(@mean,meanByTrial_late{d});
            meanR(:,d)=mean([meanEarly(:,d),meanLate(:,d)],2);
            meanRTones(:,d)=allDates(d).meanRTones(idx_ROI,:)';
            meanDF_total_calls(d)= allDates(d).meanDF_total_calls(idx_ROI);
             meanDF_total_tones(d)=allDates(d).meanDF_total_tones(idx_ROI);
             h_calls(d)=sum(allDates(d).h_calls(idx_ROI,:));
             h_tones(d)=sum(allDates(d).h_tones(idx_ROI,:));
          % make zscored versions of mean responses
    meanDF_calls=nanmean(meanR(:,d));
    stdDF_calls = nanstd(meanR(:,d));
    meanCalls_Z(:,d)= (meanR(:,d)-meanDF_calls)/stdDF_calls;

    meanDF_tones=nanmean(meanRTones(:,d));
    stdDF_tones = nanstd(meanRTones(:,d));
    meanTones_Z(:,d)= (meanRTones(:,d)-meanDF_tones)/stdDF_tones;
         end
    end

    
    MultiDayROIs(r).meanResponsesCalls=meanResponsesByDay;
    MultiDayROIs(r).SEMresponsesCalls=SEMresponsesByDay;
    MultiDayROIs(r).meanResponsesTones=meanToneByDay;
    MultiDayROIs(r).SEMresponsesTones=SEMToneByDay;
    MultiDayROIs(r).meanByTrial_late=meanByTrial_late;
    MultiDayROIs(r).meanByTrial_early=meanByTrial_early;
    MultiDayROIs(r).meanLate=meanLate;
    MultiDayROIs(r).meanEarly=meanEarly;
    MultiDayROIs(r).meanR=meanR;
    MultiDayROIs(r).meanRTones=meanRTones;
    MultiDayROIs(r).meanDF_total_calls=meanDF_total_calls;
    MultiDayROIs(r).meanDF_total_tones=meanDF_total_tones;
    MultiDayROIs(r).h_calls=h_calls;
    MultiDayROIs(r).h_tones=h_tones;
   MultiDayROIs(r).meanCalls_Z=meanCalls_Z;
   MultiDayROIs(r).meanTones_Z=meanTones_Z;

end


%% plot mean + sem responses by day for each matched cell

cmap={'-r','-o','-g','-b','-m'};
timeplot=((1:size(MultiDayROIs(1).meanResponsesCalls{1},2))-2*30)/30;
for r=1:length(MultiDayROIs)
    figure; hold on
    for d=1:length(allDates)
        if ~isempty(MultiDayROIs(r).meanResponsesCalls{d})
            for c=1:6
                subplot(1,6,c)
                hold on
                shadedErrorBar(timeplot,MultiDayROIs(r).meanResponsesCalls{d}(c,:),MultiDayROIs(r).SEMresponsesCalls{d}(c,:),cmap{d})
            end
        else
        end
    end
end
%% plot mean responses by day for each matched cell

daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates)-1,'un',0);
cmap=cool(length(allDates)+1);

tones=allDates(1).tones;
% cmap=brewermap(length(allDates),'Spectral');
timeTones=((1:size(allDates(1).meanResponsesTone{1},2))-1*30)/30;

timeplot=((1:size(allDates(1).meanResponses{1},2))-2*30)/30;
for r=1:length(MultiDayROIs)
    % set max Y for calls;
    maxPlot=cellfun(@(x)nanmax(nanmax(x)),MultiDayROIs(r).meanResponsesCalls,'un',0);
    maxPlot=nanmax([maxPlot{:}]);
    maxPlotCalls=maxPlot+3;

    % set max Y for this calls;
    minPlot=cellfun(@(x)min(min(x)),MultiDayROIs(r).meanResponsesCalls,'un',0);
    minPlot=min([minPlot{:}]);
    minPlotCalls=minPlot-3;
    
    % set max Y for tones;
    maxPlot=cellfun(@(x)max(max(x)),MultiDayROIs(r).meanResponsesTones,'un',0);
    maxPlot=max([maxPlot{:}]);
    maxPlotTones=maxPlot+3;

    % set max Y for this calls;
    minPlot=cellfun(@(x)min(min(x)),MultiDayROIs(r).meanResponsesCalls,'un',0);
    minPlot=min([minPlot{:}]);
    minPlotTones=minPlot-3;
    
    fig=figure; hold on;
    fig.Position=[73 113 1317 581];
    annotation('textbox',[0.05 0.9 0.2 0.1],'String',['ROI ',num2str(r)],'EdgeColor','none');
    for d=1:length(allDates)
        if ~isempty(MultiDayROIs(r).meanResponsesCalls{d})
            for c=1:6
                subplot(2,length(tones),c)
                hold on
                plot(timeplot,MultiDayROIs(r).meanResponsesCalls{d}(c,:),'color',cmap(d,:))
                tmp=gca;
                tmp.YLim=[minPlotCalls maxPlotCalls];
%                 axis square
                title(['call',num2str(c)])
            end

            for c=1:length(tones)
                subplot(2,length(tones),c+length(tones))
                hold on
                plot(timeTones,MultiDayROIs(r).meanResponsesTones{d}(c,:),'color',cmap(d,:))
                tmp=gca;
                tmp.YLim=[minPlotTones maxPlotTones]; 
%                 axis square
                title(tones(c))
                
            end
            legend(daylabels)
        else
        end
    end
end

%% plot Zscored mean responses across days (colormap days)

cmap=cool(length(allDates));
for r=1:length(MultiDayROIs)
    fig=figure; hold on
    fig.Position=[71 72 378 581];
        annotation('textbox',[0.05 0.9 0.2 0.1],'String',['ROI ',num2str(r)],'EdgeColor','none');

    for d=1:length(allDates)
        subplot(2,1,1)
        hold on
        plot(1:6,MultiDayROIs(r).meanCalls_Z(:,d),'-o','color',cmap(d,:))
        title('mean response, total')
        xlabel('calls')
        ylabel('Z-scored mean dF/F')
        
        subplot(2,1,2)
        hold on
        plot(1:length(tones),MultiDayROIs(r).meanTones_Z(:,d),'-o','color',cmap(d,:))
        title('mean response, tones')
        xlabel('days')
        ylabel('Z-scored mean dF/F')
        tmp=gca;
        tmp.XTick=1:length(tones);
        tmp.XTickLabel=tones;
      legend(daylabels)
    end
end
%% plot mean responses across days (colormap days)

cmap=cool(length(allDates));
for r=1:length(MultiDayROIs)
    fig=figure; hold on
    fig.Position=[71 72 378 581];
        annotation('textbox',[0.05 0.9 0.2 0.1],'String',['ROI ',num2str(r)],'EdgeColor','none');

    for d=1:length(allDates)
%         subplot(1,4,1)
%         hold on
%         plot(1:6,MultiDayROIs(r).meanEarly(:,d),'-o','color',cmap(d,:))
%         title('mean response, early')
%         xlabel('calls')
%         ylabel('mean dF/F')
% 
%         subplot(1,4,2)
%         hold on
%         plot(1:6,MultiDayROIs(r).meanLate(:,d),'-o','color',cmap(d,:))
%         title('mean response, late')
%         xlabel('calls')
%         ylabel('mean dF/F')

        subplot(2,1,1)
        hold on
        plot(1:6,MultiDayROIs(r).meanR(:,d),'-o','color',cmap(d,:))
        title('mean response, total')
        xlabel('calls')
        ylabel('mean dF/F')
        
        subplot(2,1,2)
        hold on
        plot(1:length(tones),MultiDayROIs(r).meanRTones(:,d),'-o','color',cmap(d,:))
        title('mean response, tones')
        xlabel('days')
        ylabel('mean dF/F')
        tmp=gca;
        tmp.XTick=1:length(tones);
        tmp.XTickLabel=tones;
      legend(daylabels)
    end
end

%% plot meanDF_total over days

meanDF_total_calls=cat(1,MultiDayROIs(:).meanDF_total_calls);
meanDF_total_tones=cat(1,MultiDayROIs(:).meanDF_total_tones);

figure; hold on
plot(1:length(allDates),meanDF_total_calls,'o-')
title('calls')

figure; hold on
plot(1:length(allDates),meanDF_total_tones,'o-')
title('tones')


figure; hold on
plotSpread(meanDF_total_calls,[],[],[],4)
title('mean dF/F during call blocks')
tmp=gca;
tmp.XTickLabel=0:length(allDates)-1;
xlabel('days of cohousing')
ylabel('mean dF/F')

figure; hold on
plotSpread(meanDF_total_tones,[],[],[],4)
title('mean dF/F during tone blocks')
tmp=gca;
tmp.XTickLabel=0:length(allDates)-1;
xlabel('days of cohousing')
ylabel('mean dF/F')

daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates)-1,'un',0);
cmap=morgenstemning(length(allDates)+1);
figure; hold on
for i=1:length(allDates)
    tmp=cdfplot(meanDF_total_tones(:,i));
    tmp.Color=cmap(i,:)
end
legend(daylabels);
xlabel('mean dF/F, tone blocks')
ylabel('fraction of ROIs')
title('mean dF/F during tone blocks')

daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates)-1,'un',0);
cmap=morgenstemning(length(allDates)+1);
figure; hold on
for i=1:length(allDates)
    tmp=cdfplot(meanDF_total_calls(:,i));
    tmp.Color=cmap(i,:)
end
legend(daylabels);
xlabel('mean dF/F, call blocks')
ylabel('fraction of ROIs')
title('mean dF/F during call blocks')


%% number of response-evoking calls and tones by day

responsive_calls=cat(1,MultiDayROIs(:).h_calls);
responsive_tones=cat(1,MultiDayROIs(:).h_tones);

figure; hold on
plot(1:length(allDates),responsive_calls,'o-')
title('calls')

figure; hold on
plot(1:length(allDates),responsive_tones,'o-')
title('tones')

%% look at best responses over days, best call

bestCalls=zeros(length(MultiDayROIs), length(allDates));
maxResponse=bestCalls;
meanCall=maxResponse;

bestTones=bestCalls;
maxTones=bestCalls;
meanTones=maxTones;
for r=1:length(MultiDayROIs)
    [maxes,bc]=max(MultiDayROIs(r).meanR);
    bc(isnan(maxes))=nan;
    bestCalls(r,:)=bc;
    maxResponse(r,:)=maxes;
    meanCall(r,:)=mean(MultiDayROIs(r).meanR);

    [maxes,bc]=max(MultiDayROIs(r).meanRTones);
    bc(isnan(maxes))=nan;
    bestTones(r,:)=bc;
    maxTones(r,:)=maxes;
    meanTones(r,:)=mean(MultiDayROIs(r).meanRTones);
end

figure; hold on
plot(1:length(allDates),maxResponse,'-')
title('max call response')
xlabel('days')

figure; hold on
plot(1:length(allDates),bestCalls,'-')
title('best call')
xlabel('days')

figure; hold on
plot(1:length(allDates),maxTones,'-')
title('best tone response')
xlabel('days')

figure; hold on
plot(1:length(allDates),bestTones,'-')
title('best tone')
xlabel('days')
ylabel('tones')
tmp=gca;
tmp.YTickLabel=tones;

figure; hold on
plot(1:length(allDates),meanCall,'-')
title('mean call response')
xlabel('days')

figure; hold on
plot(1:length(allDates),meanTones,'-')
title('mean tone response')
xlabel('days')

%% swarm plots of max responses over days

figure;
 plotSpread(maxResponse,[],[],[],4);
 title('response to best call')
xlabel('day of cohousing')
ylabel('mean dF/F')
tmp=gca;
tmp.XTickLabel=0:(length(allDates)-1)

 figure;
 plotSpread(maxTones,[],[],[],4);
title('response to best tone')
xlabel('day of cohousing')
ylabel('mean dF/F')
tmp=gca;
tmp.XTickLabel=0:(length(allDates)-1);

figure;
 plotSpread(meanCall,[],[],[],4);
 title('mean call response')
xlabel('day of cohousing')
ylabel('mean dF/F')
tmp=gca;
tmp.XTickLabel=0:(length(allDates)-1);

 figure;
 plotSpread(meanTones,[],[],[],4);
title('mean tone response')
xlabel('day of cohousing')
ylabel('mean dF/F')
tmp=gca;
tmp.XTickLabel=0:(length(allDates)-1);

daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates)-1,'un',0);
cmap=morgenstemning(length(allDates)+1);
figure; hold on
for i=1:length(allDates)
    tmp=cdfplot(meanCall(:,i));
    tmp.Color=cmap(i,:);
end
legend(daylabels);
xlabel('mean dF/F')
ylabel('fraction of ROIs')
title('mean call response')

cmap=morgenstemning(length(allDates)+1);
figure; hold on
for i=1:length(allDates)
    tmp=cdfplot(meanTones(:,i));
    tmp.Color=cmap(i,:);
end
legend(daylabels);
xlabel('mean dF/F')
ylabel('fraction of ROIs')
title('mean Tone response')

cmap=morgenstemning(length(allDates)+1);
figure; hold on
for i=1:length(allDates)
    tmp=cdfplot(maxResponse(:,i));
    tmp.Color=cmap(i,:);
end
legend(daylabels);
xlabel('mean dF/F')
ylabel('fraction of ROIs')
title('max call response')

cmap=morgenstemning(length(allDates)+1);
figure; hold on
for i=1:length(allDates)
    tmp=cdfplot(maxTones(:,i));
    tmp.Color=cmap(i,:);
end
legend(daylabels);
xlabel('mean dF/F')
ylabel('fraction of ROIs')
title('max Tone response')

%% compare first and last day 

figure; hold on
plot(meanCall(:,1),meanCall(:,size(meanCall,2)),'ko')
minPlot=min(min(meanCall));
maxPlot=max(max(meanCall));
plot([minPlot maxPlot],[minPlot maxPlot],'k:')
xlabel('mean call response, day 0')
ylabel('mean call response, last day')
tmp=gca
tmp.XLim=[minPlot maxPlot];
tmp.YLim=[minPlot maxPlot];
axis square

figure; hold on
plot(meanTones(:,1),meanTones(:,size(meanTones,2)),'ko')
minPlot=min(min(meanTones));
maxPlot=max(max(meanTones));
plot([minPlot maxPlot],[minPlot maxPlot],'k:')
xlabel('mean tone response, day 0')
ylabel('mean tone response, last day')
tmp=gca
tmp.XLim=[minPlot maxPlot];
tmp.YLim=[minPlot maxPlot];
axis square

figure; hold on
plot(maxResponse(:,1),maxResponse(:,size(maxResponse,2)),'ko')
minPlot=min(min(maxResponse));
maxPlot=max(max(maxResponse));
plot([minPlot maxPlot],[minPlot maxPlot],'k:')
xlabel('best call response, day 0')
ylabel('best call response, last day')
tmp=gca
tmp.XLim=[minPlot maxPlot];
tmp.YLim=[minPlot maxPlot];
axis square

figure; hold on
plot(maxTones(:,1),maxTones(:,size(maxTones,2)),'ko')
minPlot=min(min(maxTones));
maxPlot=max(max(maxTones));
plot([minPlot maxPlot],[minPlot maxPlot],'k:')
xlabel('best tone response, day 0')
ylabel('best tone response, last day')
tmp=gca
tmp.XLim=[minPlot maxPlot];
tmp.YLim=[minPlot maxPlot];
axis square

%% calculate correlations across days for tone tuning, call tuning for each ROI

allCombs=nchoosek(1:length(allDates),2);

meanCorrEarly=zeros(length(MultiDayROIs),1);
meanCorrLate=meanCorrEarly;
meanCorrCalls=meanCorrEarly;
meanCorrTones=meanCorrCalls;

% shuffled
shuffCorrEarly=zeros(length(MultiDayROIs),1);
shuffCorrLate=shuffCorrEarly;
shuffCorrCalls=shuffCorrEarly;
shuffCorrTones=shuffCorrCalls;

% loop through ROIs
for r=1:length(MultiDayROIs)
    % preallocate vectors of correlations for each combo
    corrEarly=zeros(size(allCombs,1),1);
    corrLate=corrEarly;
    corrR=corrEarly;
    corrTones=corrEarly;
    
    shuffEarly=zeros(size(allCombs,1),1);
    shuffLate=shuffEarly;
    shuffR=shuffEarly;
    shuffTones=shuffEarly;
    
    % loop through combos
    for comb=1:size(allCombs,1)

        early1=MultiDayROIs(r).meanEarly(:,allCombs(comb,1));
        early2=MultiDayROIs(r).meanEarly(:,allCombs(comb,2));
        corrTmp=corrcoef(early1,early2);
        corrEarly(comb)=corrTmp(2);

        late1=MultiDayROIs(r).meanLate(:,allCombs(comb,1));
        late2=MultiDayROIs(r).meanLate(:,allCombs(comb,2));
        corrTmp=corrcoef(late2,late1);
        corrLate(comb)=corrTmp(2);

        calls1=MultiDayROIs(r).meanR(:,allCombs(comb,1));
        calls2=MultiDayROIs(r).meanR(:,allCombs(comb,2));
        corrTmp=corrcoef(calls2,calls1);
        corrR(comb)=corrTmp(2);

        tones1=MultiDayROIs(r).meanRTones(:,allCombs(comb,1));
        tones2=MultiDayROIs(r).meanRTones(:,allCombs(comb,2));
        corrTmp=corrcoef(tones2,tones1);
        corrTones(comb)=corrTmp(2);

        % shuffled correlations
        shuffEarly2=early2(randperm(length(early2)));
        corrTmp=corrcoef(early1,shuffEarly2);
        shuffEarly(comb)=corrTmp(2);

        shuffLate2=late2(randperm(length(late2)));
        corrTmp=corrcoef(late1,shuffLate2);
        shuffLate(comb)=corrTmp(2);

        shuffCalls2=calls2(randperm(length(calls2)));
        corrTmp=corrcoef(calls1,shuffCalls2);
        shuffR(comb)=corrTmp(2);

        shuffTones2=tones2(randperm(length(tones2)));
        corrTmp=corrcoef(tones1,shuffTones2);
        shuffTones(comb)=corrTmp(2);

    end

    meanCorrEarly(r)=nanmean(corrEarly);
    meanCorrLate(r)=nanmean(corrLate);
    meanCorrCalls(r)=nanmean(corrR);
    meanCorrTones(r)=nanmean(corrTones);

    shuffCorrEarly(r)=nanmean(shuffEarly);
    shuffCorrLate(r)=nanmean(shuffLate);
    shuffCorrCalls(r)=nanmean(shuffR);
    shuffCorrTones(r)=nanmean(shuffTones);
end

% cmap=brewermap(4,'dark2');
% figure; hold on
% % p(1)=cdfplot(meanCorrEarly);
% % p(1).Color=cmap(1,:);
% % 
% % 
% % p(2)=cdfplot(meanCorrLate);
% % p(2).Color=cmap(2,:);
% 
% p(3)=cdfplot(meanCorrCalls);
% p(3).Color=cmap(3,:);
% 
% p(4)=cdfplot(meanCorrTones);
% p(4).Color=cmap(4,:);
% 
% title('mean tuning correlation across days')
% xlabel('corr coef')
% ylabel('fraction of ROIs')
% legend('calls, early','calls, late','calls','tones')

cmap=brewermap(8,'Paired');
figure; hold on
p(1)=cdfplot(meanCorrEarly);
p(1).Color=cmap(2,:);
p(2)=cdfplot(shuffCorrEarly);
p(2).Color=cmap(1,:);
title('calls,early')
legend('data','shuff')

figure; hold on
p(1)=cdfplot(meanCorrLate);
p(1).Color=cmap(4,:);
p(2)=cdfplot(shuffCorrLate);
p(2).Color=cmap(3,:);
title('calls,late')
legend('data','shuff')

figure; hold on
p(1)=cdfplot(meanCorrCalls);
p(1).Color=cmap(6,:);
p(2)=cdfplot(shuffCorrCalls);
p(2).Color=cmap(5,:);
[h,pval]=ttest(meanCorrCalls,shuffCorrCalls)
title('calls')
legend('data','shuff')
xlabel('correlation')
ylabel('fraction of ROIs')


figure; hold on
p(1)=cdfplot(meanCorrTones);
p(1).Color=cmap(8,:);
p(2)=cdfplot(shuffCorrTones);
p(2).Color=cmap(7,:);
[h,pval]=ttest(meanCorrTones,shuffCorrTones)
title('tones')
legend('data','shuff')
xlabel('correlation')
ylabel('fraction of ROIs')


figure; hold on
p(1)=cdfplot(meanCorrCalls);
p(1).Color=cmap(6,:);
% p(2)=cdfplot(shuffCorrCalls);
% p(2).Color=cmap(5,:);

p(1)=cdfplot(meanCorrTones);
p(1).Color=cmap(8,:);
% p(2)=cdfplot(shuffCorrTones);
% p(2).Color=cmap(7,:);
title('mean correlation across days')
legend('calls','tones')
xlabel('correlation')
ylabel('fraction of ROIs')

figure; hold on
plotSpread([meanCorrEarly,meanCorrLate,meanCorrCalls,meanCorrTones],[],[],{'calls, early','calls, late','calls','tones'},4)
plot(1,nanmean(shuffCorrEarly),'go')
plot(2,nanmean(shuffCorrLate),'go')
plot(3,nanmean(shuffCorrCalls),'go')
plot(4,nanmean(shuffCorrTones),'go')
ylabel('mean correlation across days')
%% sort ROIs by highest correlations across days

[~,corr_idx_calls] = sort(meanCorrCalls,'ascend');

MultiDayROIs_unsorted=MultiDayROIs;
MultiDayROIs = MultiDayROIs(corr_idx_calls);

[~,corr_idx_tones] = sort(meanCorrTones,'ascend');
MultiDayROIs = MultiDayROIs_unsorted(corr_idx_tones);

%% correlation of calls vs correlation of tone tuning

figure; hold on
plot(1:2,[meanCorrCalls,meanCorrTones],'ko-')
plot(1:2,[shuffCorrCalls,shuffCorrTones],'go-')

figure; hold on
plot_scatterRLine(meanCorrTones,meanCorrCalls)
xlabel('cross day corr, tone tuning')
ylabel('cross day corr, call tuning')