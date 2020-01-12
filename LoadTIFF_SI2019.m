function [ImageArray, Metadata] = LoadTIFF_SI2019(FileTif)
% This function loads ScanImage5 TIFFs.  The structure InfoImage contains
% all of the header information.  ImageArray contains the movie data
% (Row,Col,NumberImages).  RowPixels,  ColPixels, NumberImages are scalars.

   %  FileTif='/Users/Dan/Documents/MATLAB/test_00004.tif';
    import ScanImageTiffReader.ScanImageTiffReader;
im=ScanImageTiffReader(FileTif);
    InfoImage=imfinfo(FileTif);
    RowPixels=InfoImage(1).Width;
    ColPixels=InfoImage(1).Height;
    NumberImages=length(InfoImage);
    ImageArray=im.data;
    ImageArray=uint16(ImageArray);
    meta=im.metadata;
    Metadata = struct('RowPixels',RowPixels,'ColPixels',ColPixels,'NumFrames',NumberImages,'InfoImage',InfoImage,'meta',meta);
end


