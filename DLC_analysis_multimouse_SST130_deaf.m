%% load in csvs, convert to structures
csv_path='E:\mouse_vid\multi_mouse_model\SST130_deaf\';
cd(csv_path);
files=dir('*.csv');

for i=1:length(files)
    fname=files(i).name;
    a=strfind(fname,'DLC');
    resName=fname(1:(a-1));
    results.(resName)=read_DLC_CSV(fname);
    movie_name{i}=fname;
end

newNames={'SST130_20200316_08MPa_5DC',...
'SST130_20200316_08MPa_10DC',...
'SST130_20200316_08MPa_20DC',...
'SST130_20200316_08MPa_30DC',...
'SST130_20200316_08MPa_50DC',...
'SST130_20200316_06MPa_50DC',...
'SST130_20200316_04MPa_50DC',...
'SST130_20200316_02MPa_50DC',...
'SST130_20200316_0MPa_50DC'}


save([csv_path,'tracking_results.mat'],'results','newNames');
%% plots
fns=fieldnames(results);
frameRate=23.8;
for f=1:length(fns)
    figure; hold on
    
    frames=results.(fns{f}).bodyparts.coords;
    time=frames/frameRate;
    
    nose_y=results.(fns{f}).nose.y;
    nose_x=results.(fns{f}).nose.x;
    nose=sqrt(nose_x.^2+nose_y.^2);
    
    lower_lip_y=results.(fns{f}).lower_lip.y;
    lower_lip_x=results.(fns{f}).lower_lip.x;
    lower_lip=sqrt(lower_lip_x.^2+lower_lip_y.^2);
    
    right_lip_y=results.(fns{f}).right_lip.y;
    right_lip_x=results.(fns{f}).right_lip.x;
    right_lip=sqrt(right_lip_x.^2+right_lip_y.^2);
    
    subplot(6,1,1)
    plot(time,nose,'k.')
    ylabel('nose position')
    title(fns{f})
    
    subplot(6,1,2)
    plot(time,results.(fns{f}).nose.likelihood);
    ylabel('nose likelihood')
    
    subplot(6,1,3)
    plot(time,lower_lip,'k.')
    ylabel('lower_lip position')
    
    subplot(6,1,4)
    plot(time,results.(fns{f}).lower_lip.likelihood);
    ylabel('lower_lip likelihood')
    
    subplot(6,1,5)
    plot(time,right_lip,'k.')
    ylabel('right_lip position')
    
    subplot(6,1,6)
    plot(time,results.(fns{f}).right_lip.likelihood);
    ylabel('right_lip likelihood')
    xlabel('time')
    
    results.(fns{f}).frames=frames;
    results.(fns{f}).nose.pos=nose;
    results.(fns{f}).lower_lip.pos=lower_lip;
    results.(fns{f}).right_lip.pos=right_lip;
end

%%
load('E:\mouse_vid\multi_mouse_model\SST130_deaf\raw_vid\vidInfo.mat')
% vidInfo_new=vidInfo([1:4,6:10])
% vidInfo=vidInfo_new;
% save('E:\mouse_vid\multi_mouse_model\SST130_deaf\raw_vid\vidInfo.mat','vidInfo')

 for i=1:length(vidInfo)
    frames=1:length(vidInfo(i).laserOn);
    fn=vidInfo(i).fname;
    ix=strfind(fn,'.mp4');
    fn=fn(1:(ix-1));
    
    time=frames/vidInfo(i).FrameRate;
    figure; hold on
    plot(time, vidInfo(i).laserOn);
    ix_low=vidInfo(i).laserOn<30;
    ix_low=diff(ix_low);
    acq_start_ix=ix_low==-1
    acqStart_F=frames(acq_start_ix);
    acqStart_T=time(acq_start_ix);
    vline(acqStart_T);
    delayF=floor(5*vidInfo(i).FrameRate);
    
    stimFrames=acqStart_F+delayF;
    stimTimes=acqStart_T+5;
    results.(fn).time=time;
    results.(fn).frames=frames;
    results.(fn).acqStart_F=acqStart_F;
    results.(fn).acqStart_T=acqStart_T;
    results.(fn).stimFrames=stimFrames;
    results.(fn).stimTimes=stimTimes;
    title(fn)
 end
 
 %% remove positions with likelihood <95%

