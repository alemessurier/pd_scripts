function colorCodeROIs_suite2p_simple(im,ROI_masks)
%% function body

% [curr_im,~]=LoadTIFF_SI2019(filetif);
% im=mean(curr_im,3)';
% % colormap gray
% im=im/max(max(im));
% im=imadjust(im);

figure;
im_handle=imagesc(im);
colormap gray
axis square
hold on
freezeColors

cmap=hsv(3);
    colorMask=cat(3,repmat(cmap(1,1),size(im,1)),repmat(cmap(1,2),size(im,1)),repmat(cmap(1,3),size(im,1)));
    h(1)=imshow(colorMask);
    
    rwm=sum(ROI_masks,3);
    rwm=rwm>0;
    set(h(1),'AlphaData',rwm*0.25)

% hbar=colorbar;
% colormap(cmap)
% freezeColors
% hbar.Ticks=[0 (1:numBins)/numBins];
% hbar.TickLabels=edges;
% freezeColors
end
