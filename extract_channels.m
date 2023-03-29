function [ MovieDataGreen,MetaDataGreen,MovieDataRed,MetaDataRed ] = extract_channels(varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if isempty(varargin)
    [fname,imPath] = uigetfile('.tif');
    imPath=strcat(imPath,fname);
else
    imPath=varargin{1};
end

%% Load a 2-channel SI5 TIFF File, Extract Green Channel (Ch1), and Save as TIFF
[MovieData, Metadata] = LoadTIFF_SI5(imPath);     
[Metadata] = ReadTIFFHeader_SI5(Metadata);
[MovieDataGreen, MetaDataGreen] = ExtractFrames_TIFF(MovieData, Metadata,1:2:(size(MovieData,3)));
imNameInds=strfind(imPath,'.');
WriteTIFF(MovieDataGreen, MetaDataGreen, strcat(imPath(1:(imNameInds-1)),'_grch.tif'));

[MovieDataRed, MetaDataRed] = ExtractFrames_TIFF(MovieData, Metadata,2:2:(size(MovieData,3)));
WriteTIFF(MovieDataRed, MetaDataRed, strcat(imPath(1:(imNameInds-1)),'_rch.tif'));

% argsOut={MovieDataGreen,MetaDataGreen,MovieDataRed,MetaDataRed};
% if nargout>0
%     varargout=argsOut{1:nargout};
% else
%     varargout={};
% end
end