for f=1:length(fns)
    lh_nose=results.(fns{f}).nose.likelihood;
    pos_nose=results.(fns{f}).nose.pos;
    lh_lip=results.(fns{f}).lower_lip.likelihood;
    pos_lip=results.(fns{f}).lower_lip.pos;
    
    bad_nose=lh_nose<0.95;
    pos_nose_nan=pos_nose;
    pos_nose_nan(bad_nose)=nan;
    pos_nose_filt = slidingAvg_nans( pos_nose_nan,2,'median' );
    
    bad_lip=lh_lip<0.95;
    pos_lip_nan=pos_lip;
    pos_lip_nan(bad_lip)=nan;
    pos_lip_filt = slidingAvg_nans( pos_lip_nan,2,'median' );
    results.(fns{f}).nose.pos=pos_nose_filt;
    results.(fns{f}).lower_lip.pos=pos_lip_filt;
    
    figure; hold on
    
    subplot(4,1,1)
    plot(pos_nose,'k.');
    subplot(4,1,2);
    plot(pos_nose_filt,'k.');
    subplot(4,1,3)
    plot(pos_lip,'k.');
    subplot(4,1,4);
    plot(pos_lip_filt,'k.');
end
 %% which aquisitions to use for 2p data
acqsUse_2p.(newNames{1})=[1:14,16];
acqsUse_2p.(newNames{2})=10:16;
acqsUse_2p.(newNames{3})=[2:6,8:16];
acqsUse_2p.(newNames{4})=[2:12,14:16];
acqsUse_2p.(newNames{5})=4:16;
acqsUse_2p.(newNames{6})=1:13;
acqsUse_2p.(newNames{7})=1:16;
acqsUse_2p.(newNames{8})=1:16;
acqsUse_2p.(newNames{9})=1:16;


acqsUse_vid.(newNames{1})=1:15;
acqsUse_vid.(newNames{2})=1:7;
acqsUse_vid.(newNames{3})=1:14;
acqsUse_vid.(newNames{4})=1:14;
acqsUse_vid.(newNames{5})=1:13;
acqsUse_vid.(newNames{6})=1:13;
acqsUse_vid.(newNames{7})=1:16;
acqsUse_vid.(newNames{8})=1:16;
acqsUse_vid.(newNames{9})=1:16;



%%
% ISI_F=620;
% ISI_T=26.007;
fns=fieldnames(results) 
ptsToAvg=4;
 for f=1:length(fns)
     
%      ISI_F=mode(diff(results.(fns{f}).acqStart_F))
%       ISI_T=mode(diff(results.(fns{f}).acqStart_T))
    figure; hold on
    
    frames=results.(fns{f}).bodyparts.coords;
    time=frames/frameRate;
    stimTimes=results.(fns{f}).stimTimes;
    
    % correct stimFrames/times in case some onsets not detected
%     acqStart_F_corrected=results.(fns{f}).acqStart_F(1):ISI_F:results.(fns{f}).acqStart_F(end)+1;
%     acqStart_T_corrected=results.(fns{f}).acqStart_T(1):ISI_T:results.(fns{f}).acqStart_T(end)+1;
%     stimTimes_corrected=acqStart_T_corrected+5;
%     stimFrames_corrected=acqStart_F_corrected+150;
%     
%     results.(fns{f}).acqStart_T_corrected=acqStart_T_corrected;
%     results.(fns{f}).acqStart_F_corrected=acqStart_F_corrected;
%     results.(fns{f}).stimTimes_corrected=stimTimes_corrected;
%     results.(fns{f}).stimFrames_corrected=stimFrames_corrected;
    
    s(1)=subplot(6,1,1)
