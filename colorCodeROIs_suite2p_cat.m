function colorCodeROIs_suite2p_cat(varargin)
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

catInds=cellfun(@(x)strcmp(x,'categories'),varargin(strsInds));
if sum(catInds)==0
    error('input category numbers')
else
    categories=varargin{strsInds(catInds)+1};
end

labelInds=cellfun(@(x)strcmp(x,'labels'),varargin(strsInds));
if sum(catInds)==0
    error('input category labels')
else
    labels=varargin{strsInds(labelInds)+1};
end



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
% subplot(1,2,1)
im=im/max(max(im));
im=imadjust(im);
im_handle=imshow(im);
colormap gray
axis square
hold on
freezeColors

% cmap=brewermap(numBins,cmapName);
% subplot(1,2,2)
% imshow(im);
% colormap gray
% axis square
% hold on
% freezeColors
for i=1:length(categories)
    colorMask=cat(3,repmat(cmap(i,1),size(im,1)),repmat(cmap(i,2),size(im,1)),repmat(cmap(i,3),size(im,1)));
    h(i)=imshow(colorMask);
    roiBinMask=ROI_masks(:,:,scale_var==categories(i));
    rwm=sum(roiBinMask,3);
    rwm=rwm>0;
    set(h(i),'AlphaData',rwm*1)
    
end
axis square
hbar=colorbar;
colormap(cmap)
freezeColors
hbar.Ticks=(0.5:1:(length(categories)-0.5))/length(categories);
hbar.TickLabels=labels;
freezeColors

end
