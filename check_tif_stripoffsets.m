dir_raw='/Volumes/Willow/NDNF6172/raw/20200723/';
cd(dir_raw)
tifs=dir('*.tif');
tifnames=arrayfun(@(x)x.name,tifs,'un',0);

for t=1:length(tifnames)
    infoImage=imfinfo([dir_raw,tifnames{t}]);
    stripoffsets{t}=[infoImage(:).StripOffsets];
    contains_nans(t)=sum(isnan(stripoffsets{t}))>0;
    numframes(t)=numel(infoImage);
    
end