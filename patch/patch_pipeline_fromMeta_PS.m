T=readtable('/Users/aml717/Desktop/patch/corticostriatal_macpaths.xlsx');

metadata=table2struct(T);

metadata_include=metadata; % edit to filter for a subset of cells

%% change filepaths
metadata_new=metadata;
for c=1:length(metadata)
    % rename USV files
    usv_files=metadata(c).usv_files;
    usv_files=char2cell(usv_files,',');
    if ~isempty(usv_files)
    for i=1:length(usv_files)
        tmpidx=strfind(usv_files{i},'patch');
        path_end=usv_files{i}(tmpidx:end)
        sepidx=strfind(path_end,'\');
        path_end(sepidx)=filesep;
        usv_files_tmp{i}=['/Users/aml717/Desktop/',path_end,','];
    end
    usv_files_new=cat(2,usv_files_tmp{:});
    clear usv_files_tmp
    else
        usv_files_new='';
    end
    metadata_new(c).usv_files=usv_files_new;
    
    % rename tone files
    tone_files=metadata(c).tone_files;
    tone_files=char2cell(tone_files,',');
    if ~isempty(tone_files)
    for i=1:length(tone_files)
        tmpidx=strfind(tone_files{i},'patch');
        path_end=tone_files{i}(tmpidx:end)
        sepidx=strfind(path_end,'\');
        path_end(sepidx)=filesep;
        tone_files_tmp{i}=['/Users/aml717/Desktop/',path_end,','];
    end
    tone_files_new=cat(2,tone_files_tmp{:});
    clear tone_files_tmp
    else
        tone_files_new='';
    end
    metadata_new(c).tone_files=tone_files_new;

    % rename opto50ms files
    optoID_50ms_files=metadata(c).optoID_50ms;
    optoID_50ms_files=char2cell(optoID_50ms_files,',');
    if ~isempty(optoID_50ms_files)
    for i=1:length(optoID_50ms_files)
        tmpidx=strfind(optoID_50ms_files{i},'patch');
        path_end=optoID_50ms_files{i}(tmpidx:end)
        sepidx=strfind(path_end,'\');
        path_end(sepidx)=filesep;
        optoID_50ms_files_tmp{i}=['/Users/aml717/Desktop/',path_end,','];
    end
    optoID_50ms_files_new=cat(2,optoID_50ms_files_tmp{:});
    clear optoID_50ms_files_tmp
    else
        optoID_50ms_files_new='';
    end
    metadata_new(c).optoID_50ms_files=optoID_50ms_files_new;

    % rename opto20ms files
    optoID_20ms_files=metadata(c).optoID_20ms;
    optoID_20ms_files=char2cell(optoID_20ms_files,',');
    if ~isempty(optoID_20ms_files)
    for i=1:length(optoID_20ms_files)
        tmpidx=strfind(optoID_20ms_files{i},'patch');
        path_end=optoID_20ms_files{i}(tmpidx:end);
        sepidx=strfind(path_end,'\');
        path_end(sepidx)=filesep;
        optoID_20ms_files_tmp{i}=['/Users/aml717/Desktop/',path_end,','];
    end
    optoID_20ms_files_new=cat(2,optoID_20ms_files_tmp{:});
    clear optoID_20ms_files_tmp
    else
        optoID_20ms_files_new='';
    end
    metadata_new(c).optoID_20ms_files=optoID_20ms_files_new;

    % rename opto200ms files
    optoID_200ms_files=metadata(c).optoID_200ms;
    optoID_200ms_files=char2cell(optoID_200ms_files,',');
    if ~isempty(optoID_200ms_files)
    for i=1:length(optoID_200ms_files)
        tmpidx=strfind(optoID_200ms_files{i},'patch');
        path_end=optoID_200ms_files{i}(tmpidx:end)
        sepidx=strfind(path_end,'\');
        path_end(sepidx)=filesep;
        optoID_200ms_files_tmp{i}=['/Users/aml717/Desktop/',path_end,','];
    end
    optoID_200ms_files_new=cat(2,optoID_200ms_files_tmp{:});
    clear optoID_200ms_files_tmp
    else
        optoID_200ms_files_new='';
    end
    metadata_new(c).optoID_200ms_files=optoID_200ms_files_new;
end

Twrite=struct2table(metadata_new);

writetable(Twrite,'/Users/aml717/Desktop/patch/corticostriatal_macpaths.csv')
%% usvs

% loop through cells
for c=1:length(metadata)
    abfs_usv=metadata(c).usv_files;
    abfs_usv=char2cell(abfs_usv,',');
    for i=1:length(abfs_usv)
        fnames_usv{i}=abfs_usv{i}(1:(end-4))
    end

    invert=metadata(c).invert;
    try
        load([fnames_usv{1},'_usv.mat'])

        [~,si]=abfload(abfs_usv{1}); % read sampling interval from first abf
        sampRateHz=1/(si*1e-6); % si is in microseconds
        data(c).usv.spike_raster=spike_raster;
        data(c).usv.spikesByStim=spikesByStim;
        data(c).usv.threshold=threshold;
        data(c).usv.raster_all=raster_all;
        data(c).usv.spike_times=spike_times;
        data(c).usv.sampRateHz=sampRateHz;
%         make_usvRasterPSTH(spike_raster,spikesByStim,raster_all,spike_times,[1 6000],200)

    catch ME
        tmp=isempty(abfs_usv);
        switch tmp
            case 1
                data(c).usv.spike_raster=[];
                data(c).usv.spikesByStim=[];
                data(c).usv.threshold=[];
                data(c).usv.raster_all=[];
                data(c).usv.spike_times=[];
                data(c).usv.sampRateHz=[];
            case 0
                [spike_raster,spikesByStim,threshold,raster_all,spike_times]=plot_usvTuning_patch(abfs_usv,invert);

                [~,si]=abfload(abfs_usv{1}); % read sampling interval from first abf
                sampRateHz=1/(si*1e-6); % si is in microseconds
                data(c).usv.spike_raster=spike_raster;
                data(c).usv.spikesByStim=spikesByStim;
                data(c).usv.threshold=threshold;
                data(c).usv.raster_all=raster_all;
                data(c).usv.spike_times=spike_times;
                data(c).usv.sampRateHz=sampRateHz;
                save([fnames_usv{1},'_usv.mat'],'spike_raster','spikesByStim','threshold','raster_all','spike_times')
%                 make_usvRasterPSTH(spike_raster,spikesByStim,raster_all,spike_times,[1 6000],200)

        end
    end

    clear spike_raster spikesByStim threshold raster_all spike_times sampRateHz

    % tones
     freq_order=metadata(c).freq_order;
    invert=metadata(c).invert;

    abfs_tones=metadata(c).tone_files;
    abfs_tones=char2cell(abfs_tones,',');
    for i=1:length(abfs_tones)
        fnames_tone{i}=abfs_tones{i}(1:(end-4));
    end


    try
        load([fnames_tone{1},'_tones.mat'])

        [~,si]=abfload(abfs_tones{1}); % read sampling interval from first abf
        sampRateHz=1/(si*1e-6); % si is in microseconds
       
        data(c).tones.spike_raster=spike_raster;
        data(c).tones.spikesByStim=spikesByStim;
        data(c).tones.threshold=threshold;
        data(c).tones.spike_times=spike_times;
        data(c).tones.freq_order=freq_order;
        data(c).tones.sampRateHz=sampRateHz;
%         make_tonesRasterPSTH(spike_raster,spikesByStim,freq_order,20)
    catch ME
        tmp=isempty(abfs_tones);
        switch tmp
            case 1
                data(c).tones.spike_raster=[];
                data(c).tones.spikesByStim=[];
                data(c).tones.threshold=[];
                data(c).tones.spike_times=[];
                data(c).tones.freq_order=[];
                data(c).tones.sampRateHz=[];

            case 0
                [spike_raster,spikesByStim,threshold,spike_times]=plot_toneTuning_patch(abfs_tones,invert,freq_order);

                [~,si]=abfload(abfs_tones{1}); % read sampling interval from first abf
                sampRateHz=1/(si*1e-6); % si is in microseconds
                data(c).tones.spike_raster=spike_raster;
                data(c).tones.spikesByStim=spikesByStim;
                data(c).tones.threshold=threshold;
                data(c).tones.spike_times=spike_times;
                data(c).tones.freq_order=freq_order;
                data(c).tones.sampRateHz=sampRateHz;
%                 make_tonesRasterPSTH(spike_raster,spikesByStim,freq_order,20)

                save([fnames_tone{1},'_tones.mat'],'spike_raster','spikesByStim','threshold','spike_times')
        end
    end

    clear spike_raster spikesByStim threshold raster_all spike_times sampRateHz

    % laser 200 ms

    stimTimeOpto=metadata(c).opto_stim_time;
    abfs_opto200=metadata(c).optoID_200ms_files;
    abfs_opto200=char2cell(abfs_opto200,',');
    for i=1:length(abfs_opto200)
        fnames_200ms{i}=abfs_opto200{i}(1:(end-4))
    end


    try
        load([fnames_200ms{1},'_optoID200ms.mat'])
        [~,si]=abfload(abfs_opto200{1}); % read sampling interval from first abf
        sampRateHz=1/(si*1e-6); % si is in microseconds
        data(c).optoID.raster200=raster200;
        data(c).optoID.spike_times200=spike_times200;
        data(c).optoID.threshold200=threshold200;
        data(c).optoID.sampRateHz=sampRateHz;
%         make_lightRaster_patch(raster200,spike_times200,315,200,1);
    catch ME
        tmp=isempty(abfs_opto200);
        switch tmp
            case 1
                data(c).optoID.raster200=[];
                data(c).optoID.spike_times200=[];
                data(c).optoID.threshold200=[];
                data(c).optoID.sampRateHz=[];

            case 0
                [raster200,spike_times200,threshold200]=plot_lightResponse_patch(abfs_opto200,stimTimeOpto,200,invert);
                [~,si]=abfload(abfs_opto200{1}); % read sampling interval from first abf
                sampRateHz=1/(si*1e-6); % si is in microseconds
                data(c).optoID.raster200=raster200;
                data(c).optoID.spike_times200=spike_times200;
                data(c).optoID.threshold200=threshold200;
                data(c).optoID.sampRateHz=sampRateHz;

%                 make_lightRaster_patch(raster200,spike_times200,315,200,1);
                save([fnames_200ms{1},'_optoID200ms.mat'],'raster200','spike_times200','threshold200');
        end
    end

    % laser 50 ms
    abfs_opto50=metadata(c).optoID_50ms_files;
    abfs_opto50=char2cell(abfs_opto50,',');
    for i=1:length(abfs_opto50)
        fnames_50ms{i}=abfs_opto50{i}(1:(end-4))
    end

    try
        load([fnames_50ms{1},'_optoID50ms.mat'])
        data(c).optoID.raster50=raster50;
        data(c).optoID.spike_times50=spike_times50;
        data(c).optoID.threshold50=threshold50;
%         make_lightRaster_patch(raster50,spike_times50,315,50,1);
    catch ME
        tmp=isempty(abfs_opto50);
        switch tmp
            case 1
                data(c).optoID.raster50=[];
                data(c).optoID.spike_times50=[];
                data(c).optoID.threshold50=[];

            case 0
                [raster50,spike_times50,threshold50]=plot_lightResponse_patch(abfs_opto50,stimTimeOpto,50,invert);
                data(c).optoID.raster50=raster50;
                data(c).optoID.spike_times50=spike_times50;
                data(c).optoID.threshold50=threshold50;
                make_lightRaster_patch(raster50,spike_times50,315,50,1);
                save([fnames_50ms{1},'_optoID50ms.mat'],'raster50','spike_times50','threshold50');
        end
    end
    % laser 20 ms
    abfs_opto20=metadata(c).optoID_20ms_files;
    abfs_opto20=char2cell(abfs_opto20,',');
    for i=1:length(abfs_opto20)
        fnames_20ms{i}=abfs_opto20{i}(1:(end-4))
    end

    try
        load([fnames_20ms{1},'_optoID20ms.mat'])
        data(c).optoID.raster20=raster20;
        data(c).optoID.spike_times20=spike_times20;
        data(c).optoID.threshold20=threshold20;
%         make_lightRaster_patch(raster20,spike_times20,315,20,1);
    catch ME
        tmp=isempty(abfs_opto20);
        switch tmp
            case 1
                data(c).optoID.raster20=[];
                data(c).optoID.spike_times20=[];
                data(c).optoID.threshold20=[];

            case 0
                [raster20,spike_times20,threshold20]=plot_lightResponse_patch(abfs_opto20,stimTimeOpto,20,invert);
                data(c).optoID.raster20=raster20;
                data(c).optoID.spike_times20=spike_times20;
                data(c).optoID.threshold20=threshold20;
                make_lightRaster_patch(raster20,spike_times20,315,20,1);
                save([fnames_20ms{1},'_optoID20ms.mat'],'raster20','spike_times20','threshold20');
        end
    end
    data(c).optoID.stimTime=stimTimeOpto;
end

save_path_struct='/Users/aml717/Desktop/patch/';
save([save_path_struct,'corticostriatal_reduced.mat'],'metadata','data')