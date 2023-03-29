function [pvals_min,pvals_max ] = find_USmodulation_P( dF_byDS,dF_byPressure,stimFrame,prestim,poststim )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cellNames=fieldnames(dF_byDS);
DCs=fieldnames(dF_byDS.(cellNames{1}));
Pr=fieldnames(dF_byPressure.(cellNames{1}));
frames_pre=(stimFrame-prestim):(stimFrame-1);
frames_post=(stimFrame+6):(stimFrame+poststim);
for c=1:length(cellNames)
    
    pmin_dc=zeros(length(DCs),1);
    pmax_dc=pmin_dc;
    
    for d=1:length(DCs)
        
        prestim_min=min(dF_byDS.(cellNames{c}).(DCs{d})(frames_pre,:),[],1);
        poststim_min=min(dF_byDS.(cellNames{c}).(DCs{d})(frames_post,:),[],1);
        
        prestim_max=max(dF_byDS.(cellNames{c}).(DCs{d})(frames_pre,:),[],1);
        poststim_max=max(dF_byDS.(cellNames{c}).(DCs{d})(frames_post,:),[],1);
        
        [~,pmin]=ttest2(prestim_min,poststim_min);
        [~,pmax]=ttest2(prestim_max,poststim_max);
        
        pmin_dc(d)=pmin;
        pmax_dc(d)=pmax;
    end
   
    pmin_pr=zeros(length(Pr),1);
    pmax_pr=pmin_pr;
    
    for d=1:length(Pr)
        
        prestim_min=min(dF_byPressure.(cellNames{c}).(Pr{d})(frames_pre,:),[],1);
        poststim_min=min(dF_byPressure.(cellNames{c}).(Pr{d})(frames_post,:),[],1);
        
        prestim_max=max(dF_byPressure.(cellNames{c}).(Pr{d})(frames_pre,:),[],1);
        poststim_max=max(dF_byPressure.(cellNames{c}).(Pr{d})(frames_post,:),[],1);
        
        [~,pmin]=ttest2(prestim_min,poststim_min);
        [~,pmax]=ttest2(prestim_max,poststim_max);
        
        pmin_pr(d)=pmin;
        pmax_pr(d)=pmax;
    end
   
    pmins=[pmin_dc; pmin_pr];
%     pmins=pmins/length(pmins);
    
    pmaxes=[pmax_dc; pmax_pr];
%     pmaxes=pmaxes/length(pmaxes);
    
    pvals_min.(cellNames{c})=pmins;
    pvals_max.(cellNames{c})=pmaxes;
end
end

