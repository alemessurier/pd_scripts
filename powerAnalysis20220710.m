%% power analysis for difference in mean baseline activity during calls

meanDF_calls_IC=mean(meanDF_total_calls_IC);
meanDF_calls_PS=mean(meanDF_total_calls_PS);
stdDF_calls_IC=std(meanDF_total_calls_IC);
stdDF_calls_PS=std(meanDF_total_calls_PS);

nout = sampsizepwr('t',[meanDF_calls_IC stdDF_calls_IC],meanDF_calls_PS,0.80)

nn = 1:100;
pwrout = sampsizepwr('t',[meanDF_calls_IC stdDF_calls_IC],meanDF_calls_PS,[],nn);

figure;
plot(nn,pwrout,'b-',nout,0.8,'ro')
title('Power versus Sample Size')
xlabel('Sample Size')
ylabel('Power')

%% power analysis for difference in mean call responses

meanCallEvoked_PS=median(meanCallbyCell_PS);
meanCallEvoked_IC=median(meanCallbyCell_IC);
stdCallEvoked_PS=std(meanCallbyCell_PS);
stdCallEvoked_IC=std(meanCallbyCell_IC);

nn = 1:100;
pwrout = sampsizepwr('t',[meanCallEvoked_IC stdCallEvoked_PS],meanCallEvoked_PS,[],nn);

figure;
plot(nn,pwrout,'b-',nout,0.8,'ro')
title('Power versus Sample Size')
xlabel('Sample Size')
ylabel('Power')
