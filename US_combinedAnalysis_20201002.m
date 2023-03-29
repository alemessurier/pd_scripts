%%
expt(1)=load('F:\US\SST131\reduced\20201001\suite2p\plane0\analysis_01-Oct-2020.mat');
expt(2)=load('F:\US\SST130\reduced\suite2p\plane0\analysis_02-Oct-2020.mat');
expt(3)=load('F:\US\VIP214\reduced\suite2p\plane0\analysis_01-Oct-2020.mat');
expt(4)=load('F:\reduced\USNM\NDNF6172\hearing\suite2p\plane0\analysis_01-Oct-2020.mat');
expt(5)=load('F:\reduced\USNM\NDNF691\suite2p\plane0\analysis_02-Oct-2020.mat');
expt(6)=load('F:\reduced\USNM\NDNF219\suite2p\plane0\analysis_01-Oct-2020.mat');
expt(7)=load('F:\reduced\USNM\NDNF217\suite2p\plane0\analysis_01-Oct-2020.mat');

DCs_byExpt=arrayfun(@(x)fieldnames(x.dF_byDC_Z.cell1),expt,'un',0);
DCs=cat(1,DCs_byExpt{:});
DCs=unique(DCs);
DCs={'DC5';'DC10'; 'DC20'; 'DC30'; 'DC40'; 'DC50'}

press_byExpt=arrayfun(@(x)fieldnames(x.dF_byPressure_Z.cell1),expt,'un',0);
press=cat(1,press_byExpt{:});
press=unique(press);
stimFrame=150;
poststim=(stimFrame+15):(stimFrame+60);

expt_names={'SST131','SST130','VIP214','NDNF6172','NDNF691','NDNF219','NDNF217'};
%%
for e=1:numel(expt)
% US_plotScaledHeathmap(expt(e).dF_byDC_Z,expt(e).stimFrame,expt(e).dF_byPressure_Z,fieldnames(expt(e).dF_byDC),poststim,-2.5,2.5,-5,10)
% title([expt_names{e},', Z-scored'])
US_plotScaledHeathmap(expt(e).dF_byDC,expt(e).stimFrame,expt(e).dF_byPressure,fieldnames(expt(e).dF_byDC),poststim,-2.5,2.5,-5,10)
title(expt_names{e})
end

%% swarm plots
for e=1:numel(expt)
    swarmPlotMedians_US(expt(e).dF_byDC,expt(e).dF_byPressure,poststim,expt(e).DC_labels,expt(e).pressure_labels,expt_names{e})
end