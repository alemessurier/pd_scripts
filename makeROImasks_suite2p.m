function ROI_masks=makeROImasks_suite2p( ops,stat)

ROI_masks=zeros(ops.Lx,ops.Ly,length(stat));

for m=1:size(ROI_masks,3)
    ypix=int32(stat{m}.ypix);
    xpix=int32(stat{m}.xpix);
    Ly=int32(ops.Ly);
    thisMask=zeros(ops.Lx,ops.Ly);
    ipix =  ypix+(xpix-1)*Ly;
    ipix_use=ipix;%(~stat{m}.overlap);
    thisMask(ipix_use)=1;
    ROI_masks(:,:,m)=thisMask;
end

end

