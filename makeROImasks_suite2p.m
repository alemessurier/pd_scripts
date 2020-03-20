function red_masks=plotROImasks_red( ops,stat,iscell,filetif,redNPY )
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

[im_green,meta]=LoadTIFF_SI2019(filetif);
avg_green=mean(im_green,3)';
figure; imagesc(avg_green)

red_idx=redcell(idx_cells,1);
red_idx=logical(red_idx);
red_masks=ROI_masks(:,:,red_idx);

colorCodeROIs_suite2p(filetif,red_masks)

end

