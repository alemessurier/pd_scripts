%% set directories
dir_raw='E:\s2p\yi_mouse10\mouse10_rawtifs\';
dir_processed='E:\s2p\yi_mouse10\mouse10_mctifs\';
dir_reduced='E:\s2p\yi_mouse10\reduced\';



%% define ROIs 
ring=10;   gap=2;  %define parameters of donut-shaped neuropil mask. beginning "gap" pixels from the outer most of ROIs and has the width of donut ring = "ring" pixels
% ring=2/gap=2 from Dan O'Connor 
% ring=10/gap=3 from Svoboda 2015
corrThreshold=0.2; % pixes correlated above this threshold with any ROI timeseries will be removed from neuropil mask.
corr=0; % 0=not consider correlation, 1=use correlation map, 2=directly check correlation with ROI signals

[ROImasks,npMasks]=label_ROIs_yiData(dir_processed,[],10,2);
save([dir_reduced,'ROIs.mat'],'ROImasks','npMasks')

%% Extract raw fluorescence time series from ROIs  *****only need to run this once; saves out rawTimeSeries and Metadata to dir_reduced****

ROIcheck=squeeze(sum(sum(ROImasks)))==0;
ROImasks=ROImasks(:,:,~ROIcheck);
rawTimeSeries = getFluoTimeSeries_wrapper( dir_processed,  ROImasks);
    save(strcat(dir_reduced,'ROI_timeSeries.mat'),'rawTimeSeries');
% rawTimeSeries=cat(2,rawTimeSeries{:});

% %get ROI raw time series, save
% [ rawTimeSeries,Metadata ] = getFluoTimeSeries_wrapper( dir_processed,  ROI_positions);
% save(strcat(dir_reduced,'Metadata'),'Metadata');
%     save(strcat(dir_reduced,'ROI_timeSeries.mat'),'rawTimeSeries');
% 
% % make NPcorr masks, save    
% npMasks=get_NPcorr_mask(dir_reduced,corrThreshold); % removes pixels from neuropil mask that are correlated with any ROI mask
% save([dir_reduced,'npMask_corr_',date,'.mat'],'npMasks');
% 
% % get npMask time series, save
% [ rawTimeSeriesNP_corr,Metadata ] = getFluoTimeSeries_wrapper( dir_processed,  npMasks );
% save([dir_reduced,'npCorr_TS_',date,'.mat'],'rawTimeSeriesNP_corr');
%        


%% filter data with sliding average
if filtData==1
    [ filtTimeSeries ] = slidingAvg_rawF_wrapper( rawTimeSeries,ptsToAvg,filter_type );
    save(strcat(dir_reduced,'ROI_timeSeries.mat'),'rawTimeSeries','filtTimeSeries');
    [ npfiltTimeSeries ] = slidingAvg_rawF_wrapper( rawTimeSeriesNP_corr,ptsToAvg,filter_type );
    save(strcat(dir_reduced,'NP_timeSeries.mat'),'rawTimeSeriesNP','npfiltTimeSeries');
end

%% look through raw fluorescence movies to remove movies with large change in fluorescence

%opens gui plotting raw fluorescence for each ROI in each movie, 'keep' and 'remove' buttons for removing movies with large drift in intensity
[filtTimeSeries,movies_exclude]=check_rawFluor( filtTimeSeries ); 
 npfiltTimeSeries=rmfield(npfiltTimeSeries,movies_exclude);


%% remove ROIs with overcorrection from np subtraction

%opens gui plotting raw fluorescence for each ROI. loops through all ROIs, plotting raw fluorecence time series for
%ROI mask, neuropil mask, and ROI fluorescence post neuropil subtraction. Black is ROI, red is mask, blue is subtraction
%'keep' and 'remove' buttons for removing overcorrected ROIs
[filtTimeSeries,npfiltTimeSeries,ROIs_exclude]=check_rawROIs( filtTimeSeries,npfiltTimeSeries );
%% pre deltaF neuropil subtraction

[ npNormTimeSeries ] = npSubtract_preDF( filtTimeSeries,npfiltTimeSeries, npweight ); %npweight is % of neuropil mask raw fluorescence to subtract from ROI mask
%% calculate deltaF/F

    [ deltaF,sampRate,truncTotal,fns,cellNames ] = calc_deltaF_wrapper(npNormTimeSeries,Metadata );


%% Create Stimuli structure containing stimulus times, based on user-entered ISI and trigger timestamp from igor binary file.
  
 Stimuli = make_Stimuli( dir_reduced,fns,StimISI,Metadata );

%% make traceByStim

% generate vector of frames for measuring evoked activity post-stimulus
framesEvoked=(ceil(bl_length*sampRate(1))+1):(ceil(bl_length*sampRate(1))+ceil(timeEvoked*sampRate(1))); 

% make structure collecting dF/F in time window before and after each stim iteration by ROI and by whisker identity
[ traceByStim, stimFramesAll ] = make_traceByStim( whisk,Stimuli,Metadata,deltaF,bl_length,timePostStim );

%% find spontaneous activity
[ sponTrace ] = make_sponTrace( Stimuli,Metadata,deltaF,bl_length,timePostStim );

%% permutation test for whisker responsiveness

%for each ROI, tests for difference in means between spontaeous dF/F and
%dF/F evoked by each whisker. Returns p-value for each whisker. For further analysis must be corrected for 9 comparisons using FDR. 
[ permTestResults ] = permuteTest_whisk_2016( sponTrace,traceByStim,numBoots,framesEvoked,permTestType );

%% save reduced data structures

save(strcat(dir_reduced,'step1_',date,'.mat'),'deltaF','Stimuli',...
    'traceByStim','sampRate','framesEvoked','sponTrace',...
    'permTestResults');
save([dir_reduced,'settings_',date,'mat'],'bl_length','filtData','mag',...
    'movies_exclude','numBoots','permTestType','ptsToAvg','ROIs_exclude',...
    'StimISI','timeEvoked','timePostStim','filter_type');




