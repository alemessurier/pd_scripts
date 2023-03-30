%% multi-day tracked corticocollicular data:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rerun_multiday=1; % flag for re-running pupCall_multidayROIs from scratch; 1=rerun; 0=no
%% IC622
paths_IC{1}={'/Users/aml717/data/reduced/IC622/20220718/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC622/20220719/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC622/20220720/suite2p/plane0/'};

matchFilePath_IC{1}='/Users/aml717/data/reduced/IC622/IC622_roiMatch.mat';
behaviorPath_IC{1}='/Users/aml717/data/reduced/IC622/retrieve.mat';
save_path='/Users/aml717/data/reduced/IC622/';
dayCohoused_IC{1}=[0,1,2];
cd(save_path)
tmp=dir('MultiDayROIs.mat');
if isempty(tmp) || rerun_multiday==1
    [~,allDates_calls_IC{1},~,...
        ~,allDates_tones_IC{1},~,...
        MultiDayROIs_calls_IC{1},~,MultiDayROIs_tones_IC{1}]=...
        pupCall_multidayROIs_multiISI(matchFilePath_IC{1},paths_IC{1},save_path);
else
    load([save_path,'MultiDayROIs.mat'],'allDates_calls_5sec',...
        'allDates_tones_3sec','MultiDayROIs_calls_5sec','MultiDayROIs_tones_3sec');
    allDates_calls_IC{1}=allDates_calls_5sec;
    allDates_tones_IC{1}=allDates_tones_3sec;
    MultiDayROIs_calls_IC{1}=MultiDayROIs_calls_5sec;
    MultiDayROIs_tones_IC{1}=MultiDayROIs_tones_3sec;
end

% for i=1:length(paths_2p)
% pupCall_imaging_pipeline_multiISI_spikes(paths_2p{i},0);
% end
%% IC623
paths_IC{2}={'/Users/aml717/data/reduced/IC623/20220718/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC623/20220719/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC623/20220720/suite2p/plane0/'};
% for i=1:length(paths_2p)
% pupCall_imaging_pipeline_multiISI_spikes(paths_2p{i},0);
% end
matchFilePath_IC{2}='/Users/aml717/data/reduced/IC623/IC623_roiMatch.mat';
behaviorPath_IC{2}='/Users/aml717/data/reduced/IC623/retrieve.mat';
save_path='/Users/aml717/data/reduced/IC623/';
dayCohoused_IC{2}=[0,1,2];

cd(save_path)
tmp=dir('MultiDayROIs.mat');
if isempty(tmp) || rerun_multiday==1
    [~,allDates_calls_IC{2},~,...
        ~,allDates_tones_IC{2},~,...
        MultiDayROIs_calls_IC{2},~,MultiDayROIs_tones_IC{2}]=...
        pupCall_multidayROIs_multiISI(matchFilePath_IC{2},paths_IC{2},save_path);
else
    load([save_path,'MultiDayROIs.mat'],'allDates_calls_5sec',...
        'allDates_tones_3sec','MultiDayROIs_calls_5sec','MultiDayROIs_tones_3sec');
    allDates_calls_IC{2}=allDates_calls_5sec;
    allDates_tones_IC{2}=allDates_tones_3sec;
    MultiDayROIs_calls_IC{2}=MultiDayROIs_calls_5sec;
    MultiDayROIs_tones_IC{2}=MultiDayROIs_tones_3sec;
end
%% IC603 field 1
paths_IC{3} = {'/Users/aml717/data/reduced/IC603/20220627/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC603/20220628/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC603/20220629/field1/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC603/20220630/field1/suite2p/plane0/'};
% for i=1:length(paths_2p)
% pupCall_imaging_pipeline_multiISI_spikes(paths_2p{i},0);
% end

matchFilePath_IC{3} ='/Users/aml717/data/reduced/IC603/field1/IC603_matchROI_field1.mat';
behaviorPath_IC{3}='/Users/aml717/data/reduced/IC603/retrieve.mat';
save_path='/Users/aml717/data/reduced/IC603/field1/';
dayCohoused_IC{3}=[0,1,2,3];

cd(save_path)
tmp=dir('MultiDayROIs.mat');
if isempty(tmp) || rerun_multiday==1
    [~,allDates_calls_IC{3},~,...
        ~,allDates_tones_IC{3},~,...
        MultiDayROIs_calls_IC{3},~,MultiDayROIs_tones_IC{3}]=...
        pupCall_multidayROIs_multiISI(matchFilePath_IC{3},paths_IC{3},save_path);
else
    load([save_path,'MultiDayROIs.mat'],'allDates_calls_5sec',...
        'allDates_tones_3sec','MultiDayROIs_calls_5sec','MultiDayROIs_tones_3sec');
    allDates_calls_IC{3}=allDates_calls_5sec;
    allDates_tones_IC{3}=allDates_tones_3sec;
    MultiDayROIs_calls_IC{3}=MultiDayROIs_calls_5sec;
    MultiDayROIs_tones_IC{3}=MultiDayROIs_tones_3sec;
