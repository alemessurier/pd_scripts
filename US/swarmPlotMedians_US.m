function swarmPlotMedians_US(dF_byDC,dF_byPressure,poststim,DC_labels,pressure_labels,expt_name)
cellNames=fieldnames(dF_byDC);
DCsweep = make_DCsweep( dF_byDC,cellNames,poststim );
pressSweep = make_DCsweep( dF_byPressure,cellNames,poststim );


% %% swarmplot of mean responses
% figure; hold on
% dcData=num2cell(DCsweep.meanByCell,1);
% DCstring=num2cell(DC_labels);
% DCstring=cellfun(@(x)num2str(x),DCstring,'un',0);
% h_DC=plotSpread(dcData,[],[],DCstring,4);
% for i=3:3+length(DC_labels)-1;
%     h_DC{3}.Children(i).MarkerSize=10;
% end
%     
% xlabel('duty cycle (%)')
% ylabel('dF/F')
% title('mean evoked dF/F')
% 
% figure; hold on
% dcData=num2cell(pressSweep.meanByCell,1);
% Pstring=num2cell(pressure_labels);
% Pstring=cellfun(@(x)num2str(x),Pstring,'un',0);
% h_press=plotSpread(dcData,[],[],Pstring,4);
% for i=3:3+length(pressure_labels)-1;
%     h_press{3}.Children(i).MarkerSize=10;
% end
%     
% xlabel('pressure (MPa)')
% ylabel('dF/F')
% title('mean evoked dF/F')

%% swarmplot of median responses
figure; hold on
dcData=num2cell(DCsweep.medianByCell,1);
DCstring=num2cell(DC_labels);
DCstring=cellfun(@(x)num2str(x),DCstring,'un',0);
h_DC=plotSpread(dcData,[],[],DCstring,4);
for i=3:3+length(DC_labels)-1;
    h_DC{3}.Children(i).MarkerSize=10;
%     h_DC{3}.Children(i).Marker='o';
    h_DC{3}.Children(i).MarkerEdgeColor=[ 0.5 0.5 0.5]

end
    
xlabel('duty cycle (%)')
ylabel('dF/F')
title([expt_name]);%,', median evoked dF/F'])
tmp=gca;
tmp.YLim=[-0.5 0.5];
% tmp.Position=[0.2340 0.1332 0.6710 0.7906];
figure; hold on
dcData=num2cell(pressSweep.medianByCell,1);
Pstring=num2cell(pressure_labels);
Pstring=cellfun(@(x)num2str(x),Pstring,'un',0);
h_press=plotSpread(dcData,[],[],Pstring,4);
for i=3:3+length(pressure_labels)-1;
    h_press{3}.Children(i).MarkerSize=10;
      h_press{3}.Children(i).MarkerEdgeColor=[ 0.5 0.5 0.5]
end
    
xlabel('pressure (MPa)')
ylabel('dF/F')
title([expt_name]);%,', median evoked dF/F'])

tmp=gca;
tmp.YLim=[-0.5 0.5];
% tmp.Position=[0.2340 0.1332 0.6710 0.7906];
