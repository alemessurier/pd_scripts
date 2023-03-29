function [allDates_calls_10sec,allDates_calls_5sec,allDates_calls_2sec,allDates_tones_5sec,allDates_tones_3sec,...
    MultiDayROIs_calls_2sec,MultiDayROIs_calls_5sec,MultiDayROIs_calls_10sec,MultiDayROIs_tones_3sec]= pupCall_multidayROIs_multiISI(matchFilePath,paths_2p,save_path)

%% load in meanByTrial, P, h_calls, dFByTrial, matchFileData
%
% for d=1:length(paths_2p)
%     load([paths_2p{d},'reduced_data.mat'],'meanByTrial_early','meanByTrial_late','h_calls','responsiveTrials_byCell','dFByTrial');
%     load([paths_2p{d},'tone_tuning.mat'],'TUNING','dFByTone','h_pass');
%     [F_calls,F_byToneRep]=load2p_data_pupcalls(paths_2p{d});
%     [deltaF_calls] = pupCalls_make_deltaFall(F_calls,3,0);
%     [deltaF_tones] = tones_make_deltaFall(F_byToneRep,3,0,30);
%
%     allDates(d).meanDF_total_calls=mean(deltaF_calls,2);
%     allDates(d).meanDF_total_tones=mean(deltaF_tones,2);
%     allDates(d).meanByTrial_early = meanByTrial_early;
%     allDates(d).meanByTrial_late = meanByTrial_late;
%     allDates(d).h_calls= h_calls;
%     allDates(d).responsiveTrials=responsiveTrials_byCell;
%     allDates(d).dFByTrial=dFByTrial;
%     allDates(d).dFByTone=dFByTone;
%     allDates(d).tones=TUNING(1).tones;
%     allDates(d).meanRTones=cat(1,TUNING(:).mean);
%     allDates(d).h_tones=h_pass;
% end
%

[allDates_calls_10sec,allDates_calls_5sec,allDates_calls_2sec,allDates_tones_5sec,allDates_tones_3sec]=load_multiDay_data(paths_2p)
roiMatchData=load(matchFilePath);

%% find multi-day ROIs

roiMatchData=roiMatchData.roiMatchData;
% match roi matching dates to alldates
matchDates=roiMatchData.allRois';
idxtmp=cellfun(@(x)strfind(x,'reduced'),paths_2p);
roiMatchOrder=zeros(length(paths_2p),1);
for d=1:length(paths_2p)
    pathUse=paths_2p{d}(idxtmp(d):end);
    tmpmatch=cellfun(@(x)contains(x,pathUse),matchDates);
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

MultiDayROIs_calls_5sec=make_multiDayROIs_struct_calls(allDates_calls_5sec,mapping);
MultiDayROIs_calls_10sec=make_multiDayROIs_struct_calls(allDates_calls_10sec,mapping);
MultiDayROIs_calls_2sec=make_multiDayROIs_struct_calls(allDates_calls_2sec,mapping);

% MultiDayROIs_tones_5sec=make_multiDayROIs_struct_tones(allDates_tones_5sec,mapping);
MultiDayROIs_tones_3sec=make_multiDayROIs_struct_tones(allDates_tones_3sec,mapping);

% %% plots
%  plot_meanDF_calls_multiISI(allDates_calls_10sec,MultiDayROIs_calls_2sec,MultiDayROIs_calls_5sec,MultiDayROIs_calls_10sec)
% plot_meanDF_multiday(allDates_tones_3sec,allDates_calls_10sec,MultiDayROIs_tones_3sec,MultiDayROIs_calls_10sec)
% plot_meanDF_multiday(allDates_tones_3sec,allDates_calls_5sec,MultiDayROIs_tones_3sec,MultiDayROIs_calls_5sec)

save([save_path,'MultiDayROIs.mat'],'allDates_calls_10sec','allDates_calls_5sec','allDates_calls_2sec','allDates_tones_5sec','allDates_tones_3sec',...
    'MultiDayROIs_calls_2sec','MultiDayROIs_calls_5sec','MultiDayROIs_calls_10sec','MultiDayROIs_tones_3sec')