%         nose_filt=slidingAvg_rawF( results.(fns{f}).nose.pos,ptsToAvg,'mean' );
    nose_filt=results.(fns{f}).nose.pos;
    meanNose=nanmean(nose_filt);
    stdNose=nanstd(nose_filt);
    noseZ=(nose_filt-meanNose)/stdNose;
    noseV=gradient(nose_filt);
    noseAcc=abs(gradient(noseV));
%     noseV=[0;noseV];
    plot(time,noseZ,'k.')
    vline(stimTimes)
%         vline(stimTimes,'g')
    ylabel('nose position')
    title(fns{f})
    
    s(2)=subplot(6,1,2)
    plot(time,noseAcc,'k.')
    vline(stimTimes)
%     vline(stimTimes_corrected,'g')
    ylabel('nose velocity')
    
    s(3)=subplot(6,1,3)
    plot(time,results.(fns{f}).nose.likelihood);
     vline(stimTimes)
%      vline(stimTimes_corrected,'g')
    ylabel('nose likelihood')
    
    s(4)=subplot(6,1,4)
%     lower_lip_filt=slidingAvg_rawF( results.(fns{f}).lower_lip.pos,ptsToAvg,'mean' );
    lower_lip_filt=results.(fns{f}).lower_lip.pos;
    meanlower_lip=nanmean(lower_lip_filt);
    stdlower_lip=nanstd(lower_lip_filt);
    lower_lipZ=(lower_lip_filt-meanlower_lip)/stdlower_lip;
    
    lower_lipV=gradient(lower_lip_filt);
    lower_lipAcc=abs(gradient(lower_lipV));
%     lower_lipV=[0;lower_lipV];
    plot(time,lower_lipZ,'k.')
     vline(stimTimes)
%      vline(stimTimes_corrected,'g')
    ylabel('lower_lip position')
    
    s(5)=subplot(6,1,5)
    plot(time,lower_lipAcc,'k.')
     vline(stimTimes)
%      vline(stimTimes_corrected,'g')
    ylabel('lower_lip velocity')
    
    s(6)=subplot(6,1,6)
    plot(time,results.(fns{f}).lower_lip.likelihood);
     vline(stimTimes)
%      vline(stimTimes_corrected,'g')
    ylabel('lower_lip likelihood')
    
    results.(fns{f}).nose.Z=noseZ;
    results.(fns{f}).lower_lip.Z=lower_lipZ;
    results.(fns{f}).nose.velocity=noseV;
    results.(fns{f}).lower_lip.velocity=lower_lipV;
    results.(fns{f}).nose.accel=noseAcc;
    results.(fns{f}).lower_lip.accel=lower_lipAcc;
    linkaxes(s,'x')
 end
  %% match stimulus times/parameters of video to 2p
 path2p='G:\s2p_fastdisk\SST130\deafened\reduced\suite2p\plane0\analysis_01-Jun-2020.mat';
 load(path2p,'ops','xoff_blocks','yoff_blocks','dF_byTrial');
 
 xy_shift=sqrt(xoff_blocks.^2 + yoff_blocks.^2);
 xy_mean=mean(xy_shift(:));
 xy_std=std(xy_shift(:));
 xy_shift=(xy_shift-xy_mean)/xy_std;
 % get names of movies, extract stimulus info
filelist=char2cell(ops.filelist,[],1); %turn into cell array
pressure_2p=cell(length(filelist),1);
duty_2p=pressure_2p;
for p=1:length(pressure_2p)
    idx_MPa=strfind(filelist{p},'MPa');
    idx_DC=strfind(filelist{p},'DC');
    press=filelist{p}((idx_MPa-2):(idx_MPa-1));
    d=filelist{p}((idx_DC-2):(idx_DC-1));
    pressure_2p{p}=press;
    duty_2p{p}=d;
