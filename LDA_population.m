function [class,err,coeff]=LDA_population(data,classIdx,model)

%% LDA classifier - leave-one-out
rng('default') % For reproducibility
cv = cvpartition(length(classIdx),'LeaveOut');
for i=1:length(classIdx)
trainInds = training(cv,i);
sampleInds = test(cv,i);
trainingData = data(trainInds,:);
sampleData = data(sampleInds,:);
[class(i),err(i),~,~,coeff{i}]= classify(sampleData,trainingData,classIdx(trainInds),model);
end
cm = confusionchart(classIdx,class);