function [ output_args ] = makeROImasks_suite2p( ops,stat,iscell )
idx_cells=logical(iscell(:,1));
stat_cells=stat(idx_cells);

ROI_masks=zeros(ops.Lx,ops.Ly,length(stat_cells));

for m=1:size(ROI_masks,3)
    thisMask=zeros(ops.Lx,ops.Ly);
    ipix_use=stat_cells{m}.ipix(~stat_cells{m}.overlap);
    thisMask(ipix_use)=1;
    ROI_masks(:,:,m)=thisMask;
end

tmp=sum(ROI_masks,3);
figure; imagesc(tmp)

[im_green,meta]=LoadTIFF_SI2019('R:\froemkelab\froemkelabspace\Amy\imaging\US\SST5\20200109\f1\reg_tif\file000_chan0.tif');
avg_green=mean(im_green,3);
figure; imagesc(avg_green)

redcell=readNPY('F:\s2p_fastdisk\SST5\f1\suite2p\plane0\redcell.npy');
red_idx=redcell(idx_cells,1);
red_idx=logical(red_idx);
red_masks=ROI_masks(:,:,red_idx);

im=avg_green';
im=im/max(max(im));
im=imadjust(im);
figure;
im_handle=imshow(im);
hold on
freezeColors

cmap=hsv(3);
    colorMask=cat(3,repmat(cmap(1,1),size(im,1)),repmat(cmap(1,2),size(im,1)),repmat(cmap(1,3),size(im,1)));
    h(1)=imshow(colorMask);
    
    rwm=sum(red_masks,3)';
    rwm=rwm>0;
    set(h(1),'AlphaData',rwm*0.25)


end

