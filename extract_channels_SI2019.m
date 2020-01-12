function [ MovieDataGreen,MetaDataGreen,MovieDataRed,MetaDataRed ] = extract_channels_SI2019(dir_extract,dir_green,dir_red)

%UNTITLED3 Summary of this function goes here
% %   Detailed explanation goes here
% if isempty(varargin)
%     [fname,imPath] = uigetfile('.tif');
%     imPath=strcat(imPath,fname);
% else
%     imPath=varargin{1};
% end
cd(dir_extract)
imFiles=dir('*.tif');
stackNames=arrayfun(@(x)x.name,imFiles,'Uni',0);
%% Load a 2-channel SI5 TIFF File, Extract Green Channel (Ch1), and Save as TIFF

for K=1:length(stackNames)
    imPath=[dir_extract,stackNames{K}];
[MovieData, Metadata] = LoadTIFF_SI2019(imPath);     
% [Metadata] = ReadTIFFHeader_SI5(Metadata);
[MovieDataGreen, MetaDataGreen] = ExtractFrames_TIFF_SI2019(MovieData, Metadata,1:2:(size(MovieData,3)));
imNameInds=strfind(stackNames{K},'.');
WriteTIFF(MovieDataGreen, MetaDataGreen, [dir_green,stackNames{K}(1:(imNameInds-1)),'_grch.tif']);

[MovieDataRed, MetaDataRed] = ExtractFrames_TIFF_SI2019(MovieData, Metadata,2:2:(size(MovieData,3)));
WriteTIFF(MovieDataRed, MetaDataRed, [dir_red,stackNames{K}(1:(imNameInds-1)),'_grch.tif']);

% argsOut={MovieDataGreen,MetaDataGreen,MovieDataRed,MetaDataRed};
% if nargout>0
%     varargout=argsOut{1:nargout};
% else
%     varargout={};
% end
end

