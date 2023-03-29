function pupCalls_plotTuning_tones(dFByTone,tones,h_tone)


numtones=size(dFByTone,1);
numcells=size(dFByTone,2);
lin_idx_plot=1:(2*numtones);
lin_idx_plot=reshape(lin_idx_plot,numtones,2);
lin_idx_plot=lin_idx_plot';

% figure
for c=1:numcells
    %     figure
    figure;
    combine=[];
    %first plot passive tuning mean dF/F
    for f=1:numtones
        numtrials = size(dFByTone{f,c},1);
        plot_mean=lin_idx_plot(1,f);
        subplot(2,numtones,plot_mean);
        timeplot=((1:size(dFByTone{f,c},2))-30)/30;

        shadedErrorBar(timeplot,mean(dFByTone{f,c},1), std(dFByTone{f,c},[],1)./sqrt(numtrials),'-k');%,1);
        hold on
        vline(0,'k:')
        title(num2str(tones(f)/1000));

        plot_dF=lin_idx_plot(2,f);
        subplot(2,numtones,plot_dF);
        imagesc(dFByTone{f,c});%,[-20 30])
        colormap gray
        combine = [combine; mean(dFByTone{f,c},1)];
    end



    ymax = max(combine(:));
    ymin=min(combine(:));
    if ~isnan(ymin) && ~isnan(ymax)
        for f=1:numtones
            plot_mean=lin_idx_plot(1,f);
            subplot(2,numtones,plot_mean);

            if h_tone(c,f) == 1
                COLOR = 'r:';
            else
                COLOR = 'k:';
            end
            vline(0,COLOR);
            ylim([ymin-5 ymax+5]);
            xlim([-1 2]);
            hold off
        end

        %     for f = 1:length(tones_behave)
        %
        %                 if h_all(c,f) == 1
        %                     COLOR = 'r:';
        %                 else
        %                     COLOR = 'k:';
        %                 end
        %        idx_tone=idx_match(f);
        %         plot_mean=lin_idx_plot(1,idx_tone);
        %         subplot(3,numtones,plot_mean);
        %
        %         vline(0,'k:')


        %          hold off;
        %         if f == round(numtones./2)
        %             title(['cell: ' num2str(c)]);
        %         end

        %     end
        %
        %     while waitforbuttonpress ~= 0
        %     end
    else
    end
    fig=gcf;
    fig.Position=[150 378 1212 420];
    ann=annotation('textbox',[ 0 0.9 0.3 0.1],'string',['cell ',num2str(c)]);
    ann.EdgeColor='none';
end