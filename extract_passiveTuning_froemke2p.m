function [TUNING,dFByTone,h_tone,p_tone,tones] = extract_passiveTuning_froemke2p(filtF,stimFrames,freq_path,samp_rate)


numcells=size(filtF,1);
tones_rep = dlmread(freq_path);
tones = tones_rep(1:17);
tones=sort(tones,'ascend');
tones_rep=tones_rep(1:length(stimFrames));
dFByTone=cell(numcells,length(tones));
h_tone=zeros(numcells,length(tones));
p_tone=h_tone;
for c=1:numcells
    filtF_thisCell=filtF(c,:);
   
    for f=1:length(tones)
        thisTone=tones(f);
        idx=tones_rep==thisTone;
        stimFrames_thistone=stimFrames(idx);
        clear dF;
        clear F0;
        clear stim;
        for s=1:length(stimFrames_thistone)
            sf=stimFrames_thistone(s);
            bl_start=sf-ceil(samp_rate);
            bl_end=sf-1;
            start=sf+1;
            stop=sf+2*(ceil(samp_rate));
        F0(s)=mean(filtF_thisCell(bl_start:bl_end));
        stim(s)=mean(filtF_thisCell(start:stop));
        dF(s,:)=(filtF_thisCell(bl_start:stop)-F0(s))/F0(s);
        end
        dF=dF*100;
        [h_tone(c,f),p_tone(c,f)]=ttest(F0,stim,'tail','left');
        
        dFByTone{c,f}=dF;
        TUNING(c).mean(f) = mean(mean(dF(:,5:8)));
        TUNING(c).std(f)  = std(mean(dF(:,5:8)));
        TUNING(c).med(f)  = median(mean(dF(:,5:8)));
        TUNING(c).max(f)  = max(mean(dF(:,5:8)));
        TUNING(c).dF{f}=dF;
    end
        TUNING(c).tones=tones;

    
end