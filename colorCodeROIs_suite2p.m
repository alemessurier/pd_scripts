function colorCodeROIs_suite2p(varargin)
%COLORCODEROIS plots average imaging field with ROI masks colorcoded by a
%scaling variable
%
% INPUTS:
%           ROI_masks:  512x512xn logical array of ROI masks (required)
%           scale_var:      1xn array, colorcoding variable (required)
%           numBins:        optional, number of bins
%           cmapName:       optional, colormap from brewermap
%           cmapBounds:     optional, min and max value for colormap
%
% AML 2020
%% decode varargin


maskInds=cellfun(@(x)size(x,1)==512,varargin);
ROI_masks=varargin{maskInds};

filetif=varargin{2};
s=whos('filetif');
if strcmp(s.class,'char')
    im=LoadTIFF_SI2019(filetif);
    [curr_im,~]=LoadTIFF_SI2019(filetif);
    im=mean(curr_im,3)';
    im=im/max(max(im));
    %     im=imadjust(im);
else
    im=filetif;
    im=im/max(max(im));
end

strsInds=cellfun(@ischar,varargin);
tmp=1:length(varargin);
strsInds=tmp(strsInds);
scaleInds=cellfun(@(x)strcmp(x,'scale_var'),varargin(strsInds));
if sum(scaleInds)==0
    error('input scaling variable')
else
    scale_var=varargin{strsInds(scaleInds)+1};
end

numBinsInds=cellfun(@(x)strcmp(x,'numBins'),varargin(strsInds));
if sum(numBinsInds)==0
    numBins=20;
else
    numBins=varargin{strsInds(numBinsInds)+1};
end

edgeInds=cellfun(@(x)strcmp(x,'binEdges'),varargin(strsInds));
if sum(edgeInds)==0
    edges=[];
else
    edges=varargin{strsInds(edgeInds)+1};
end


% cmapInds=cellfun(@(x)strcmp(x,'cmapName'),varargin(strsInds));
% if sum(cmapInds)==0;
%     cmapName='RdPu';
% else
%     cmapName=varargin{strsInds(cmapInds)+1};
% end

cmapInds=cellfun(@(x)strcmp(x,'cmap'),varargin(strsInds));
if sum(cmapInds)==0;
    cmap=brewermap(numBins,'RdPu');
else
    cmap=varargin{strsInds(cmapInds)+1};
end


bInds=cellfun(@(x)strcmp(x,'cmapBounds'),varargin(strsInds));
if sum(bInds)==0;
    cmapBounds(1)=min(scale_var);
    cmapBounds(2)=max(scale_var);
else
    cmapBounds=varargin{strsInds(bInds)+1};
end

%% function body
figure;
im_handle=imshow(im);
colormap gray
axis square
hold on
freezeColors

if isempty(edges)
    minVal=cmapBounds(1);
    maxVal=cmapBounds(2);
    edges=minVal:(maxVal-minVal)/numBins:maxVal;
else
    numBins=length(edges)-1;
end

[~,~,binID]=histcounts(scale_var,edges);
% cmap=brewermap(numBins,cmapName);

for i=1:numBins;
    colorMask=cat(3,repmat(cmap(i,1),size(im,1)),repmat(cmap(i,2),size(im,1)),repmat(cmap(i,3),size(im,1)));
    h(i)=imshow(colorMask);
    roiBinMask=ROI_masks(:,:,binID==i);
    rwm=sum(roiBinMask,3);
    rwm=rwm>0;
    set(h(i),'AlphaData',rwm*0.25)
end
hbar=colorbar;
colormap(cmap)
freezeColors
hbar.Ticks=[0 (1:numBins)/numBins];
hbar.TickLabels=edges;
freezeColors

end