end
%% IC603 field 2 - excluded from multi-day tracking because not imaged day 0
% paths_2p{4} = {'/Users/aml717/data/reduced/IC603/20220629/field2/suite2p/plane0/',...
%     '/Users/aml717/data/reduced/IC603/20220630/field2/suite2p/plane0/'};
% matchFilePath{4} ='/Users/aml717/data/reduced/IC603/field2/IC603_matchROI_field2.mat';
% behaviorPath{4} ='/Users/aml717/data/reduced/IC603/retrieve.mat';
% % pupCall_imaging_pipeline_multiISI_spikes(paths_2p{2},0)
%% IC 617 field 1
paths_IC{4} = {'/Users/aml717/data/reduced/IC617/20220703/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC617/20220705/field1/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC617/20220706/field1/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC617/20220707/field1/suite2p/plane0/'};
matchFilePath_IC{4} ='/Users/aml717/data/reduced/IC617/field1/IC617_field1_roiMatch.mat';
behaviorPath_IC{4} ='/Users/aml717/data/reduced/IC617/retrieve.mat';
save_path='/Users/aml717/data/reduced/IC617/field1/';
dayCohoused_IC{4}=[0,2,3,4];

cd(save_path)
tmp=dir('MultiDayROIs.mat');
if isempty(tmp) || rerun_multiday==1
    [~,allDates_calls_IC{4},~,...
        ~,allDates_tones_IC{4},~,...
        MultiDayROIs_calls_IC{4},~,MultiDayROIs_tones_IC{4}]=...
        pupCall_multidayROIs_multiISI(matchFilePath_IC{4},paths_IC{4},save_path);
else
    load([save_path,'MultiDayROIs.mat'],'allDates_calls_5sec',...
        'allDates_tones_3sec','MultiDayROIs_calls_5sec','MultiDayROIs_tones_3sec');
    allDates_calls_IC{4}=allDates_calls_5sec;
    allDates_tones_IC{4}=allDates_tones_3sec;
    MultiDayROIs_calls_IC{4}=MultiDayROIs_calls_5sec;
    MultiDayROIs_tones_IC{4}=MultiDayROIs_tones_3sec;
end
%% IC824 over days
paths_IC{5} = {'/Users/aml717/data/reduced/IC824/20210927/f1/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC824/20210928/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC824/20210929/suite2p/plane0/',...
    '/Users/aml717/data/reduced/IC824/20211001/suite2p/plane0/'};
matchFilePath_IC{5}='/Users/aml717/data/reduced/IC824/IC824_matchROIs.mat';
save_path='/Users/aml717/data/reduced/IC824/';
dayCohoused_IC{5}=[0,1,2,5];

cd(save_path)
tmp=dir('MultiDayROIs.mat');
if isempty(tmp) || rerun_multiday==1
    [allDates_calls_IC{5},allDates_tones_IC{5},...
        MultiDayROIs_calls_IC{5},MultiDayROIs_tones_IC{5}]=...
        pupCall_multidayROIs_load(matchFilePath_IC{5},paths_IC{5},save_path);
else
    load([save_path,'MultiDayROIs.mat']);
    allDates_calls_IC{5}=allDates_calls;
    allDates_tones_IC{5}=allDates_tones;
    MultiDayROIs_calls_IC{5}=MultiDayROIs_calls;
    MultiDayROIs_tones_IC{5}=MultiDayROIs_tones;
end

%% IC 617 field 2 - excluded from multi-day tracking because not imaged day 0
% paths_2p{6} = {'/Users/aml717/data/reduced/IC617/20220705/field2/suite2p/plane0/',...
%         '/Users/aml717/data/reduced/IC617/20220706/field2/suite2p/plane0/',...
%     '/Users/aml717/data/reduced/IC617/20220707/field2/suite2p/plane0/'};
% 
% 
% matchFilePath{6} ='/Users/aml717/data/reduced/IC617/field2/IC617_field2_roiMatch.mat';
% behaviorPath{6} ='/Users/aml717/data/reduced/IC617/retrieve.mat';
% % for i=1:length(paths_2p)
% % pupCall_imaging_pipeline_multiISI_spikes(paths_2p{i},0);
% % end

%% multi-day tracked corticostriatal data:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PS715 over days f1
paths_PS{1} = {'/Users/aml717/data/reduced/PS715/20210731/f1/suite2p/plane0/',...
    '/Users/aml717/data/reduced/PS715/20210802/f1/suite2p/plane0/',...
    '/Users/aml717/data/reduced/PS715/20210804/f1/suite2p/plane0/',...
    '/Users/aml717/data/reduced/PS715/20210805/f1/suite2p/plane0/',...
    '/Users/aml717/data/reduced/PS715/20210806/f1/suite2p/plane0/'};
matchFilePath_PS{1}='/Users/aml717/data/reduced/PS715/PS715_f1_ROImatch.mat';
% behaviorPath_PS{1}=
save_path='/Users/aml717/data/reduced/PS715/f1/';
% for d=1:length(paths_2p)
%     pupCall_imaging_pipeline(paths_2p{d},0)
% end
dayCohoused_PS{1}=[0,2,4,5,6];

