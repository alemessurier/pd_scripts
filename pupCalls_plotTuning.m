function pupCalls_plotTuning(dFByTrial,h,sampRate)

numcells = size(dFByTrial,2);
numcalls = size(dFByTrial,1);
lin_idx_plot=1:(2*numcalls);
lin_idx_plot=reshape(lin_idx_plot,numcalls,2);
lin_idx_plot=lin_idx_plot';
trials='all';

for c=1:numcells
    fig=figure; hold on
    fig.Position=[604 353 1413 420];
    %% plot behavior responses to tones 
     combine = [];
     combine_std=[];
    for f = 1:numcalls
        numtrials = size(dFByTrial{f,c},1); 
        plot_mean=lin_idx_plot(1,f);
        subplot(2,numcalls,plot_mean); 
                timeplot=((1:size(dFByTrial{f,c},2))-2*sampRate)/sampRate;

        shadedErrorBar(timeplot,mean(dFByTrial{f,c},1), std(dFByTrial{f,c},[],1)./sqrt(numtrials));
        hold on
%         vline(0)
        title(['call ',num2str(f)]);
        
         plot_dF=lin_idx_plot(2,f);
        subplot(2,numcalls,plot_dF);
        imagesc(dFByTrial{f,c});%,[-20 30])
        colormap gray
       
        combine = [combine; mean(dFByTrial{f,c})']; 
        combine_std=[combine_std; std(dFByTrial{f,c})']; 
    end
    ymax = max(combine)+5;%max(combine_std);
    ymin=min(combine)-2;%(combine_std);
        
    if ~isnan(ymin) && ~isnan(ymax)
     % include y axis, yticks on leftmost plot
        plot_idx=lin_idx_plot(1,1);
        subplot(2,numcalls,plot_idx);
        ylim([ymin ymax]);
%         xlim([-1 2]);
        
          if h(c,1) == 1
            COLOR = 'r:';
        else
            COLOR = 'k:';
        end
        vline(0,COLOR)
%         vline(0,'r:');
        tmp=gca;
        tmp.Box='off';
%         tmp.XTickLabel=[];
        tmp.XAxisLocation='origin';
        
        
        
        for f=2:numcalls
            plot_idx=lin_idx_plot(1,f);
            subplot(2,numcalls,plot_idx);
            ylim([ymin ymax]);
%             xlim([-1 2]);
            
            if h(c,f) == 1
                COLOR = 'r:';
            else
                COLOR = 'k:';
            end
            vline(0,COLOR)
%             vline(0,'r:');
            tmp=gca;
            tmp.Box='off';
%             tmp.XTickLabel=[];
            tmp.YTick=[];
            tmp.XAxisLocation='origin';
            tmp.YColor='none';
        end
    ann=annotation('textbox',[ 0 0.9 0.3 0.1],'string',['cell ',num2str(c)]);
        ann.EdgeColor='none';
    else
    end

end
