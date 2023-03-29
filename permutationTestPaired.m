function P = permutationTestPaired(A,B,numReps,avgType)

% find differences between pairs
true_diffs=A-B;
num_diffs=length(true_diffs);
switch avgType
    case 'median'
        T=median(true_diffs);
        
        % randomize signs of differences t times
        for t = 1:numReps
            signs_t=randsample([-1,1],num_diffs,1);
            diffs_t=true_diffs.*signs_t;
            PT(t)=median(diffs_t);
        end
    case 'mean'
        T=mean(true_diffs);
        
        % randomize signs of differences t times
        for t = 1:numReps
            signs_t=randsample([-1,1],num_diffs,1);
            diffs_t=true_diffs.*signs_t;
            PT(t)=mean(diffs_t);
        end
end

PT(t+1)=T;

P=sum(PT>=T)/length(PT);