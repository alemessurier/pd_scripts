function ROI_masks=makeROImasks_suite2p( ops,stat,iscell)
idx_cells=logical(iscell(:,1));
stat_cells=stat(idx_cells);

ROI_masks=zeros(ops.Lx,ops.Ly,length(stat_cells));

for m=1:size(ROI_masks,3)
    thisMask=zeros(ops.Lx,ops.Ly);
    ipix_use=stat_cells{m}.ipix(~stat_cells{m}.overlap);
    thisMask(ipix_use)=1;
    ROI_masks(:,:,m)=thisMask';
end

end

