%% load in data
path_warpShifted='/Users/aml717/data/reduced/IC603/field1/shiftwarped.mat';
load(path_warpShifted)
day=2;
aligned_data=aligned_data{day};
data_raw=data_raw{day};
trial_shifts=trial_shifts{day};
callIDs_byTrial=callIDs_byTrial{day};
model_attributes=model_attributes{day};
%%


callIDs=unique(callIDs_byTrial);

for c=1:length(callIDs)
    aligned_data_byCall{c}=aligned_data(callIDs_byTrial==callIDs(c),:,:);
    raw_data_byCall{c}=data_raw(callIDs_byTrial==callIDs(c),:,:);
end
%%

for i=1:size(data_raw,3)
    fig=figure; hold on
    fig.Position=[1655 55 1234 494];
    for c=1:length(callIDs)
        
        subplot(3,6,c)
        hold on
        plot(mean(raw_data_byCall{c}(:,:,i)),'r')
        plot(mean(aligned_data_byCall{c}(:,:,i)),'k')

        subplot(3,6,c+6)
        imagesc(raw_data_byCall{c}(:,:,i))
        axis square
        colormap gray
    
        subplot(3,6,c+12)
        imagesc(aligned_data_byCall{c}(:,:,i))
        axis square
        colormap gray
    
    end
end
