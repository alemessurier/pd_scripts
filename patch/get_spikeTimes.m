function [spikes,spikeTimes,trace_idx] = get_spikeTimes(data,thresh)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for k=1:length(thresh)
    overThresh(k,:)=data(k,:)>thresh(k);
end




spikeTimes=[];
trace_idx=[];
for i=1:size(data,1)
    thisSweep=overThresh(i,:);
    tmp=[0 diff(thisSweep)];
    spikes(i,:)=tmp==1;
    [~,inds]=find(spikes(i,:)==1);
    spikeTimes=[spikeTimes, inds];
    thisTrace=repmat(i,size(inds));
    trace_idx=[trace_idx, thisTrace];
end


end


    
