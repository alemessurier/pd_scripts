%%
load('/Users/aml717/Desktop/patch/allpatch_reduced.mat')

%% screen neurons for opto activation


for c=46:64%1:length(data)
    if ~isempty(data(c).optoID.raster20)
        timeIdx=[50,size(data(c).optoID.raster20,2)];
        make_lightRaster_patch(data(c).optoID.raster20,data(c).optoID.spike_times20,data(c).optoID.stimTime,timeIdx,10,20,0.2)
        title(['cell ',num2str(c)])
    end

    if ~isempty(data(c).optoID.raster50)
        timeIdx=[50,size(data(c).optoID.raster50,2)];
        make_lightRaster_patch(data(c).optoID.raster50,data(c).optoID.spike_times50,data(c).optoID.stimTime,timeIdx,10,50,0.2)
        title(['cell ',num2str(c)])
    end
    if ~isempty(data(c).optoID.raster200)
        timeIdx=[50,size(data(c).optoID.raster200,2)];
        make_lightRaster_patch(data(c).optoID.raster200,data(c).optoID.spike_times200,data(c).optoID.stimTime,timeIdx,10,200,0.2)
        title(['cell ',num2str(c)])
    end
end

%%

IC_idx=arrayfun(@(x)strcmp(x.opto_tag,'IC'),metadata);
PS_idx=arrayfun(@(x)strcmp(x.opto_tag,'PS'),metadata);
data_optotagged=data(IC_idx | PS_idx);

%%
for c=1:length(data_optotagged)
    if ~isempty(data_optotagged(c).optoID.raster20)
        timeIdx=[50,size(data_optotagged(c).optoID.raster20,2)];
        make_lightRaster_patch(data_optotagged(c).optoID.raster20,data_optotagged(c).optoID.spike_times20,data_optotagged(c).optoID.stimTime,timeIdx,10,20,0.2)
        title(['cell ',num2str(c)])
    end

    if ~isempty(data_optotagged(c).optoID.raster50)
        timeIdx=[50,size(data_optotagged(c).optoID.raster50,2)];
        make_lightRaster_patch(data_optotagged(c).optoID.raster50,data_optotagged(c).optoID.spike_times50,data_optotagged(c).optoID.stimTime,timeIdx,10,50,0.2)
        title(['cell ',num2str(c)])
    end
    if ~isempty(data_optotagged(c).optoID.raster200)
        timeIdx=[50,size(data_optotagged(c).optoID.raster200,2)];
        make_lightRaster_patch(data_optotagged(c).optoID.raster200,data_optotagged(c).optoID.spike_times200,data_optotagged(c).optoID.stimTime,timeIdx,10,200,0.2)
        title(['cell ',num2str(c)])
    end
end
