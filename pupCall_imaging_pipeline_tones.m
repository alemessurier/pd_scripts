function [dFByTone,h_tone,p_tone,tones]=pupCall_imaging_pipeline_tones(path_2p)

%% load data
[F_calls,F_byToneRep,ops,inds_ex]=load2p_data_pupcalls(path_2p);

%%
% plot raw dF/F traces of all ROIs
data=F_byToneRep(1).FROI;

deltaF_all=zeros(size(data));
numCells=size(data,1);
numFrames=size(data,2);

for i=1:numCells
    rawtrace=data(i,:);
    deltaF_all(i,:)  = deltaF_simple(rawtrace,0.5);
end

figure
samp_rate=3.91;
spacing=1;
stimFrames=20:20:numFrames;
plot_raw_deltaF( deltaF_all,samp_rate,spacing,stimFrames )

%%
freq_path='F:\reduced\retro_GCaMP_mouse3\QUARTEROCTAVE.txt';

%%
[dFByTone,h_tone,p_tone,tones]=froemke2p_analysis_tones(path_2p, freq_path);
% pupCalls_plotTuning_tones(dFByTone,tones,h_tone)