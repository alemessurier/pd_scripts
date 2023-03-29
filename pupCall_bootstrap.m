function bootDist=pupCall_bootstrap(Fcell,dFByTrial,numBoots,samp_rate,bl_length,frames_evoked)

Fcell_sample=Fcell;%reshape(Fcell,size(Fcell,1),size(Fcell,2)*size(Fcell,3));
numcells=size(Fcell_sample,1);
numReps=size(dFByTrial{1},1);
bl_length=bl_length*samp_rate;
ev_length=4*samp_rate;

framesToSample = 1:size(Fcell_sample,2);
framesToSample = framesToSample((bl_length+1):(end-ev_length-1));
bootDist=zeros(numcells,numBoots);
for cell=1:numcells
    trace=Fcell_sample(cell,:);
    parfor t=1:numBoots 
        bootFrames=randsample(framesToSample,numReps);
        evBoot=zeros(numReps,1);
        for e=1:numReps
            frame=bootFrames(e);
            F0=mean(trace((frame-bl_length):(frame-1)));
          F=trace((frame-bl_length):(frame+ev_length));
          dF=100*((F-F0)/F0);
          evBoot(e)=mean(dF(frames_evoked));
            
        end
        bootDist(cell,t)=mean(evBoot);
    end
%     figure;
% histogram(bootDist(cell,:))

end



end            