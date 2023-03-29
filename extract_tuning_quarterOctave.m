function [ tuning ] = extract_tuning_quarterOctave( tonesPath,stimFrames,df_byTrial )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tones=dlmread(tonesPath);
tones=tones(3:20);
[tonesSorted,tonesidx]=unique(tones);
stimFrames=stimFrames(tonesidx);
cellNames=fieldnames(df_byTrial);

tuning=struct();
for c=1:length(cellNames)
    data=df_byTrial.(cellNames{c})';
    all_reps=cell(length(tonesidx),1);
    means=zeros(1,length(stimFrames));
    meds=means;
    sems=meds;
    for frame=1:length(stimFrames)
        stimFrame=stimFrames(frame);
        chunk=data((stimFrame-30):(stimFrame+60),:);
        bl_sub=zeros(size(chunk));
        for col=1:size(chunk,2)
            bl_sub(:,col)=chunk(:,col)-mean(chunk(1:30,col),1);
        end
        all_reps{frame}=bl_sub;
        means(frame)=mean(mean(bl_sub(31:60,:),1));
        meds(frame)=median(mean(bl_sub(31:60,:),1));
        sems(frame)=std(mean(bl_sub(31:60,:),1))/sqrt(size(bl_sub,2));
    end
    
    tuning(c).byTone=all_reps;
    tuning(c).tones=tonesSorted;
    tuning(c).mean=means;
    tuning(c).median=meds;
    tuning(c).sem=sems;
    tuning(c).cellName=cellNames{c};
end




end