%%
    function [allDates_calls_10sec,allDates_calls_5sec,allDates_calls_2sec,allDates_tones_5sec,allDates_tones_3sec]=load_multiDay_data(paths_2p)
        %load data
        for d=1:length(paths_2p)
            [F_calls_2sec,F_calls_5sec,F_calls_10sec,F_byToneRep_3sec,F_byToneRep_5sec,...
                ops,inds_ex,Fcell]=load2p_data_pupcalls_multiISI(paths_2p{d});

            [deltaF_calls_IC_5sec] = pupCalls_make_deltaFall(F_calls_5sec,3,0);

            if ~isempty(F_calls_10sec{1})
                [deltaF_calls_IC_10sec] = pupCalls_make_deltaFall(F_calls_10sec,3,0);
            else
                deltaF_calls_IC_10sec=[];
            end

            if ~isempty(F_calls_2sec{1})
                [deltaF_calls_IC_2sec] = pupCalls_make_deltaFall(F_calls_2sec,3,0);
                allDates_calls_2sec(d).meanDF_total_calls=mean(deltaF_calls_IC_2sec,2);

            else
                deltaF_calls_IC_2sec=[];
                allDates_calls_2sec(d).meanDF_total_calls=[];
            end

            [deltaF_tones_IC_5sec] = tones_make_deltaFall(F_byToneRep_5sec,3,0,30);

            if ~isempty(F_byToneRep_3sec)
                [deltaF_tones_IC_3sec] = tones_make_deltaFall(F_byToneRep_3sec,3,0,30);
            else
                deltaF_tones_IC_3sec=[];
            end

            allDates_calls_5sec(d).meanDF_total_calls=mean(deltaF_calls_IC_5sec,2);
            allDates_calls_10sec(d).meanDF_total_calls=mean(deltaF_calls_IC_10sec,2);
            allDates_tones_3sec(d).meanDF_total_tones=mean(deltaF_tones_IC_3sec,2);
            allDates_tones_5sec(d).meanDF_total_tones=mean(deltaF_tones_IC_5sec,2);

            load([paths_2p{d},'reduced_data.mat'],'meanByTrial_early_10sec','meanByTrial_early_5sec','meanByTrial_early_2sec',...
                'dFByTrial_10sec','dFByTrial_5sec','dFByTrial_2sec','h_10sec','h_5sec','h_2sec');
            load([paths_2p{d},'tone_tuning.mat'],'TUNING_5sec','dFByTone_5sec','h_pass_5sec','TUNING_3sec','dFByTone_3sec','h_pass_3sec');
            allDates_calls_10sec(d).meanByTrial = meanByTrial_early_10sec;
            allDates_calls_5sec(d).meanByTrial = meanByTrial_early_5sec;
            allDates_calls_2sec(d).meanByTrial = meanByTrial_early_2sec;
            allDates_calls_10sec(d).h_calls= h_10sec;
            allDates_calls_5sec(d).h_calls= h_5sec;
            allDates_calls_2sec(d).h_calls= h_2sec;
            allDates_tones_5sec(d).toneTuning=TUNING_5sec;
            allDates_tones_5sec(d).dFByTone=dFByTone_5sec;
            allDates_tones_5sec(d).h_tone=h_pass_5sec;
            allDates_tones_3sec(d).toneTuning=TUNING_3sec;
            allDates_tones_3sec(d).dFByTone=dFByTone_3sec;
            allDates_tones_3sec(d).h_tone=h_pass_3sec;
            allDates_calls_10sec(d).dFByTrial=dFByTrial_10sec;
            allDates_calls_5sec(d).dFByTrial=dFByTrial_5sec;
            allDates_calls_2sec(d).dFByTrial=dFByTrial_2sec;
            allDates_tones_3sec(d).tones=TUNING_3sec(1).tones;
            allDates_tones_5sec(d).tones=TUNING_5sec(1).tones;
            allDates_tones_3sec(d).meanRTones=cat(1,TUNING_3sec(:).mean);
            allDates_tones_5sec(d).meanRTones=cat(1,TUNING_5sec(:).mean);
        end
    end


%%
    function MultiDayROIs=make_multiDayROIs_struct_calls(allDates,mapping)

        for d=1:length(allDates)
            % call responses
            meanResponsesTmp=cellfun(@(x)mean(x,1),allDates(d).dFByTrial,'un',0);
            meanResponses=cell(1,size(allDates(d).dFByTrial,2));
            SEMresponsesTmp=cellfun(@(x)std(x,[],1)/sqrt(size(x,1)),allDates(d).dFByTrial,'un',0);
            SEMresponses=cell(1,size(allDates(d).dFByTrial,2));

            for c=1:size(allDates(d).dFByTrial,2)
                meanResponses{c}=cat(1,meanResponsesTmp{:,c});
                SEMresponses{c}=cat(1,SEMresponsesTmp{:,c});
            end
            allDates(d).meanResponses=meanResponses;
            allDates(d).SEMresponses=SEMresponses;
        end


        for r=1:size(mapping,1)
            meanResponsesByDay=cell(1,size(mapping,2));
            SEMresponsesByDay=cell(1,size(mapping,2));


            meanByTrial=cell(1,size(mapping,2));
            meanR=zeros(6,size(mapping,2));
            semR=meanR;
            meanDF_total_calls=zeros(1,size(mapping,2));

            h_calls=zeros(1,size(mapping,2));

            meanCalls_Z(:,d)=zeros(6,1);




            for d=1:length(allDates)
                idx_ROI=mapping(r,d);
                if idx_ROI==0 || isempty(allDates(d).h_calls)
                    meanResponsesByDay{d}=[];
                    SEMresponsesByDay{d}=[];
                    meanByTrial{d}=[];
                    meanR(:,d)=nan(6,1);
                    semR(:,d)=nan(6,1);
                    meanDF_total_calls(d)=nan;
                    h_calls(d)=nan;
                    meanCalls_Z(:,d)=nan(6,1);
                    dFByTrial_calls{d}=[];



                    %                 elseif sum(sum(isnan(allDates(d).meanResponses{idx_ROI})))>0
                    %                     meanResponsesByDay{d}=[];
                    %                     SEMresponsesByDay{d}=[];
                    %                     meanByTrial{d}=[];
                    %                     meanR(:,d)=nan(6,1);
                    %                     meanDF_total_calls(d)=nan;
                    %                     h_calls(d)=nan;
                    %                     meanCalls_Z(:,d)=nan(6,1);


                else
                    meanResponsesByDay{d}=allDates(d).meanResponses{idx_ROI};
                    SEMresponsesByDay{d}=allDates(d).SEMresponses{idx_ROI};
                    meanByTrial{d}=allDates(d).meanByTrial(:,idx_ROI);
                    meanR(:,d)=cellfun(@mean,meanByTrial{d});
                    semR(:,d)=cellfun(@(x)std(x)/sqrt(length(x)),meanByTrial{d});
                    meanDF_total_calls(d)= allDates(d).meanDF_total_calls(idx_ROI);
                    h_calls(d)=sum(allDates(d).h_calls(idx_ROI,:));
                    dFByTrial_calls{d}=allDates(d).dFByTrial{:,idx_ROI}

                    % make zscored versions of mean responses
                    meanDF_calls=nanmean(meanR(:,d));
                    stdDF_calls = nanstd(meanR(:,d));
                    meanCalls_Z(:,d)= (meanR(:,d)-meanDF_calls)/stdDF_calls;
                end
            end

            MultiDayROIs(r).meanResponsesCalls=meanResponsesByDay;
            MultiDayROIs(r).SEMresponsesCalls=SEMresponsesByDay;

            MultiDayROIs(r).meanByTrial=meanByTrial;
            MultiDayROIs(r).meanR=meanR;
            MultiDayROIs(r).semR=semR;
            MultiDayROIs(r).meanDF_total_calls=meanDF_total_calls;
            MultiDayROIs(r).h_calls=h_calls;
            MultiDayROIs(r).meanCalls_Z=meanCalls_Z;
            MultIDayROIs(r).dFbyTrial=dFByTrial_calls;
        end
    end

