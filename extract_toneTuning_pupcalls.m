function [TUNING,dFByTone,h_pass,p_pass] = extract_toneTuning_pupcalls(filtF,repLength,stimFrames,freq_path,samp_rate)

numreps=length(filtF);
numcells=size(filtF{1},1);
tones = dlmread(freq_path);
numtones = length(unique(tones(3:end)));
tones = tones(3:3+numtones-1);
[tones,idx]=sort(tones,'ascend');
stimFrames=stimFrames(idx);
bl_start=stimFrames-samp_rate;
bl_end=stimFrames-1;
ev_end=stimFrames+2*samp_rate;
start=stimFrames+1; %frame to start "evoked" period for ttest;
stop=stimFrames+2*samp_rate; %frame to end "evoked period for ttest;
dFByTone=cell(length(tones),numcells);
h_pass=zeros(numcells,length(tones));
p_pass=h_pass;
for c=1:numcells
    filtF_thisCell=cellfun(@(x)x(c,1:repLength),filtF,'un',0);
    filtF_thisCell=cat(1,filtF_thisCell{:});
    for f=1:length(tones)
%         trials=size(filtF_thisCell,1);
%         for t = 1:(trials)               % looks at each column (a trial) and normalizes to respective baseline
%             clear baseline stim
%             baseline = mean(filtF_thisCell(t,bl_start(f):bl_end(f)),2);     % find baseline trace
%             
%             
%             % if baseline is negative (over-corrected by np subtraction), add mean
%             if baseline<0
%                 filtF_thisCell(t,:)=filtF_thisCell(t,:) + abs(baseline)+0.1;
%                
%             end
%            
%         end
        F0=mean(filtF_thisCell(:,bl_start(f):bl_end(f)),2);
        stim=mean(filtF_thisCell(:,start(f):stop(f)),2);
        [h_pass(c,f),p_pass(c,f)]=ttest(F0,stim,'tail','both');
        dF=bsxfun(@minus,filtF_thisCell(:,bl_start(f):ev_end(f)),F0)./F0;
        dF=dF*100;
        dFByTone{f,c}=dF;
        TUNING(c).mean(f) = mean(mean(dF(:,32:50)));
        TUNING(c).std(f)  = std(mean(dF(:,32:50)));
        TUNING(c).med(f)  = median(mean(dF(:,32:50)));
        TUNING(c).max(f)  = max(mean(dF(:,32:50)));
        TUNING(c).dF{f}=dF;
    end
    TUNING(c).tones=tones;
    
end