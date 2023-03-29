function [deltaF_all] = tones_make_deltaFall(F_byToneRep,numFramesFilt,plotting,samp_rate)
%%
% plot raw dF/F traces of all ROIs

    fnames=arrayfun(@(x)x.name,F_byToneRep,'un',0);
%     repnums=cellfun(@(x)str2num(x(end-7:end-6)),fnames);
    numreps=length(fnames);

    for r=1:numreps
        

        %make temporary struct for plotting
        data=F_byToneRep(r).FROI;
        data_np=F_byToneRep(r).Fneu;
        data_npcorr=data-0.7*data_np;
        deltaF_rep{r}=zeros(size(data));
        numCells=size(data,1);
        numFrames=size(data,2);
        stimFrames=3*samp_rate:3*samp_rate:numFrames;
        for i=1:numCells
            rawtrace=data(i,:);%_npcorr(i,:);
            filtF=slidingAvg_rawF( rawtrace,numFramesFilt,'median' );
            F_byToneRep(r).filt_ROI(i,:)=filtF;
            deltaF_rep{r}(i,:)  = deltaF_simple(filtF,0.5);
        end

        switch plotting
            case 1
                figure
                spacing=2;

                plot_raw_deltaF( deltaF_rep{r},samp_rate,spacing,stimFrames )
                title('tones')
            case 0
        end
       
    end
    


deltaF_all=cat(2,deltaF_rep{:});
        switch plotting
            case 1
                figure
                spacing=2;

                plot_raw_deltaF( deltaF_all,samp_rate,spacing,stimFrames )
            case 0
        end
end