cd(save_path)
tmp=dir('MultiDayROIs.mat');
if isempty(tmp) || rerun_multiday==1
    [allDates_calls_PS{1},allDates_tones_PS{1},...
        MultiDayROIs_calls_PS{1},MultiDayROIs_tones_PS{1}]=...
        pupCall_multidayROIs_load(matchFilePath_PS{1},paths_PS{1},save_path);
else
    load([save_path,'MultiDayROIs.mat']);
    allDates_calls_PS{1}=allDates_calls;
    allDates_tones_PS{1}=allDates_tones;
    MultiDayROIs_calls_PS{1}=MultiDayROIs_calls;
    MultiDayROIs_tones_PS{1}=MultiDayROIs_tones;
end

%% PS715 over days f2
paths_PS{2} = {'/Users/aml717/data/reduced/PS715/20210731/f2/suite2p/plane0/',...
    '/Users/aml717/data/reduced/PS715/20210802/f2/suite2p/plane0/',...
    '/Users/aml717/data/reduced/PS715/20210803/f2/suite2p/plane0/',...
    '/Users/aml717/data/reduced/PS715/20210804/f2/suite2p/plane0/',...
    '/Users/aml717/data/reduced/PS715/20210805/f2/suite2p/plane0/',...
    '/Users/aml717/data/reduced/PS715/20210806/f2/suite2p/plane0/'};

matchFilePath_PS{2}='/Users/aml717/data/reduced/PS715/PS715_f2_ROImatch.mat';
% behaviorPath_PS{1}=
save_path='/Users/aml717/data/reduced/PS715/f2/';
% for d=1:length(paths_PS{2})
%     pupCall_imaging_pipeline(paths_PS{2}{d},0)
% end
dayCohoused_PS{2}=[0,2,3,4,5,6];

cd(save_path)
tmp=dir('MultiDayROIs.mat');
if isempty(tmp) || rerun_multiday==1
    [allDates_calls_PS{2},allDates_tones_PS{2},...
        MultiDayROIs_calls_PS{2},MultiDayROIs_tones_PS{2}]=...
        pupCall_multidayROIs_load(matchFilePath_PS{2},paths_PS{2},save_path);
else
    load([save_path,'MultiDayROIs.mat']);
    allDates_calls_PS{2}=allDates_calls;
    allDates_tones_PS{2}=allDates_tones;
    MultiDayROIs_calls_PS{2}=MultiDayROIs_calls;
    MultiDayROIs_tones_PS{2}=MultiDayROIs_tones;
end

%% PS526 field 1
paths_PS{3} = {'/Users/aml717/data/reduced/PS526/20220628/field1/suite2p/plane0/',...
    '/Users/aml717/data/reduced/PS526/20220629/field1/suite2p/plane0/',...
    '/Users/aml717/data/reduced/PS526/20220630/suite2p/plane0/'};
matchFilePath_PS{3} ='/Users/aml717/data/reduced/PS526/PS526_field1_roiMatch.mat';
save_path='/Users/aml717/data/reduced/PS526/';
dayCohoused_PS{3}=[0,1,2];

cd(save_path)
tmp=dir('MultiDayROIs.mat');
if isempty(tmp) || rerun_multiday==1
    [~,allDates_calls_PS{3},~,...
        ~,allDates_tones_PS{3},~,...
        MultiDayROIs_calls_PS{3},~,MultiDayROIs_tones_PS{3}]=...
        pupCall_multidayROIs_multiISI(matchFilePath_PS{3},paths_PS{3},save_path);
else
    load([save_path,'MultiDayROIs.mat'],'allDates_calls_5sec',...
        'allDates_tones_3sec','MultiDayROIs_calls_5sec','MultiDayROIs_tones_3sec');
    allDates_calls_PS{3}=allDates_calls_5sec;
    allDates_tones_PS{3}=allDates_tones_3sec;
    MultiDayROIs_calls_PS{3}=MultiDayROIs_calls_5sec;
    MultiDayROIs_tones_PS{3}=MultiDayROIs_tones_3sec;
end
%% PS526 field 2 - excuded from multi-day tracking due to different depths day 1/day2
% paths_2p = {'/Users/aml717/data/reduced/PS526/20220628/field2/suite2p/plane0/',...
%     '/Users/aml717/data/reduced/PS526/20220629/field2/suite2p/plane0/'}
% for i=1:length(paths_2p)
% pupCall_imaging_pipeline_multiISI_spikes(paths_2p{i},0);
% end
% %% PS525 - excluded from multi-day tracking - day 1 looks weird and bad??
% 
% paths_2p{8}={'/Users/aml717/data/reduced/PS525/20220628/suite2p/plane0/',...
%     '/Users/aml717/data/reduced/PS525/20220629/suite2p/plane0/',...
%     '/Users/aml717/data/reduced/PS525/20220630/suite2p/plane0/'};
% for i=1:length(paths_2p)
% pupCall_imaging_pipeline_multiISI_spikes(paths_2p{i},0);
% end