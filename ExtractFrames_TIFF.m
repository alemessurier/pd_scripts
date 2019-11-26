function [ MovieDataOut, MetadataOut ] = ExtractFrames_TIFF( MovieDataIn, MetadataIn, FramesToKeep )
%ExtractFrames_TIFF
%   This function removes a specified list of frames from MovieDataIn,
%   updating the Metadata accordingly.
%   List of frames to keep is FramesToKeep vector, i.e. 1:2:1200

% Check that FramesToKeep is a valid list of frames
NumberImages=length(MetadataIn.InfoImage);
if (max(FramesToKeep)>NumberImages)
    error('ExtractFrames_TIFF:  A frame number greater than the number of frames was specified.\n')
end
% Subselect the desired frames from MovieDataIn and MetadataIn, and write to the output arrays.
    
MovieDataOut = MovieDataIn(:, :, FramesToKeep);
MetadataOut = MetadataIn;    % copy all fields, then remove entries for deleted frames
MetadataOut.InfoImage = MetadataOut.InfoImage(FramesToKeep);
MetadataOut.FrameNumberRaw = MetadataOut.FrameNumberRaw(FramesToKeep);
MetadataOut.FrameNumberTIFF = MetadataOut.FrameNumberTIFF(FramesToKeep);
MetadataOut.FrameTimeInMovie = MetadataOut.FrameTimeInMovie(FramesToKeep);

MetadataOut.NumFrames = numel(FramesToKeep);        % update number of frames field

end

