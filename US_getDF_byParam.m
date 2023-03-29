function [deltaF, deltaF_struct,F_byFile,DCs,MPa,ops] = US_getDF_byParam(path_2p)

[F_byFile,DCs,MPa,ops]=US_load2p_data(path_2p);

DC=unique(DCs);
pr=unique(MPa);
fnames=arrayfun(@(x)x.name,F_byFile,'un',0);

for p=1:length(pr)
    idx_p=find(MPa==pr(p) & DCs=='50');

    Fs=F_byFile(idx_p);
     fns_thisPr=fnames(idx_p);
    
    %make sure files are in chronological order
    numFile2p=cellfun(@(x)str2double(x(end-1:end)),fns_thisPr);
    [~,order]=sort(numFile2p,'ascend');
    fns_thisPr=fns_thisPr(order);
    idx_p=idx_p(order);
    
    %concatenate FROI and Fneu
    FROI_sess=arrayfun(@(x)x.FROI,F_byFile(idx_p),'un',0);
   
    Fneu_sess=arrayfun(@(x)x.Fneu,F_byFile(idx_p),'un',0);
    deltaF=cell(1,numel(FROI_sess));
    filtF_raw_all=deltaF;
    for F=1:numel(FROI_sess)
        % process imaging data
        F_corrected=FROI_sess{F}-0.3*(Fneu_sess{F}); %neuropil subtraction
        % filter data w/moving median filter
        filtF_corr=zeros(size(F_corrected));
        filtF_raw=filtF_corr;
        deltaF{F}=filtF_corr;
        for i=1:size(filtF_corr,1)
            filtF_corr(i,:) = slidingAvg_rawF( F_corrected(i,:),5,'median' );
            filtF_raw(i,:) = slidingAvg_rawF( FROI_sess{F}(i,:),5,'median' );
            deltaF{F}(i,:) = deltaF_simple(filtF_raw(i,:));
        end
        filtF_raw_all{F}=filtF_raw;
    end
% calculate dF/F from raw image traces
filtF_raw_all=cat(2,filtF_raw_all{:});
deltaF_struct=deltaF_suite2p(filtF_raw_all);
samp_rate=ops.fs;

deltaF=cat(3,deltaF{:});
mean_dF=mean(deltaF,3);
figure; hold on
imagesc(mean_dF);
    colormap gray
   title(string(pr(p)))
    plot_deltaF( deltaF_struct,samp_rate,1,size(filtF_raw_all,1),0.75 )    
    stims=5:25:(size(filtF_raw_all,2)/30);
    vline(stims)
end