function pupCalls_plotAllTrials_ordered(F_calls,ops,numFramesFilt,stimISI,bl_length,postStim_length)


F_calls_sorted = pupCall_pipeline_sort_F_calls(F_calls,numFramesFilt,stimISI,0);
samp_rate=ops.fs;

% dFByTrial for first 3 calls in order played
Fcell=F_calls_sorted(1).filt_ROI;
stimFrames=(stimISI:stimISI:size(Fcell{1},2))+0.5*samp_rate;
stimFrames=stimFrames(1:end-2);
[dFByTrial_71b,h(1,:),p(1,:)] = extract_USV_tuning(Fcell,stimFrames,samp_rate,bl_length,postStim_length);

% dFByTrial for last 3 calls in order played
Fcell=F_calls_sorted(2).filt_ROI;
    stimFrames=stimISI:stimISI:size(Fcell{1},2);
    stimFrames=stimFrames(1:end-2);
    [dFByTrial_j1a,h(1,:),p(1,:)] = extract_USV_tuning(Fcell,stimFrames,samp_rate,bl_length,postStim_length);

% make plot

for i=1:length(dFByTrial_71b)
    % first 3 pup calls 
    thisCell=dFByTrial_71b{i};
  figure; hold on

            subplot(2,2,1)
            timeplot=((1:size(thisCell,2))-bl_length*samp_rate)/samp_rate;

            shadedErrorBar(timeplot,mean(thisCell,1), std(thisCell,[],1)./sqrt(size(thisCell,1)));
            hold on
           
                     vline(0,'r:');
            tmp=gca;
            tmp.Box='off';
            %         tmp.XTickLabel=[];
            tmp.XAxisLocation='origin';
            axis square
            title('calls 1-3')

            subplot(2,2,3)
            imagesc(thisCell);
            colormap gray
            axis square
    
      % second 3 pup calls      
      thisCell=dFByTrial_j1a{i};
            subplot(2,2,2)
            timeplot=((1:size(thisCell,2))-bl_length*samp_rate)/samp_rate;

            shadedErrorBar(timeplot,mean(thisCell,1), std(thisCell,[],1)./sqrt(size(thisCell,1)));
            hold on
                 vline(0,'r:');
            tmp=gca;
            tmp.Box='off';
            %         tmp.XTickLabel=[];
            tmp.XAxisLocation='origin';
            axis square
            title('calls 4-6')

            subplot(2,2,4)
            imagesc(thisCell);
            colormap gray
            axis square
end

% dFByTrial_all=allDates_calls(1).dFByTrial;
% 
% dFByTrial_71b=dFByTrial_all(1:3,:);
% dFByTrial_j1a=dFByTrial_all(4:6,:);
% 
% for r=1:size(dFByTrial_j1a,2)
%     thisCelldF=dFByTrial_71b(:,r)
%     repsPerStim=cellfun(@(x)size(x,1),thisCelldF);
%     nStim=sum(repsPerStim);
%     maxRepsPerStim=max(repsPerStim);
%     dF_sorted_thisCell=[];%nan(nStim,size(thisCelldF{1},2));
% 
%     for s=1:maxPerStim
%         for c=1:3
%         dF_sorted_thisCell=[dF_sorted_thisCell; thisCelldF{c}(s,:)]