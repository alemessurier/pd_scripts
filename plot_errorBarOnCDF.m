function [mean_handle,error_handle]=plot_errorBarOnCDF(cdf_handle,distPlot,colorPlot)

m=mean(distPlot);
e=std(distPlot)/sqrt(length(distPlot));

% get percentile of mean distPlot relative to plotted CDF
cdf_ordered=sort(cdf_handle.XData,'ascend');
[~,tmpidx]=find(cdf_handle.XData<=m);
    tmpidx=max(tmpidx);
    p_low=cdf_handle.YData(tmpidx);

    [~,tmpidx]=find(cdf_handle.XData>=m);
    tmpidx=min(tmpidx);
    p_high=cdf_handle.YData(tmpidx);
percentile_m=mean([p_low,p_high]);

% get percentile of distPlot individual points relative to plotted CDF
y_vals=zeros(1,length(distPlot));
for i=1:length(distPlot)
    [~,tmpidx]=find(cdf_handle.XData==distPlot(i));
    tmpidx=max(tmpidx);
    y_vals(i)=cdf_handle.YData(tmpidx);%sum(cdf_ordered<=distPlot(i))/length(cdf_ordered);
end
data_handle=plot(distPlot,y_vals,'o','Color',colorPlot);
mean_handle=plot(m,percentile_m,'o','Color',colorPlot,'MarkerSize',10,'MarkerFaceColor',colorPlot);
error_handle=errorbar(m,percentile_m,e,'horizontal','LineWidth',1.5,'Color',colorPlot);