%%

    function MultiDayROIs=make_multiDayROIs_struct_tones(allDates,mapping)

        for d=1:length(allDates)

            % tone responses
            meanResponsesToneTmp=cellfun(@(x)mean(x,1),allDates(d).dFByTone,'un',0);
            meanResponsesTone=cell(1,size(allDates(d).dFByTone,2));
            SEMresponsesToneTmp=cellfun(@(x)std(x,[],1)/sqrt(size(x,1)),allDates(d).dFByTone,'un',0);
            SEMresponsesTone=cell(1,size(allDates(d).dFByTone,2));

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
            meanByTrial=cell(1,size(mapping,2));

            meanToneByDay=cell(1,size(mapping,2));
            SEMToneByDay=cell(1,size(mapping,2));
            meanRTones=zeros(length(tones),size(mapping,2));
            semRTones=meanRTones;
            meanDF_total_tones=zeros(1,size(mapping,2));
            h_tones=zeros(1,size(mapping,2));
            meanTones_Z(:,d)=zeros(length(tones),1);



            for d=1:length(allDates)
                idx_ROI=mapping(r,d);
                if idx_ROI==0
                    meanByTrial{d}=[];
                    meanToneByDay{d}=[];
                    SEMToneByDay{d}=[];
                    meanRTones(:,d)=nan(length(tones),1);
                    semRTones(:,d)=nan(length(tones),1);
                    meanDF_total_tones(d)=nan;
                    h_tones(d)=nan;
                    meanTones_Z(:,d)=nan(length(tones),1);
                    dFByTrial{d}=[];

                elseif sum(sum(isnan(allDates(d).meanResponsesTone{idx_ROI})))>0
                    meanToneByDay{d}=[];
                    SEMToneByDay{d}=[];
                    meanRTones(:,d)=nan(length(tones),1);
                    semRTones(:,d)=nan(length(tones),1);
                    meanDF_total_tones(d)=nan;
                    h_tones(d)=nan;
                    meanTones_Z(:,d)=nan(length(tones),1);
                    dFByTrial{d}=[];
                else
                    meanToneByDay{d}=allDates(d).meanResponsesTone{idx_ROI};
                    SEMToneByDay{d}=allDates(d).SEMresponsesTone{idx_ROI};
                    tmpMeanRTones=allDates(d).meanRTones(idx_ROI,:)';
                    tmpSemTones=allDates(d).toneTuning(idx_ROI).std/sqrt(size(allDates(d).toneTuning(idx_ROI).dF{1},1));
                    dFbyTone=allDates(d).dFByTone(:,idx_ROI);                    
                    meanByTrialtmp=cellfun(@(x)mean(x(:,31:91),2),dFbyTone,'UniformOutput',false);


                    if length(tmpMeanRTones)>size(meanRTones,1)
                        meanByTrial{d}=meanByTrialtmp([1:3,5,7:8]);
                        meanRTones(:,d)=tmpMeanRTones([1:3,5,7:8]);
                        semRTones(:,d)=tmpSemTones([1:3,5,7:8]);
                    else
                        meanRTones(:,d)=tmpMeanRTones;
                        semRTones(:,d)=tmpSemTones;
                        meanByTrial{d}=meanByTrialtmp;
                    end
                    meanDF_total_tones(d)=allDates(d).meanDF_total_tones(idx_ROI);
                    h_tones(d)=sum(allDates(d).h_tone(idx_ROI,:));
                    dFbyTrial{d}=allDates(d).dFByTone{:,idx_ROI};
                    % make zscored versions of mean responses

                    meanDF_tones=nanmean(meanRTones(:,d));
                    stdDF_tones = nanstd(meanRTones(:,d));
                    meanTones_Z(:,d)= (meanRTones(:,d)-meanDF_tones)/stdDF_tones;
                end
            end


            MultiDayROIs(r).meanResponsesTones=meanToneByDay;
            MultiDayROIs(r).SEMresponsesTones=SEMToneByDay;
            MultiDayROIs(r).meanRTones=meanRTones;
            MultiDayROIs(r).semRTones=semRTones;
            MultiDayROIs(r).meanDF_total_tones=meanDF_total_tones;
            MultiDayROIs(r).h_tones=h_tones;
            MultiDayROIs(r).meanTones_Z=meanTones_Z;
            MultiDayROIs(r).meanByTrial=meanByTrial;
            MultiDayROIs(r).dFbyTrial=dFbyTrial;
        end
    end




