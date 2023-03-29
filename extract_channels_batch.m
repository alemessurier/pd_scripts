function files= extract_channels_batch(varargin)

gcp;                % start a local cluster
p = path; 
disp('Pick the folder with files to analyze:'); 
foldername = uigetdir; 
filetype   = 'tif'; % type of files to be processed
                    % Types currently supported .tif/.tiff, .h5/.hdf5, .raw, .avi, and .mat files
files = subdir(fullfile(foldername,['*.',filetype]));   % list of filenames (will search all subdirectories)
% files = dir(fullfile(foldername,['*.',filetype]));   % list of filenames (will search all subdirectories)
% FOV = size(read_file(files(1).name,1,1));
FOV = size(loadtiff(files(1).name,1,1));
numFiles = length(files);

parfor i=1:numFiles
   extract_channels_SI38(files(i).name);
end
end