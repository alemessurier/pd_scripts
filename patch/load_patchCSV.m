T=readtable('F:\patch\cell_meta.csv');
data=table2struct(T);

data_include=data; % edit to filter for a subset of cells
%% loop through cells in dataset
for c=1:length(data_include)
    
    % USVs
    abfs_usv=data_include(c).usv_files;
    if ~isempty(abfs_usv)
        
    

%% usvs
    
    if ~iscell(abfs_usv)
        abfs_usv={abfs_usv};
    end
    invert=data_include(c).invert;
    [usv_spike_raster,usv_spikesByStim,threshold]=plot_usvTuning_patch(abfs_usv,invert);
    end
end
save([abf_path,fnames{1},'_usv.mat'],'spike_raster','spikesByStim','threshold')
%%
load([abf_path,fnames{1},'_usv.mat'],'spike_raster','spikesByStim','threshold')
make_usvRasterPSTH(spike_raster,spikesByStim,[1 6000],20)
%% tones
cd('F:\patch\20210716\')
    [abfs_tones, abf_path] = uigetfile('*.abf', 'MultiSelect', 'on')
    
    if ~iscell(abfs_tones)
        abfs_tones={abfs_tones};
    end
    for i=1:length(abfs_tones)
        fnames{i}=abfs_tones{i}(1:(end-4))
    end
%% 
cd('F:\patch\20210716\')
invert=0;
[spike_raster,spikesByStim,threshold]=plot_toneTuning_patch(abfs_tones,invert);
save([abf_path,fnames{1},'_tones.mat'],'spike_raster','spikesByStim','threshold')
%%
load([abf_path,fnames{1},'_tones.mat'],'spike_raster','spikesByStim','threshold')
make_tonesRasterPSTH(spike_raster,spikesByStim)

%% laser
cd('F:\patch\20210625 \')
    [abfs_opto, abf_path] = uigetfile('*.abf', 'MultiSelect', 'on')
    
    if ~iscell(abfs_opto)
        abfs_opto={abfs_opto};
    end
    for i=1:length(abfs_opto)
        fnames{i}=abfs_opto{i}(1:(end-4))
    end
    invert=0;
[raster,spike_times,threshold]=plot_lightResponse_patch(abfs_opto,300,50,invert)
save([abf_path,fnames{1},'_opto.mat'],'raster','spike_times','threshold')
%%
load([abf_path,fnames{1},'_opto.mat'],'raster','spike_times')
make_lightRaster_patch(raster,spike_times,30)