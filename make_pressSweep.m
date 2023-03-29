function [ pressSweep,dF_byPressure ] = make_pressSweep( dF_byTrial,press,cellNames,duty,pressure,poststim )
% calculate modulation for each trial for each cell

evokedByTrial=cellfun(@(x)mean(dF_byTrial.(x)(poststim,:),1),cellNames,'un',0);
evokedByTrial=cat(1,evokedByTrial{:});


%% separate df/f by trial/DC/cell

meanByCell=zeros(length(cellNames),length(press));
medianByCell=meanByCell;
stdByCell=meanByCell;
semByCell=meanByCell;

for dc=1:length(press)
   idx_dc=pressure==press(dc) & duty=='50';
    fn=['MPa',char(press(dc))];
    pressSweep.(fn)=evokedByTrial(:,idx_dc);
    meanByCell(:,dc)=mean(evokedByTrial(:,idx_dc),2);
    medianByCell(:,dc)=median(evokedByTrial(:,idx_dc),2);
    stdByCell(:,dc)=std(evokedByTrial(:,idx_dc),[],2);
    semByCell(:,dc)=stdByCell(:,dc)/sqrt(size(evokedByTrial(:,idx_dc),2));
    
   
    for c=1:length(cellNames)
        dF_byPressure.(cellNames{c}).(fn)=dF_byTrial.(cellNames{c})(:,idx_dc);
    end
        
end
meanAll=mean(meanByCell,1);
medianAll=median(medianByCell,1);
stdAll=std(meanByCell,[],1);
semAll=stdAll/sqrt(size(meanAll,1));
pressSweep.meanByCell=meanByCell;
pressSweep.medianByCell=medianByCell;
pressSweep.stdByCell=stdByCell;
pressSweep.semByCell=semByCell;
pressSweep.meanAll=meanAll;
pressSweep.medianAll=medianAll;
pressSweep.stdAll=stdAll;
pressSweep.semAll=semAll;
end

