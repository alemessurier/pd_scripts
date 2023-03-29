function F_calls_sorted = pupCall_pipeline_sort_F_tones(F_tones,numFramesFilt,stimISI,plotting)

%%
% plot raw dF/F traces of all ROIs
deltaF=[];
stimFrames_all=[];

allData=F_tones;
fnames=arrayfun(@(x)x.name,allData,'un',0);
repnums=cellfun(@(x)str2num(x(end-7:end-6)),fnames);
numreps=unique(repnums);

for r=1:length(numreps)
    fnames_thisRep=fnames(repnums==numreps(r));
    data_thisRep=allData(repnums==numreps(r));
    fOrder=cellfun(@(x)str2num(x(end-1:end)),fnames_thisRep);
    [fOrder,sortIdx]=sort(fOrder,'ascend');
    data_thisRep=data_thisRep(sortIdx);
    F_calls_sorted.FROI{r}=[data_thisRep(:).FROI];
    F_calls_sorted.Fneu{r}=[data_thisRep(:).Fneu];
        F_calls_sorted.spikes{r}=[data_thisRep(:).spikes];


    %make temporary struct for plotting
    data=F_calls_sorted.FROI{r};
    data_np=F_calls_sorted.Fneu{r};
    data_npcorr=data-0.7*data_np;
    deltaF_all=zeros(size(data));
    numCells=size(data,1);
    numFrames=size(data,2);
    stimFrames=stimISI:stimISI:numFrames;
    for i=1:numCells
        rawtrace=data(i,:);%_npcorr(i,:);
        filtF=slidingAvg_rawF( rawtrace,numFramesFilt,'median' );
        F_calls_sorted.filt_ROI{r}(i,:)=filtF;
        deltaF_all(i,:)  = deltaF_simple(filtF,0.5);
    end


    samp_rate=30;
    switch plotting
        case 1
            figure
            spacing=2;

            plot_raw_deltaF( deltaF_all,samp_rate,spacing,stimFrames )

            figure
                spacing=200;

                plot_raw_deltaF( F_calls_sorted.spikes{r},samp_rate,spacing,stimFrames )
                title('spikes')
        case 0
    end
end

