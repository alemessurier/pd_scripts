function [P,responsiveTrials,bootDist]=pupCall_sigTest_allCalls(meanByTrial,Fcell,dFByTrial,numBoots,bl_length,ev_length,samp_rate)

% make bootstrapped null distribution for each cell
% samp_rate=30;
bootDist=pupCall_bootstrap(Fcell,dFByTrial,numBoots,samp_rate,bl_length,ev_length);

% get mean dF/F for each roi/call
numcells=length(dFByTrial);
meanByCell=mean(meanByTrial,1);
responsiveTrials=zeros(size(meanByTrial));
P=zeros(numcells,1);
for c=1:numcells
    bootDist_thisCell=[bootDist(c,:),meanByCell(c)];
    % get 95% value from boot distribution
    bootDist_thisCell=sort(bootDist_thisCell,'ascend');
    sig_val=bootDist_thisCell(0.95*numBoots);
    P(c)=sum(bootDist_thisCell>meanByCell(c))/length(bootDist_thisCell);
%     figure; hold on
%  histogram(bootDist(c,:))
% vline(meanByCell(c))

    % find trials w/responses>95% of boot distribution
    trialsThisCall=meanByTrial(:,c);
    responsiveTrials(:,c)=trialsThisCall>sig_val;

end