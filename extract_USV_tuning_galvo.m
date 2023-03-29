function [dFByTrial,h,p] = extract_USV_tuning_galvo(Fcell,stimFrames,samp_rate)

numreps=length(stimFrames);
numcells=size(Fcell,1);
maxFrames=size(Fcell,2)-4*round(samp_rate);
stimFrames=stimFrames(stimFrames<maxFrames)
bl_start=stimFrames-2*round(samp_rate);
bl_end=stimFrames-1;
ev_end=stimFrames+4*round(samp_rate);
start=stimFrames+1; %frame to start "evoked" period for ttest;
stop=stimFrames+4*round(samp_rate); %frame to end "evoked period for ttest;
dFByTrial=cell(1,numcells);
h=zeros(1,numcells);
p=h;
for c=1:numcells
    F_thisCell=Fcell(c,:);
    F0=zeros(length(stimFrames),1);
    stim=F0;
    clear dF
    for t=1:length(stimFrames)
        F0(t)=mean(F_thisCell(bl_start(t):bl_end(t)));
           
        stim(t)=mean(F_thisCell(start(t):stop(t)));
%       
        dF(t,:)=(F_thisCell(bl_start(t):ev_end(t))-F0(t))./F0(t);
        
    end
    dF=dF*100;
        dFByTrial{c}=dF;
      [h(c),p(c)]=ttest(F0,stim,'tail','both');
    clear dF
end