% %% plot mean responses by day for each matched cell
%     function plot_meanDF_multiday(allDates_tones,allDates_calls,MultiDayROIs_tones,MultiDayROIs_calls)
%         % daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates_calls)-1,'un',0);
%         cmap=cool(length(allDates_calls)+1);
% 
%         tones=allDates_tones(1).tones;
%         % cmap=brewermap(length(allDates),'Spectral');
%         timeTones=((1:size(allDates_tones(1).dFByTone{1},2))-1*30)/30;
% 
%         timeplot=((1:size(allDates_calls(1).dFByTrial{1},2))-2*30)/30;
%         for r=1:length(MultiDayROIs_calls)
%             % set max Y for calls;
%             maxPlot=cellfun(@(x)nanmax(nanmax(x)),MultiDayROIs_calls(r).meanResponsesCalls,'un',0);
%             maxPlot=nanmax([maxPlot{:}]);
%             maxPlotCalls=maxPlot+3;
% 
%             % set max Y for this calls;
%             minPlot=cellfun(@(x)min(min(x)),MultiDayROIs_calls(r).meanResponsesCalls,'un',0);
%             minPlot=min([minPlot{:}]);
%             minPlotCalls=minPlot-3;
% 
%             % set max Y for tones;
%             maxPlot=cellfun(@(x)max(max(x)),MultiDayROIs_tones(r).meanResponsesTones,'un',0);
%             maxPlot=max([maxPlot{:}]);
%             maxPlotTones=maxPlot+3;
% 
%             % set max Y for this calls;
%             minPlot=cellfun(@(x)min(min(x)),MultiDayROIs_tones(r).meanResponsesTones,'un',0);
%             minPlot=min([minPlot{:}]);
%             minPlotTones=minPlot-3;
% 
%             fig=figure; hold on;
%             fig.Position=[73 113 1317 581];
%             annotation('textbox',[0.05 0.9 0.2 0.1],'String',['ROI ',num2str(r)],'EdgeColor','none');
%             for d=1:length(allDates_tones)
%                 if ~isempty(MultiDayROIs_calls(r).meanResponsesCalls{d})
%                     for c=1:6
%                         subplot(2,length(tones),c)
%                         hold on
%                         plot(timeplot,MultiDayROIs_calls(r).meanResponsesCalls{d}(c,:),'color',cmap(d,:))
%                         tmp=gca;
%                         tmp.YLim=[minPlotCalls maxPlotCalls];
%                         %                 axis square
%                         title(['call',num2str(c)])
%                     end
% 
%                     for c=1:length(tones)
%                         subplot(2,length(tones),c+length(tones))
%                         hold on
%                         plot(timeTones,MultiDayROIs_tones(r).meanResponsesTones{d}(c,:),'color',cmap(d,:))
%                         tmp=gca;
%                         tmp.YLim=[minPlotTones maxPlotTones];
%                         %                 axis square
%                         title(tones(c))
% 
%                     end
%                     %             legend(daylabels)
%                 else
%                 end
%             end
%         end
%     end
% 
% %% plot mean responses by day for each matched cell, multiple call ISIs
%     function plot_meanDF_calls_multiISI(allDates_calls_10sec,MultiDayROIs_calls_2sec,MultiDayROIs_calls_5sec,MultiDayROIs_calls_10sec)
%         % daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates_calls)-1,'un',0);
%         cmap=cool(length(allDates_calls_10sec)+1);
% 
% 
%         timeplot_10sec=((1:size(allDates_calls_10sec(1).dFByTrial{1},2))-2*30)/30;
%         timeplot_5sec=((1:size(allDates_calls_5sec(1).dFByTrial{1},2))-2*30)/30;
%         timeplot_2sec=((1:size(allDates_calls_2sec(end).dFByTrial{1},2))-1*30)/30;
%         for r=1:length(MultiDayROIs_calls_10sec)
%             days_idx=cellfun(@isempty,MultiDayROIs_calls_10sec(r).meanResponsesCalls);
%             days_idx=find(~days_idx);
% 
%             daylabels=arrayfun(@(x)['day ',num2str(x)],days_idx,'un',0);
%             % set max Y for calls;
%             maxPlot=cellfun(@(x)nanmax(nanmax(x)),MultiDayROIs_calls_10sec(r).meanResponsesCalls,'un',0);
%             maxPlot=nanmax([maxPlot{:}]);
%             maxPlot_10sec=maxPlot+3;
% 
%             % set max Y for this calls;
%             minPlot=cellfun(@(x)min(min(x)),MultiDayROIs_calls_10sec(r).meanResponsesCalls,'un',0);
%             minPlot=min([minPlot{:}]);
%             minPlot_10sec=minPlot-3;
% 
%             % set max Y for tones;
%             maxPlot=cellfun(@(x)max(max(x)),MultiDayROIs_calls_5sec(r).meanResponsesCalls,'un',0);
%             maxPlot=max([maxPlot{:}]);
%             maxPlot_5sec=maxPlot+3;
% 
%             % set max Y for this calls;
%             minPlot=cellfun(@(x)min(min(x)),MultiDayROIs_calls_5sec(r).meanResponsesCalls,'un',0);
%             minPlot=min([minPlot{:}]);
%             minPlot_5sec=minPlot-3;
% 
%             % set max Y for tones;
%             maxPlot=cellfun(@(x)max(max(x)),MultiDayROIs_calls_2sec(r).meanResponsesCalls,'un',0);
%             maxPlot=max([maxPlot{:}]);
%             maxPlot_2sec=maxPlot+3;
% 
%             % set max Y for this calls;
%             minPlot=cellfun(@(x)min(min(x)),MultiDayROIs_calls_2sec(r).meanResponsesCalls,'un',0);
%             minPlot=min([minPlot{:}]);
%             minPlot_2sec=minPlot-3;
% 
%             fig=figure; hold on;
%             fig.Position=[73 113 1317 581];
%             annotation('textbox',[0.05 0.9 0.2 0.1],'String',['ROI ',num2str(r)],'EdgeColor','none');
%             for d=days_idx %1:length(allDates_calls_5sec)
%                 %                 if ~isempty(MultiDayROIs_calls_10sec(r).meanResponsesCalls{d})
%                 for c=1:6
%                     subplot(3,6,c)
%                     hold on
%                     plot(timeplot_10sec,MultiDayROIs_calls_10sec(r).meanResponsesCalls{d}(c,:),'color',cmap(d,:))
%                     tmp=gca;
%                     tmp.YLim=[minPlot_10sec maxPlot_10sec];
%                     %                 axis square
%                     title(['call',num2str(c)])
%                 end
% 
%                 for c=1:6
%                     subplot(3,6,c+6)
%                     hold on
%                     plot(timeplot_5sec,MultiDayROIs_calls_5sec(r).meanResponsesCalls{d}(c,:),'color',cmap(d,:))
%                     tmp=gca;
%                     tmp.YLim=[minPlot_5sec maxPlot_5sec];
%                     %                 axis square
%                     title(['call',num2str(c)])
% 
%                 end
% 
%                 %                 else
%                 %                 end
%                 if ~isempty(MultiDayROIs_calls_2sec(r).meanResponsesCalls{d})
% 
%                     for c=1:6
%                         subplot(3,6,c+12)
%                         hold on
%                         plot(timeplot_2sec,MultiDayROIs_calls_2sec(r).meanResponsesCalls{d}(c,:),'color',cmap(d,:))
%                         tmp=gca;
%                         tmp.YLim=[minPlot_2sec maxPlot_2sec];
%                         %                 axis square
%                         title(['call',num2str(c)])
% 
%                     end
%                 end
% 
%             end
%             subplot(3,6,c+6)
%             legend(daylabels)
%         end
%     end

