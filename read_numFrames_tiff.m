function [ numFrames] = read_numFrames_tiff( imPath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 import ScanImageTiffReader.ScanImageTiffReader;
im=ScanImageTiffReader(imPath);
    meta=im.metadata;
expression = sprintf('SI.hStackManager.framesPerSlice.+\n');
matchStr = regexp(meta,expression,'match','dotexceptnewline');    % this returns whole line
tempindex = strfind(matchStr{1,1},'=');    % index of equal sign
numFrames= str2double(matchStr{1,1}(tempindex+1:end));     

end
