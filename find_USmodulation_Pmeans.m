function [pvals_pos,pvals_neg ] = find_USmodulation_Pmeans( dF_byDS,dF_byPressure,stimFrame,prestim,poststim )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cellNames=fieldnames(dF_byDS);
DCs=fieldnames(dF_byDS.(cellNames{1}));
Pr=fieldnames(dF_byPressure.(cellNames{1}));
frames_pre=(stimFrame-prestim):(stimFrame-1);
if length(poststim)>1
    frames_post=poststim;
else
frames_post=(stimFrame+15):(stimFrame+poststim);
end
for c=1:length(cellNames)
    
    pPos_dc=zeros(length(DCs),1);
    pNeg_dc=pPos_dc;
    
    for d=1:length(DCs)
        
        prestim_mean=mean(dF_byDS.(cellNames{c}).(DCs{d})(frames_pre,:),1);
        poststim_mean=mean(dF_byDS.(cellNames{c}).(DCs{d})(frames_post,:),1);
        
        
        [~,p_pos]=ttest2(prestim_mean,poststim_mean,'Tail','left');
        [~,p_neg]=ttest2(prestim_mean,poststim_mean,'Tail','right');
        
        pPos_dc(d)=p_pos;
        pNeg_dc(d)=p_neg;
    end
   
    pPos_pr=zeros(length(Pr),1);
    pNeg_pr=pPos_pr;
    
    for d=1:length(Pr)
         prestim_mean=mean(dF_byPressure.(cellNames{c}).(Pr{d})(frames_pre,:),1);
        poststim_mean=mean(dF_byPressure.(cellNames{c}).(Pr{d})(frames_post,:),1);
        
        
        [~,p_pos]=ttest2(prestim_mean,poststim_mean,'Tail','left');
        [~,p_neg]=ttest2(prestim_mean,poststim_mean,'Tail','right');
         
        pPos_pr(d)=p_pos;
        pNeg_pr(d)=p_neg;
    end
   
    pPos=[pPos_dc; pPos_pr];
%     pmins=pmins/length(pmins);
    
    pNeg=[pNeg_dc; pNeg_pr];
%     pmaxes=pmaxes/length(pmaxes);
    
    pvals_pos.(cellNames{c})=pPos;
    pvals_neg.(cellNames{c})=pNeg;
end
end

