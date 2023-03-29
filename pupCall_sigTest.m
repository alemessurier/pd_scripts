function [P,responsiveTrials,bootDist]=pupCall_sigTest(meanByTrial,Fcell,dFByTrial,numBoots,bl_length,frames_evoked,samp_rate)

% make bootstrapped null distribution for each cell
% samp_rate=30;
bootDist=pupCall_bootstrap(Fcell,dFByTrial,numBoots,samp_rate,bl_length,frames_evoked);

% get mean dF/F for each roi/call
numcells=size(dFByTrial,2);
numCalls=size(dFByTrial,1);
meanByCall=cellfun(@(x)mean(x,1),meanByTrial);
figure; imagesc(meanByCall)

responsiveTrials=cell(size(meanByTrial));
P=zeros(numcells,numCalls);
for c=1:numcells
    bootDist_thisCell=bootDist(c,:);
    % get 95% value from boot distribution
    bootDist_thisCell=sort(bootDist_thisCell,'ascend');
    sig_val=bootDist_thisCell(0.95*numBoots);
    for i=1:numCalls
        % get P values for evoked==mean boot for this call
        bootDist_call=[bootDist_thisCell,meanByCall(i,c)];
        bootDist_call=sort(bootDist_call,'ascend');
        P(c,i)=sum(bootDist_call>meanByCall(i,c))/length(bootDist_call);
%         figure; hold on
       
       % find trials w/responses>95% of boot distribution
       trialsThisCall=meanByTrial{i,c};
       responsiveTrials{i,c}=trialsThisCall>sig_val;
    end
end