%% plot Zscored mean responses across days (colormap days)
%
% cmap=cool(length(allDates));
% for r=1:length(MultiDayROIs)
%     fig=figure; hold on
%     fig.Position=[71 72 378 581];
%     annotation('textbox',[0.05 0.9 0.2 0.1],'String',['ROI ',num2str(r)],'EdgeColor','none');
%
%     for d=1:length(allDates)
%         subplot(2,1,1)
%         hold on
%         plot(1:6,MultiDayROIs(r).meanCalls_Z(:,d),'-o','color',cmap(d,:))
%         title('mean response, total')
%         xlabel('calls')
%         ylabel('Z-scored mean dF/F')
%
%         subplot(2,1,2)
%         hold on
%         plot(1:length(tones),MultiDayROIs(r).meanTones_Z(:,d),'-o','color',cmap(d,:))
%         title('mean response, tones')
%         xlabel('days')
%         ylabel('Z-scored mean dF/F')
%         tmp=gca;
%         tmp.XTick=1:length(tones);
%         tmp.XTickLabel=tones;
%         legend(daylabels)
%     end
% end
% %% plot mean responses across days (colormap days)
%
% cmap=cool(length(allDates));
% for r=1:length(MultiDayROIs)
%     fig=figure; hold on
%     fig.Position=[71 72 378 581];
%     annotation('textbox',[0.05 0.9 0.2 0.1],'String',['ROI ',num2str(r)],'EdgeColor','none');
%
%     for d=1:length(allDates)
%         %         subplot(1,4,1)
%         %         hold on
%         %         plot(1:6,MultiDayROIs(r).meanEarly(:,d),'-o','color',cmap(d,:))
%         %         title('mean response, early')
%         %         xlabel('calls')
%         %         ylabel('mean dF/F')
%         %
%         %         subplot(1,4,2)
%         %         hold on
%         %         plot(1:6,MultiDayROIs(r).meanLate(:,d),'-o','color',cmap(d,:))
%         %         title('mean response, late')
%         %         xlabel('calls')
%         %         ylabel('mean dF/F')
%
%         subplot(2,1,1)
%         hold on
%         plot(1:6,MultiDayROIs(r).meanR(:,d),'-o','color',cmap(d,:))
%         title('mean response, total')
%         xlabel('calls')
%         ylabel('mean dF/F')
%
%         subplot(2,1,2)
%         hold on
%         plot(1:length(tones),MultiDayROIs(r).meanRTones(:,d),'-o','color',cmap(d,:))
%         title('mean response, tones')
%         xlabel('days')
%         ylabel('mean dF/F')
%         tmp=gca;
%         tmp.XTick=1:length(tones);
%         tmp.XTickLabel=tones;
%         legend(daylabels)
%     end
% end
%
% %% plot meanDF_total over days
%
% meanDF_total_calls=cat(1,MultiDayROIs(:).meanDF_total_calls);
% meanDF_total_tones=cat(1,MultiDayROIs(:).meanDF_total_tones);
%
% figure; hold on
% plot(1:length(allDates),meanDF_total_calls,'o-')
% title('calls')
%
% figure; hold on
% plot(1:length(allDates),meanDF_total_tones,'o-')
% title('tones')
%
%
% figure; hold on
% plotSpread(meanDF_total_calls,[],[],[],4)
% title('mean dF/F during call blocks')
% tmp=gca;
% tmp.XTickLabel=0:length(allDates)-1;
% xlabel('days of cohousing')
% ylabel('mean dF/F')
%
% figure; hold on
% plotSpread(meanDF_total_tones,[],[],[],4)
% title('mean dF/F during tone blocks')
% tmp=gca;
% tmp.XTickLabel=0:length(allDates)-1;
% xlabel('days of cohousing')
% ylabel('mean dF/F')
%
% daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates)-1,'un',0);
% cmap=morgenstemning(length(allDates)+1);
% figure; hold on
% for i=1:length(allDates)
%     tmp=cdfplot(meanDF_total_tones(:,i));
%     tmp.Color=cmap(i,:)
% end
% legend(daylabels);
% xlabel('mean dF/F, tone blocks')
% ylabel('fraction of ROIs')
% title('mean dF/F during tone blocks')
%
% daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates)-1,'un',0);
% cmap=morgenstemning(length(allDates)+1);
% figure; hold on
% for i=1:length(allDates)
%     tmp=cdfplot(meanDF_total_calls(:,i));
%     tmp.Color=cmap(i,:)
% end
% legend(daylabels);
% xlabel('mean dF/F, call blocks')
% ylabel('fraction of ROIs')
% title('mean dF/F during call blocks')
%
%
% %% number of response-evoking calls and tones by day
%
% responsive_calls=cat(1,MultiDayROIs(:).h_calls);
% responsive_tones=cat(1,MultiDayROIs(:).h_tones);
%
% figure; hold on
% plot(1:length(allDates),responsive_calls,'o-')
% title('calls')
%
% figure; hold on
% plot(1:length(allDates),responsive_tones,'o-')
% title('tones')
%
% %% look at best responses over days, best call
%
% bestCalls=zeros(length(MultiDayROIs), length(allDates));
% maxResponse=bestCalls;
% meanCall=maxResponse;
%
% bestTones=bestCalls;
% maxTones=bestCalls;
% meanTones=maxTones;
% for r=1:length(MultiDayROIs)
%     [maxes,bc]=max(MultiDayROIs(r).meanR);
%     bc(isnan(maxes))=nan;
%     bestCalls(r,:)=bc;
%     maxResponse(r,:)=maxes;
%     meanCall(r,:)=mean(MultiDayROIs(r).meanR);
%
%     [maxes,bc]=max(MultiDayROIs(r).meanRTones);
%     bc(isnan(maxes))=nan;
%     bestTones(r,:)=bc;
%     maxTones(r,:)=maxes;
%     meanTones(r,:)=mean(MultiDayROIs(r).meanRTones);
% end
%
% figure; hold on
% plot(1:length(allDates),maxResponse,'-')
% title('max call response')
% xlabel('days')
%
% figure; hold on
% plot(1:length(allDates),bestCalls,'-')
% title('best call')
% xlabel('days')
%
% figure; hold on
% plot(1:length(allDates),maxTones,'-')
% title('best tone response')
% xlabel('days')
%
% figure; hold on
% plot(1:length(allDates),bestTones,'-')
% title('best tone')
% xlabel('days')
% ylabel('tones')
% tmp=gca;
% tmp.YTickLabel=tones;
%
% figure; hold on
% plot(1:length(allDates),meanCall,'-')
% title('mean call response')
% xlabel('days')
%
% figure; hold on
% plot(1:length(allDates),meanTones,'-')
% title('mean tone response')
% xlabel('days')
%
% %% swarm plots of max responses over days
%
% figure;
% plotSpread(maxResponse,[],[],[],4);
% title('response to best call')
% xlabel('day of cohousing')
% ylabel('mean dF/F')
% tmp=gca;
% tmp.XTickLabel=0:(length(allDates)-1)
%
% figure;
% plotSpread(maxTones,[],[],[],4);
% title('response to best tone')
% xlabel('day of cohousing')
% ylabel('mean dF/F')
% tmp=gca;
% tmp.XTickLabel=0:(length(allDates)-1);
%
% figure;
% plotSpread(meanCall,[],[],[],4);
% title('mean call response')
% xlabel('day of cohousing')
% ylabel('mean dF/F')
% tmp=gca;
% tmp.XTickLabel=0:(length(allDates)-1);
%
% figure;
% plotSpread(meanTones,[],[],[],4);
% title('mean tone response')
% xlabel('day of cohousing')
% ylabel('mean dF/F')
% tmp=gca;
% tmp.XTickLabel=0:(length(allDates)-1);
%
% daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates)-1,'un',0);
% cmap=morgenstemning(length(allDates)+1);
% figure; hold on
% for i=1:length(allDates)
%     tmp=cdfplot(meanCall(:,i));
%     tmp.Color=cmap(i,:);
% end
% legend(daylabels);
% xlabel('mean dF/F')
% ylabel('fraction of ROIs')
% title('mean call response')
%
% cmap=morgenstemning(length(allDates)+1);
% figure; hold on
% for i=1:length(allDates)
%     tmp=cdfplot(meanTones(:,i));
%     tmp.Color=cmap(i,:);
% end
% legend(daylabels);
% xlabel('mean dF/F')
% ylabel('fraction of ROIs')
% title('mean Tone response')
%
% cmap=morgenstemning(length(allDates)+1);
% figure; hold on
% for i=1:length(allDates)
%     tmp=cdfplot(maxResponse(:,i));
%     tmp.Color=cmap(i,:);
% end
% legend(daylabels);
% xlabel('mean dF/F')
% ylabel('fraction of ROIs')
% title('max call response')
%
% cmap=morgenstemning(length(allDates)+1);
% figure; hold on
% for i=1:length(allDates)
%     tmp=cdfplot(maxTones(:,i));
%     tmp.Color=cmap(i,:);
% end
% legend(daylabels);
% xlabel('mean dF/F')
% ylabel('fraction of ROIs')
% title('max Tone response')
%
% %% compare first and last day
%
% figure; hold on
% plot(meanCall(:,1),meanCall(:,size(meanCall,2)),'ko')
% minPlot=min(min(meanCall));
% maxPlot=max(max(meanCall));
% plot([minPlot maxPlot],[minPlot maxPlot],'k:')
% xlabel('mean call response, day 0')
% ylabel('mean call response, last day')
% tmp=gca
% tmp.XLim=[minPlot maxPlot];
% tmp.YLim=[minPlot maxPlot];
% axis square
%
% figure; hold on
% plot(meanTones(:,1),meanTones(:,size(meanTones,2)),'ko')
% minPlot=min(min(meanTones));
% maxPlot=max(max(meanTones));
% plot([minPlot maxPlot],[minPlot maxPlot],'k:')
% xlabel('mean tone response, day 0')
% ylabel('mean tone response, last day')
% tmp=gca
% tmp.XLim=[minPlot maxPlot];
% tmp.YLim=[minPlot maxPlot];
% axis square
%
% figure; hold on
% plot(maxResponse(:,1),maxResponse(:,size(maxResponse,2)),'ko')
% minPlot=min(min(maxResponse));
% maxPlot=max(max(maxResponse));
% plot([minPlot maxPlot],[minPlot maxPlot],'k:')
% xlabel('best call response, day 0')
% ylabel('best call response, last day')
% tmp=gca
% tmp.XLim=[minPlot maxPlot];
% tmp.YLim=[minPlot maxPlot];
% axis square
%
% figure; hold on
% plot(maxTones(:,1),maxTones(:,size(maxTones,2)),'ko')
% minPlot=min(min(maxTones));
% maxPlot=max(max(maxTones));
% plot([minPlot maxPlot],[minPlot maxPlot],'k:')
% xlabel('best tone response, day 0')
% ylabel('best tone response, last day')
% tmp=gca
% tmp.XLim=[minPlot maxPlot];
% tmp.YLim=[minPlot maxPlot];
% axis square
%
% %% calculate correlations across days for tone tuning, call tuning for each ROI
%
% allCombs=nchoosek(1:length(allDates),2);
%
% meanCorrEarly=zeros(length(MultiDayROIs),1);
% meanCorrLate=meanCorrEarly;
% meanCorrCalls=meanCorrEarly;
% meanCorrTones=meanCorrCalls;
%
% % shuffled
% shuffCorrEarly=zeros(length(MultiDayROIs),1);
% shuffCorrLate=shuffCorrEarly;
% shuffCorrCalls=shuffCorrEarly;
% shuffCorrTones=shuffCorrCalls;
%
% % loop through ROIs
% for r=1:length(MultiDayROIs)
%     % preallocate vectors of correlations for each combo
%     corrEarly=zeros(size(allCombs,1),1);
%     corrLate=corrEarly;
%     corrR=corrEarly;
%     corrTones=corrEarly;
%
%     shuffEarly=zeros(size(allCombs,1),1);
%     shuffLate=shuffEarly;
%     shuffR=shuffEarly;
%     shuffTones=shuffEarly;
%
%     % loop through combos
%     for comb=1:size(allCombs,1)
%
%         early1=MultiDayROIs(r).meanEarly(:,allCombs(comb,1));
%         early2=MultiDayROIs(r).meanEarly(:,allCombs(comb,2));
%         corrTmp=corrcoef(early1,early2);
%         corrEarly(comb)=corrTmp(2);
%
%         late1=MultiDayROIs(r).meanLate(:,allCombs(comb,1));
%         late2=MultiDayROIs(r).meanLate(:,allCombs(comb,2));
%         corrTmp=corrcoef(late2,late1);
%         corrLate(comb)=corrTmp(2);
%
%         calls1=MultiDayROIs(r).meanR(:,allCombs(comb,1));
%         calls2=MultiDayROIs(r).meanR(:,allCombs(comb,2));
%         corrTmp=corrcoef(calls2,calls1);
%         corrR(comb)=corrTmp(2);
%
%         tones1=MultiDayROIs(r).meanRTones(:,allCombs(comb,1));
%         tones2=MultiDayROIs(r).meanRTones(:,allCombs(comb,2));
%         corrTmp=corrcoef(tones2,tones1);
%         corrTones(comb)=corrTmp(2);
%
%         % shuffled correlations
%         shuffEarly2=early2(randperm(length(early2)));
%         corrTmp=corrcoef(early1,shuffEarly2);
%         shuffEarly(comb)=corrTmp(2);
%
%         shuffLate2=late2(randperm(length(late2)));
%         corrTmp=corrcoef(late1,shuffLate2);
%         shuffLate(comb)=corrTmp(2);
%
%         shuffCalls2=calls2(randperm(length(calls2)));
%         corrTmp=corrcoef(calls1,shuffCalls2);
%         shuffR(comb)=corrTmp(2);
%
%         shuffTones2=tones2(randperm(length(tones2)));
%         corrTmp=corrcoef(tones1,shuffTones2);
%         shuffTones(comb)=corrTmp(2);
%
%     end
%
%     meanCorrEarly(r)=nanmean(corrEarly);
%     meanCorrLate(r)=nanmean(corrLate);
%     meanCorrCalls(r)=nanmean(corrR);
%     meanCorrTones(r)=nanmean(corrTones);
%
%     shuffCorrEarly(r)=nanmean(shuffEarly);
%     shuffCorrLate(r)=nanmean(shuffLate);
%     shuffCorrCalls(r)=nanmean(shuffR);
%     shuffCorrTones(r)=nanmean(shuffTones);
% end
%
% % cmap=brewermap(4,'dark2');
% % figure; hold on
% % % p(1)=cdfplot(meanCorrEarly);
% % % p(1).Color=cmap(1,:);
% % %
% % %
% % % p(2)=cdfplot(meanCorrLate);
% % % p(2).Color=cmap(2,:);
% %
% % p(3)=cdfplot(meanCorrCalls);
% % p(3).Color=cmap(3,:);
% %
% % p(4)=cdfplot(meanCorrTones);
% % p(4).Color=cmap(4,:);
% %
% % title('mean tuning correlation across days')
% % xlabel('corr coef')
% % ylabel('fraction of ROIs')
% % legend('calls, early','calls, late','calls','tones')
%
% cmap=brewermap(8,'Paired');
% figure; hold on
% p(1)=cdfplot(meanCorrEarly);
% p(1).Color=cmap(2,:);
% p(2)=cdfplot(shuffCorrEarly);
% p(2).Color=cmap(1,:);
% title('calls,early')
% legend('data','shuff')
%
% figure; hold on
% p(1)=cdfplot(meanCorrLate);
% p(1).Color=cmap(4,:);
% p(2)=cdfplot(shuffCorrLate);
% p(2).Color=cmap(3,:);
% title('calls,late')
% legend('data','shuff')
%
% figure; hold on
% p(1)=cdfplot(meanCorrCalls);
% p(1).Color=cmap(6,:);
% p(2)=cdfplot(shuffCorrCalls);
% p(2).Color=cmap(5,:);
% [h,pval]=ttest(meanCorrCalls,shuffCorrCalls)
% title('calls')
% legend('data','shuff')
% xlabel('correlation')
% ylabel('fraction of ROIs')
%
%
% figure; hold on
% p(1)=cdfplot(meanCorrTones);
% p(1).Color=cmap(8,:);
% p(2)=cdfplot(shuffCorrTones);
% p(2).Color=cmap(7,:);
% [h,pval]=ttest(meanCorrTones,shuffCorrTones)
% title('tones')
% legend('data','shuff')
% xlabel('correlation')
% ylabel('fraction of ROIs')
%
%
% figure; hold on
% p(1)=cdfplot(meanCorrCalls);
% p(1).Color=cmap(6,:);
% % p(2)=cdfplot(shuffCorrCalls);
% % p(2).Color=cmap(5,:);
%
% p(1)=cdfplot(meanCorrTones);
% p(1).Color=cmap(8,:);
% % p(2)=cdfplot(shuffCorrTones);
% % p(2).Color=cmap(7,:);
% title('mean correlation across days')
% legend('calls','tones')
% xlabel('correlation')
% ylabel('fraction of ROIs')
%
% figure; hold on
% plotSpread([meanCorrEarly,meanCorrLate,meanCorrCalls,meanCorrTones],[],[],{'calls, early','calls, late','calls','tones'},4)
% plot(1,nanmean(shuffCorrEarly),'go')
% plot(2,nanmean(shuffCorrLate),'go')
% plot(3,nanmean(shuffCorrCalls),'go')
% plot(4,nanmean(shuffCorrTones),'go')
% ylabel('mean correlation across days')
% %% sort ROIs by highest correlations across days
%
% [~,corr_idx_calls] = sort(meanCorrCalls,'ascend');
%
% MultiDayROIs_unsorted=MultiDayROIs;
% MultiDayROIs = MultiDayROIs(corr_idx_calls);
%
% [~,corr_idx_tones] = sort(meanCorrTones,'ascend');
% MultiDayROIs = MultiDayROIs_unsorted(corr_idx_tones);
%
% %% correlation of calls vs correlation of tone tuning
%
% figure; hold on
% plot(1:2,[meanCorrCalls,meanCorrTones],'ko-')
% plot(1:2,[shuffCorrCalls,shuffCorrTones],'go-')
%
% figure; hold on
% plot_scatterRLine(meanCorrTones,meanCorrCalls)
% xlabel('cross day corr, tone tuning')
% ylabel('cross day corr, call tuning')
%
end