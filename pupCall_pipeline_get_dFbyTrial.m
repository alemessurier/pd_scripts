function [dFByTrial,h,p] = pupCall_pipeline_get_dFbyTrial(F_calls_sorted,ops,stimISI,bl_length,postStim_length) 

%% get tuning for pup calls
samp_rate=ops.fs;
Fcell=F_calls_sorted(1).filt_ROI;
stimFrames=(stimISI:stimISI:size(Fcell{1},2))+0.5*samp_rate;
stimFrames=stimFrames(1:end-2);
frames_call1=stimFrames(1:3:end);
frames_call2=stimFrames(2:3:end);
frames_call3=stimFrames(3:3:end);
[dFByTrial{1},h(1,:),p(1,:)] = extract_USV_tuning(Fcell,frames_call1,samp_rate,bl_length,postStim_length);
[dFByTrial{2},h(2,:),p(2,:)] = extract_USV_tuning(Fcell,frames_call2,samp_rate,bl_length,postStim_length);

[dFByTrial{3},h(3,:),p(3,:)] = extract_USV_tuning(Fcell,frames_call3,samp_rate,bl_length,postStim_length);


Fcell=F_calls_sorted(2).filt_ROI;
    stimFrames=stimISI:stimISI:size(Fcell{1},2);
    stimFrames=stimFrames(1:end-2);
frames_call1=stimFrames(1:3:end);
frames_call2=stimFrames(2:3:end);
frames_call3=stimFrames(3:3:end);
[dFByTrial{4},h(4,:),p(4,:)] = extract_USV_tuning(Fcell,frames_call1,samp_rate,bl_length,postStim_length);
[dFByTrial{5},h(5,:),p(5,:)] = extract_USV_tuning(Fcell,frames_call2,samp_rate,bl_length,postStim_length);

[dFByTrial{6},h(6,:),p(6,:)] = extract_USV_tuning(Fcell,frames_call3,samp_rate,bl_length,postStim_length);

if length(F_calls_sorted)==3
    Fcell=F_calls_sorted(3).filt_ROI;
    stimFrames=stimISI:stimISI:size(Fcell,2);
             frames_call1=stimFrames(1:3:end);
    frames_call2=stimFrames(2:3:end);
    frames_call3=stimFrames(3:3:end);
    [dFByTrial{7},h(7,:),p(7,:)] = extract_USV_tuning(Fcell,frames_call1,samp_rate,bl_length,postStim_length);
    [dFByTrial{8},h(8,:),p(8,:)] = extract_USV_tuning(Fcell,frames_call2,samp_rate,bl_length,postStim_length);

    [dFByTrial{9},h(9,:),p(9,:)] = extract_USV_tuning(Fcell,frames_call3,samp_rate,bl_length,postStim_length);
end
dFByTrial=cat(1,dFByTrial{:});