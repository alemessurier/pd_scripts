function DCsweep = make_DCsweep( dF_byDC,cellNames,poststim )


%% separate df/f by trial/DC/cell
DCs=fieldnames(dF_byDC.(cellNames{1}));
meanByCell=zeros(length(cellNames),length(DCs));
medianByCell=meanByCell;
stdByCell=meanByCell;
semByCell=meanByCell;

for dc=1:length(DCs)
    fn=DCs{dc};
    tmpEvoked=cellfun(@(x)mean(dF_byDC.(x).(fn)(poststim,:),1),cellNames,'un',0);
    tmpEvoked=cat(1,tmpEvoked{:});
    DCsweep.(fn)=tmpEvoked;
    meanByCell(:,dc)=mean(tmpEvoked,2);
    medianByCell(:,dc)=median(tmpEvoked,2);
    stdByCell(:,dc)=std(tmpEvoked,[],2);
    semByCell(:,dc)=stdByCell(:,dc)/sqrt(size(tmpEvoked,2));
        
end
meanAll=mean(meanByCell,1);
medianAll=median(medianByCell,1);
stdAll=std(meanByCell,[],1);
semAll=stdAll/sqrt(size(meanAll,1));
DCsweep.meanByCell=meanByCell;
DCsweep.medianByCell=medianByCell;
DCsweep.stdByCell=stdByCell;
DCsweep.semByCell=semByCell;
DCsweep.meanAll=meanAll;
DCsweep.medianAll=medianAll;
DCsweep.stdAll=stdAll;
DCsweep.semAll=semAll;
end