end
pressure_2p=categorical(pressure_2p);
pressure_2p(pressure_2p=='_0')='0';
duty_2p=categorical(duty_2p);
duty_2p(duty_2p=='_5')='5';

%SST130 post-deafening: last 16 trials of 30%DC were actually 40%; relabel
% idx30=find(duty_2p=='30');
% idx40=idx30(17:end);
% duty_2p(idx40)='40';


% 2p parameters
frameRate_2p=30;


% loop through videos
fns=fieldnames(results);
% fns=newNames;
pressure_vid=cell(length(fns),1);
duty_vid=pressure_vid;
for v=1:length(fns)
    fn=newNames{v};
        ixP=strfind(fn,'MPa');
        press=fn((ixP-2):(ixP-1));
        pressure_vid{v}=press;
        
        ixDC=strfind(fn,'DC')
        if isempty(ixDC)
            duty_vid{v}='0';
        else
            DC=fn((ixDC-2):(ixDC-1));
            
            duty_vid{v}=DC;
        end
end    

duty_vid=categorical(duty_vid);
duty_vid(duty_vid=='_5')='5';
pressure_vid=categorical(pressure_vid);
pressure_vid(pressure_vid=='_0')='0';

frameNum_2p=size(xy_shift,1);
repTime_2p=frameNum_2p/frameRate_2p;
framesRep_vid=repTime_2p*frameRate;
match_vid_2p=struct;
for v=1:length(fns)
            fn=fns{v};
            newfn=newNames{v};
        % get dF_byTrial, x/yoff idx to match to movie
        if pressure_vid(v)=='0'
            idx_match=pressure_2p==pressure_vid(v)
        else
            idx_match=pressure_2p==pressure_vid(v) & duty_2p==duty_vid(v);
        end
        % chunk video frames based on length of 2p movies
        acqFrames=results.(fn).acqStart_F;
        acqFrames=acqFrames(acqsUse_vid.(newfn));
        tmp=arrayfun(@(x)results.(fn).nose.pos(x:(x+framesRep_vid)),acqFrames,'un',0);
        match_vid_2p.(newfn).nose_pos=cat(2,tmp{:});
        
        tmp=arrayfun(@(x)results.(fn).nose.velocity(x:(x+framesRep_vid)),acqFrames,'un',0);
        match_vid_2p.(newfn).nose_V=cat(2,tmp{:});
        
        tmp=arrayfun(@(x)results.(fn).nose.Z(x:(x+framesRep_vid)),acqFrames,'un',0);
        match_vid_2p.(newfn).nose_posZ=cat(2,tmp{:});
        
        tmp=arrayfun(@(x)results.(fn).nose.accel(x:(x+framesRep_vid)),acqFrames,'un',0);
        match_vid_2p.(newfn).nose_accel=cat(2,tmp{:});
        
        % get xoff,yoff blocks to match
        trials_match=find(idx_match);
