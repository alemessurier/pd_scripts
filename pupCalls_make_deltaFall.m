function [deltaF_all] = pupCalls_make_deltaFall(F_calls,numFramesFilt,plotting)
%%
% plot raw dF/F traces of all ROIs

for d=1:numel(F_calls)

    allData=F_calls{d};
    fnames=arrayfun(@(x)x.name,allData,'un',0);
    repnums=cellfun(@(x)str2num(x(end-7:end-6)),fnames);
    numreps=unique(repnums);

    for r=1:length(numreps)
        fnames_thisRep=fnames(repnums==numreps(r));
        data_thisRep=allData(repnums==numreps(r));
        fOrder=cellfun(@(x)str2num(x(end-1:end)),fnames_thisRep);
        [fOrder,sortIdx]=sort(fOrder,'ascend');
        data_thisRep=data_thisRep(sortIdx);
        F_calls_sorted(d).FROI{r}=[data_thisRep(:).FROI];
        F_calls_sorted(d).Fneu{r}=[data_thisRep(:).Fneu];


        %make temporary struct for plotting
        data=F_calls_sorted(d).FROI{r};
        data_np=F_calls_sorted(d).Fneu{r};
        data_npcorr=data-0.7*data_np;
        deltaF_rep{r}=zeros(size(data));
        numCells=size(data,1);
        numFrames=size(data,2);
        stimFrames=150:150:numFrames;
        for i=1:numCells
            rawtrace=data(i,:);%_npcorr(i,:);
            filtF=slidingAvg_rawF( rawtrace,numFramesFilt,'median' );
            F_calls_sorted(d).filt_ROI{r}(i,:)=filtF;
            deltaF_rep{r}(i,:)  = deltaF_simple(filtF,0.5);
        end

samp_rate=30;
        switch plotting
            case 1
                figure
                spacing=2;

                plot_raw_deltaF( deltaF_rep{r},samp_rate,spacing,stimFrames )
                title('calls')
            case 0
        end
       
    end
    deltaF_loop{d}=cat(2,deltaF_rep{:});
end

deltaF_all=cat(2,deltaF_loop{:});
 samp_rate=30;
        switch plotting
            case 1
                figure
                spacing=2;

                plot_raw_deltaF( deltaF_all,samp_rate,spacing,stimFrames )
            case 0
        end
end