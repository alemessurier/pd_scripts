%% usvs
cd('/Users/aml717/Desktop/patch/20220120/')
    [abfs_usv, abf_path] = uigetfile('*.abf', 'MultiSelect', 'on')
    
    if ~iscell(abfs_usv)
        abfs_usv={abfs_usv};
    end
    for i=1:length(abfs_usv)
        fnames{i}=abfs_usv{i}(1:(end-4))
    end

invert=1;
[spike_raster,spikesByStim,threshold,raster_all,spike_times]=plot_usvTuning_patch(abfs_usv,invert);

% save([abf_path,fnames{1},'_usv.mat'],'spike_raster','spikesByStim','threshold','raster_all','spike_times')
%%
load([abf_path,fnames{1},'_usv.mat'],'spike_raster','spikesByStim','threshold','raster_all','spike_times')
make_usvRasterPSTH(spike_raster,spikesByStim,raster_all,spike_times,[1 6000],100)
%% tones
cd('/Users/aml717/Desktop/patch/20220118/')
    [abfs_tones, abf_path] = uigetfile('*.abf', 'MultiSelect', 'on')
    
    if ~iscell(abfs_tones)
        abfs_tones={abfs_tones};
    end
    for i=1:length(abfs_tones)
        fnames{i}=abfs_tones{i}(1:(end-4))
    end
invert=1;
[spike_raster,spikesByStim,threshold]=plot_toneTuning_patch(abfs_tones,invert);
% save([abf_path,fnames{1},'_tones.mat'],'spike_raster','spikesByStim','threshold')
%%
load([abf_path,fnames{1},'_tones.mat'],'spike_raster','spikesByStim','threshold')
make_tonesRasterPSTH(spike_raster,spikesByStim)

%% laser
cd('/Users/aml717/Desktop/patch/20220120/')
    [abfs_opto, abf_path] = uigetfile('*.abf', 'MultiSelect', 'on')
    
    if ~iscell(abfs_opto)
        abfs_opto={abfs_opto};
    end
    for i=1:length(abfs_opto)
        fnames{i}=abfs_opto{i}(1:(end-4))
    end
    invert=1;
[raster,spike_times,threshold]=plot_lightResponse_patch(abfs_opto,315,50,invert)
% save([abf_path,fnames{1},'_opto.mat'],'raster','spike_times','threshold')
%%
load([abf_path,fnames{1},'_opto.mat'],'raster','spike_times')
make_lightRaster_patch(raster,spike_times,315,200,1)