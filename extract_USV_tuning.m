function [dFByTrial,h,p] = extract_USV_tuning(Fcell,stimFrames,samp_rate,bl_length,postStim_length)

numstims=length(stimFrames);
numcells=size(Fcell{1},1);
numreps=size(Fcell,2);
% stimFrames=stimFrames()
bl_start=stimFrames-bl_length*round(samp_rate)+1;
bl_end=stimFrames-1;
ev_end=stimFrames+postStim_length*round(samp_rate);
start=stimFrames+1; %frame to start "evoked" period for ttest;
stop=stimFrames+postStim_length*round(samp_rate); %frame to end "evoked period for ttest;
dFByTrial=cell(1,numcells);
h=zeros(1,numcells);
p=h;

for c=1:numcells
    clear dF
    dF=cell(numreps,1);
    for r=1:numreps
        F_thisCell=Fcell{r}(c,:);
        idx_stimUse=(stimFrames+postStim_length*round(samp_rate))<length(F_thisCell); % only use stims that occur within the length of this rep
        stimFrames_use=stimFrames(idx_stimUse);
        bl_start_use=bl_start(idx_stimUse);
        bl_end_use=bl_end(idx_stimUse);
        start_use=start(idx_stimUse);
        stop_use=stop(idx_stimUse);
        F0=zeros(length(stimFrames_use),1);

        stim=F0;
        
        for t=1:length(stimFrames_use)
            F0(t)=mean(F_thisCell(bl_start_use(t):bl_end_use(t)));
            
            stim(t)=mean(F_thisCell(start_use(t):stop_use(t)));
            %
            dF{r}(t,:)=(F_thisCell(bl_start_use(t):stop_use(t))-F0(t))./F0(t);
            
        end
    end
    dF=cat(1,dF{:});
    dF=dF*100;
    dFByTrial{c}=dF;
    [h(c),p(c)]=ttest(F0,stim,'tail','both');
end
end