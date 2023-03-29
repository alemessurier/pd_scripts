function plot_meanDF_multiday(allDates_tones,allDates_calls,MultiDayROIs_tones,MultiDayROIs_calls)
% plot mean responses by day for each matched cell

% daylabels=arrayfun(@(x)['day ',num2str(x)],0:length(allDates_calls)-1,'un',0);
cmap=cool(length(allDates_calls)+1);

tones=allDates_tones(1).tones;
% cmap=brewermap(length(allDates),'Spectral');
timeTones=((1:size(allDates_tones(1).dFByTone{1},2))-1*30)/30;

timeplot=((1:size(allDates_calls(1).dFByTrial{1},2))-2*30)/30;
for r=1:length(MultiDayROIs_calls)
    % set max Y for calls;
    maxPlot=cellfun(@(x)nanmax(nanmax(x)),MultiDayROIs_calls(r).meanResponsesCalls,'un',0);
    maxPlot=nanmax([maxPlot{:}]);
    maxPlotCalls=maxPlot+3;

    % set max Y for this calls;
    minPlot=cellfun(@(x)min(min(x)),MultiDayROIs_calls(r).meanResponsesCalls,'un',0);
    minPlot=min([minPlot{:}]);
    minPlotCalls=minPlot-3;

    % set max Y for tones;
    maxPlot=cellfun(@(x)max(max(x)),MultiDayROIs_tones(r).meanResponsesTones,'un',0);
    maxPlot=max([maxPlot{:}]);
    maxPlotTones=maxPlot+3;

    % set max Y for this calls;
    minPlot=cellfun(@(x)min(min(x)),MultiDayROIs_tones(r).meanResponsesTones,'un',0);
    minPlot=min([minPlot{:}]);
    minPlotTones=minPlot-3;

    fig=figure; hold on;
    fig.Position=[73 113 1317 581];
    annotation('textbox',[0.05 0.9 0.2 0.1],'String',['ROI ',num2str(r)],'EdgeColor','none');
    for d=1:length(allDates_tones)
        if ~isempty(MultiDayROIs_calls(r).meanResponsesCalls{d}) && ~isnan(minPlotCalls)
            for c=1:6
                subplot(2,length(tones),c)
                hold on
%                 shadedErrorBar(timeplot,MultiDayROIs_calls(r).meanResponsesCalls{d}(c,:),MultiDayROIs_calls(r).SEMresponsesCalls{d}(c,:),{'-','color',cmap(d,:)},1)
                plot(timeplot,MultiDayROIs_calls(r).meanResponsesCalls{d}(c,:),'-','color',cmap(d,:))
                tmp=gca;
                tmp.YLim=[minPlotCalls maxPlotCalls];
                              axis square
                title(['call',num2str(c)])
            end

            if ~isempty(MultiDayROIs_tones(r).meanResponsesTones{d})

                for c=1:length(tones)
                    subplot(2,length(tones),c+length(tones))
                    hold on
%                     shadedErrorBar(timeTones,MultiDayROIs_tones(r).meanResponsesTones{d}(c,:),MultiDayROIs_tones(r).SEMresponsesTones{d}(c,:),{'-','color',cmap(d,:)},1)
plot(timeTones,MultiDayROIs_tones(r).meanResponsesTones{d}(c,:),'-','color',cmap(d,:))
                    tmp=gca;
                    tmp.YLim=[minPlotTones maxPlotTones];
                                axis square
                    title(tones(c))

                end
            end
            %             legend(daylabels)
        else
        end
    end
end
end