%         trials_match=trials_match(1:length(acqFrames));
        trials_use=acqsUse_2p.(newfn);
        trials_match=trials_match(trials_use);
        xoff_match=xoff_blocks(:,trials_match);
        yoff_match=yoff_blocks(:,trials_match);
        xy_shift_match=xy_shift(:,trials_match);
        match_vid_2p.(newfn).xoff=xoff_match;
        match_vid_2p.(newfn).yoff=yoff_match;
        match_vid_2p.(newfn).xy_shift=xy_shift_match;
        
        % get dF_byTrial to match
        cellNames=fieldnames(dF_byTrial);
        tmp=cellfun(@(x)dF_byTrial.(x)(:,trials_match),cellNames,'un',0);
        match_vid_2p.(newfn).dF=tmp;
        
        figure; hold on
        subplot(2,1,1)
        imagesc(match_vid_2p.(newfn).nose_accel');
        colormap gray
        subplot(2,1,2)
        imagesc(match_vid_2p.(newfn).xy_shift');
        colormap gray
end
 save(['G:\s2p_fastdisk\SST130\deafened\reduced\suite2p\plane0\matchVid.mat'],'match_vid_2p')

 %%
 fns=newNames;
 for i=1:length(fns)
     ixP=strfind(fns{i},'MPa');
     press=fns{i}(ixP-1);
     press=['0.',press];
     pressure(i)=str2num(press)
     
     ixDC=strfind(fns{i},'DC')
     if isempty(ixDC)
         DCs(i)=0;
     else
         DC=fns{i}((ixDC-2):(ixDC-1))
          DC(strfind(DC,'_'))='0';
         DCs(i)=str2num(DC);
     end
 end
 %%
 fns=fieldnames(results)
 stimEv_lower_lip_mean=zeros(1,length(fns));
 stimEv_nose_mean=zeros(1,length(fns));
 stim_lower_lip_v_all=cell(1,length(fns));
 stim_nose_v_all=stim_lower_lip_v_all;
 stim_nose_pos_all=stim_lower_lip_v_all;
 stim_lower_lip_pos_all=stim_lower_lip_v_all;
 for i=1:length(fns)
     lower_lipZ=results.(fns{i}).lower_lip.Z;
     noseZ=results.(fns{i}).nose.Z;
     lower_lipV=results.(fns{i}).lower_lip.velocity;
     noseV=results.(fns{i}).nose.velocity;
     
     stimFrames=results.(fns{i}).stimFrames;
     stimFrames=stimFrames(1:end-1);
     
     stim_lower_lipZ=abs(arrayfun(@(x)mean(lower_lipZ(x:(x+23))),stimFrames));
     stim_lower_lip_pos_all{i}=stim_lower_lipZ;
     stimEv_lower_lip_meanZ(i)=mean(stim_lower_lipZ);
     stimEv_lower_lip_semZ(i)=std(stim_lower_lipZ)/sqrt(length(stim_lower_lipZ));
     
     
     stim_noseZ=abs(arrayfun(@(x)mean(noseZ(x:(x+23))),stimFrames));
     stim_nose_pos_all{i}=stim_noseZ;
     stimEv_nose_meanZ(i)=mean(stim_noseZ);
     stimEv_nose_semZ(i)=std(stim_noseZ)/sqrt(length(stim_noseZ));
 
         stim_lower_lipV=abs(arrayfun(@(x)mean(lower_lipV(x:(x+23))),stimFrames));
         stim_lower_lip_v_all{i}=stim_lower_lipV;
     stimEv_lower_lip_meanV(i)=mean(stim_lower_lipV);
     stimEv_lower_lip_semV(i)=std(stim_lower_lipV)/sqrt(length(stim_lower_lipV));
     
     
     stim_noseV=abs(arrayfun(@(x)mean(noseV(x:(x+23))),stimFrames));
     stim_nose_v_all{i}=stim_noseV;
     stimEv_nose_meanV(i)=mean(stim_noseV);
     stimEv_nose_semV(i)=std(stim_noseV)/sqrt(length(stim_noseV));
 
 end
 
%  figure; hold on
%  errorbar(pressure,stimEv_nose_mean,stimEv_nose_sem,'ko','LineWidth',1.5)
%  
%  figure; hold on
%  errorbar(DCs,stimEv_nose_mean,stimEv_nose_sem,'ko','LineWidth',1.5)
 %%
 % plot pressure vs. movement
 ix_pressure=DCs==50 | DCs==0;
 pressure_plot=pressure(ix_pressure);
 nose_mean_p=stimEv_nose_meanZ(ix_pressure);
 nose_sem_p=stimEv_lower_lip_semZ(ix_pressure);
 figure; hold on
 errorbar(pressure_plot,nose_mean_p,nose_sem_p,'ro','LineWidth',1.5)
 xlabel('pressure (MPa)')
 ylabel('nose position')
  nose_plot=stim_nose_pos_all(ix_pressure);
 for i=1:length(pressure_plot)
    plot(pressure_plot(i),nose_plot{i},'ko','MarkerSize',4)
 end
 
 lower_lip_mean_p=stimEv_lower_lip_meanZ(ix_pressure);
 lower_lip_sem_p=stimEv_lower_lip_semZ(ix_pressure);
 figure; hold on
 errorbar(pressure_plot,lower_lip_mean_p,lower_lip_sem_p,'ro','LineWidth',1.5)
 xlabel('pressure (MPa)')
 ylabel('lower lip position')
  lip_plot=stim_lower_lip_pos_all(ix_pressure);
 for i=1:length(pressure_plot)
    plot(pressure_plot(i),lip_plot{i},'ko','MarkerSize',4)
 end
 
 % plot DC vs. movement
 ix_DC=pressure==0.8;
 DCs_plot=DCs(ix_DC);
 nose_mean_p=stimEv_nose_meanZ(ix_DC);
 nose_sem_p=stimEv_lower_lip_semZ(ix_DC);
 figure; hold on
  nose_plot=stim_nose_pos_all(ix_DC);
 for i=1:length(DCs_plot)
    plot(DCs_plot(i),nose_plot{i},'ko','MarkerSize',4)
 end
 errorbar(DCs_plot,nose_mean_p,nose_sem_p,'ro','LineWidth',1.5)
 xlabel('duty cycle (%)')
 ylabel('nose position')
 
 
 lower_lip_mean_p=stimEv_lower_lip_meanZ(ix_DC);
 lower_lip_sem_p=stimEv_lower_lip_semZ(ix_DC);
 figure; hold on
 lip_plot=stim_lower_lip_pos_all(ix_DC);
 for i=1:length(DCs_plot)
    plot(DCs_plot(i),lip_plot{i},'ro','MarkerSize',4)
 end
 errorbar(DCs_plot,lower_lip_mean_p,lower_lip_sem_p,'ko','LineWidth',1.5)
 xlabel('duty cycle (%)')
 ylabel('lower lip positions')

  %%
 % plot pressure vs. movement
 ix_pressure=DCs==50 | DCs==0;
 pressure_plot=pressure(ix_pressure);
 nose_mean_p=stimEv_nose_meanV(ix_pressure);
 nose_sem_p=stimEv_lower_lip_semV(ix_pressure);
 figure; hold on
 nose_plot=stim_nose_v_all(ix_pressure);
 for i=1:length(pressure_plot)
    plot(pressure_plot(i),nose_plot{i},'ko','MarkerSize',4)
 end
 errorbar(pressure_plot,nose_mean_p,nose_sem_p,'ro','LineWidth',1.5)
 xlabel('pressure (MPa)')
 ylabel('nose velocity')
 
 lower_lip_mean_p=stimEv_lower_lip_meanV(ix_pressure);
 lower_lip_sem_p=stimEv_lower_lip_semV(ix_pressure);
 figure; hold on
  lip_plot=stim_lower_lip_v_all(ix_pressure);
 for i=1:length(pressure_plot)
    plot(pressure_plot(i),lip_plot{i},'ko','MarkerSize',4)
 end
 errorbar(pressure_plot,lower_lip_mean_p,lower_lip_sem_p,'ro','LineWidth',1.5)
 xlabel('pressure (MPa)')
 ylabel('lower lip velocity')
 
 % plot DC vs. movement
 ix_DC=pressure==0.8;
 DCs_plot=DCs(ix_DC);
 nose_mean_p=stimEv_nose_meanV(ix_DC);
 nose_sem_p=stimEv_lower_lip_semV(ix_DC);
 figure; hold on
  nose_plot=stim_nose_v_all(ix_DC);
 for i=1:length(DCs_plot)
    plot(DCs_plot(i),nose_plot{i},'ko','MarkerSize',4)
 end
 errorbar(DCs_plot,nose_mean_p,nose_sem_p,'ro','LineWidth',1.5)
 xlabel('duty cycle (%)')
 ylabel('nose velocity')
 
 lower_lip_mean_p=stimEv_lower_lip_meanV(ix_DC);
 lower_lip_sem_p=stimEv_lower_lip_semV(ix_DC);
 figure; hold on
 lip_plot=stim_lower_lip_v_all(ix_DC);
 for i=1:length(DCs_plot)
    plot(DCs_plot(i),lip_plot{i},'ko','MarkerSize',4)
 end
 errorbar(DCs_plot,lower_lip_mean_p,lower_lip_sem_p,'ro','LineWidth',1.5)
 xlabel('duty cycle (%)')
 ylabel('lower lip velocitys')

 %  
%  %%
%  press=[0,0.1,0.2:0.2:0.8];
% for i=1:length(press)
%     if 
%     ix=pressure==press(i) & DCs==50;
%     
%     mean_mouth=stimEv_mouth_mean(ix)
%     
%     tmp=cat(2,frames_mouth{:})
%     stimEv_mouth_mean(i)=mean(tmp);
%      stimEv_mouth_sem(i)=std(tmp)/sqrt(length(tmp));
%      
%      frames_nose=stim_nose_all(ix)
%     
%     tmp=cat(2,frames_nose{:})
%     stimEv_nose_mean(i)=mean(tmp);
%      stimEv_nose_sem(i)=std(tmp)/sqrt(length(tmp));
% end
% % data=readtable('E:\mouse_vid\SST130_hearing\mp4\SST130_20200302_08MPa_50DCDLC_resnet50_SST130_hearing_2May1shuffle1_290000.csv');
% summary(data)
% head(data)
% frames=data{3:end,1};
% frames=cellfun(@(x)str2num(x),frames)
% nose_x=data{3:end,2};
% nose_x=cellfun(@(x)str2num(x),nose_x)
% nose_y=data{3:end,3};
% nose_y=cellfun(@(x)str2num(x),nose_y)
% nose=sqrt(nose_x.^2+nose_y.^2);
% nose_liklihood=data{3:end,4};
% nose_liklihood=cellfun(@(x)str2num(x),nose_liklihood);
% meanNose=mean(nose);
% stdNose=std(nose);
% Znose=(nose-meanNose)/stdNose;
% figure; hold on
% plot(frames,nose_x,'k.')
% plot(frames,nose_y,'r.')
% 
% 
% mouth_x=data{3:end,5};
% mouth_x=cellfun(@(x)str2num(x),mouth_x);
% mouth_y=data{3:end,6};
% mouth_y=cellfun(@(x)str2num(x),mouth_y);
% mouth=sqrt(mouth_x.^2+mouth_y.^2);
% meanmouth=mean(mouth);
% stdmouth=std(mouth);
% Zmouth=(mouth-meanmouth)/stdmouth;
% 
% figure; hold on
% subplot(2,1,1)
% plot(frames,Znose,'k.')
% plot(frames,Zmouth,'r.')
% 
% obj_x=data{3:end,14};
% obj_x=cellfun(@(x)str2num(x),obj_x);
% obj_y=data{3:end,15};
% obj_y=cellfun(@(x)str2num(x),obj_y);
% figure; hold on
% plot(frames,obj_x,'k.')
% plot(frames,obj_y,'r.')
% vline(stimframes)
% 
% acqStart(1)=187;
% acqStart(2)=807;
% frameRate=23.8;
% delay=5*frameRate;
% stim1=acqStart(1)+delay
% stimframes=stim1:620:frames(end)
% 
% figure; hold on
% subplot(2,1,1); hold on
% plot(frames,Znose,'k.')
% vline(stimframes)
% xlabel('frame')
% ylabel('Z scored position')
% subplot(2,1,2)
% plot(frames,nose_liklihood)
% xlabel('frames')
% ylabel('liklihood')
