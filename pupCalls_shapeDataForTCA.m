%% load MultiDayROI for one imaging field

pathToLoad='/Users/aml717/data/reduced/IC603/field1/';
load([pathToLoad,'MultiDayROIs.mat'],'allDates_calls_5sec',...
    'allDates_tones_3sec','MultiDayROIs_calls_5sec','MultiDayROIs_tones_3sec');
MultiDayROIs_calls=MultiDayROIs_calls_5sec;
dFbyTrial=cat(1,MultiDayROIs_calls(:).dFbyTrial); % concatenate across cells

idxEmpty=zeros(size(dFbyTrial));
idxCall=cell(size(dFbyTrial));
idxDay=idxCall;
for d=1:size(dFbyTrial,2)
    for r=1:size(dFbyTrial,1)
        if isempty(dFbyTrial{r,d})
            idxEmpty(r,d)=1;
        else

            thisCell=dFbyTrial{r,d};

            %make index of which call was played on each trial
            idxCalltmp=cell(numel(thisCell),1);
            for c=1:numel(thisCell)
                idxCalltmp{c}=repmat(c,size(thisCell{c},1),1);
            end
            idxCall{r,d}=cat(1,idxCalltmp{:});

            %make index of which day for each trial
            idxDay{r,d}=repmat(d,size(idxCall{r,d}));

            dFbyTrial{r,d}=cat(1,thisCell{:}); % concatenate across calls


        end
    end
end

%% concatenate across selected days

daysPlot=[1,4];

idxEmptyDays=idxEmpty(:,daysPlot);
idxInclude=sum(idxEmptyDays,2)==0;

dFbyTrial_tmp=dFbyTrial(idxInclude,daysPlot);
idxDayTmp=idxDay(idxInclude,daysPlot);
idxCallTmp=idxCall(idxInclude,daysPlot);

dFbyTrial_tmp=cellfun(@(x)permute(x,[3,2,1]),dFbyTrial_tmp,'un',0);
idxDayTmp=cellfun(@(x)permute(x,[3,2,1]),idxDayTmp,'un',0);
idxCallTmp=cellfun(@(x)permute(x,[3,2,1]),idxCallTmp,'un',0);

dFbyTrial_days=cell(1,1,length(daysPlot));
idxDay_days=cell(1,1,length(daysPlot));
idxCall_days=cell(1,1,length(daysPlot));
for d=1:length(daysPlot)
    dFbyTrial_days{d}=cat(1,dFbyTrial_tmp{:,d});
    idxDay_days{d}=cat(1,idxDayTmp{:,d});
    idxCall_days{d}=cat(1,idxCallTmp{:,d});
end

dFbyTrial_days=cat(3,dFbyTrial_days{:});
idxCall_days=cat(3,idxCall_days{:});
idxDay_days=cat(3,idxDay_days{:});
data=dFbyTrial_days;
%% normalize data vales to 0:1 based on each cells min and max
dataNorm=nan(size(data));
for n=1:size(data,1)
    thisCell=data(n,:,:);
    minVal=min(thisCell(:));
    maxVal=max(thisCell(:));
    range=maxVal-minVal;
    thisCellNorm=(thisCell+abs(minVal))/range;
    dataNorm(n,:,:)=thisCellNorm;
end

%%
for r=1:size(dataNorm,1)
    figure; imagesc(squeeze(dataNorm(r,:,:))')
    colormap gray
end
%% Fit CP Tensor Decomposition %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% these commands require that you download Sandia Labs' tensor toolbox:
% http://www.sandia.gov/~tgkolda/TensorToolbox/index-2.6.html

%% first try 3:n factors and plot error to choose number of factors

% convert data to a tensor object
data = tensor(dataNorm);

% plot the ground truth
% true_factors = ktensor(lam, A, B, C);
% true_err = norm(full(true_factors) - data)/norm(true_factors);
% viz_ktensor(true_factors, ...
%             'Plottype', {'bar', 'line', 'scatter'}, ...
%             'Modetitles', {'neurons', 'time', 'trials'})
% set(gcf, 'Name', 'true factors')

figure(); hold on
for R=3:20%size(data,1)
    % fit the cp decomposition from random initial guesses
    n_fits = 30;
    err = zeros(n_fits,1);
    for n = 1:n_fits
        % fit model
        est_factors = cp_als(tensor(data),R,'printitn',0);

        % store error
        err(n) = norm(full(est_factors) - data)/norm(data);

        % visualize fit for first several fits
        %     if n < 4
        %         % score aligns t                                                       he cp decompositions
        % %         [sc, est_factors] = score(est_factors, true_f                                                                                                                                                        actors);
        %
        %         % plot the estimated factors
        %         viz_ktensor(est_factors, ...
        %             'Plottype', {'bar', 'line', 'scatter'}, ...
        %             'Modetitles', {'neurons', 'time', 'trials'})
        %         set(gcf, 'Name', ['estimated factors - fit #' num2str(n)])
        %     end
    end


    plot(R, err, 'ob')
    % plot(0, true_err, 'or', 'markerfacecolor', 'r');
end
% xlim([-10,10])
ylim([0 1.0])
% set(gca,'xtick',[])
xlabel('number of factors')
ylabel('model error')
% legend('fits','true model')

%%

R= 14; % choose number of factors

% fit the cp decomposition from random initial guesses
n_fits = 30;
err = zeros(n_fits,1);
for n = 1:n_fits
    % fit model
    est_factors{n} = cp_als(tensor(data),R,'printitn',0);

    % store error
    err(n) = norm(full(est_factors{n}) - data)/norm(data);

    %   visualize fit for first several fits
    %     if n <10
    %         % score aligns t                                                       he cp decompositions
    % %         [sc, est_factors] = score(est_factors, true_f                                                                                                                                                        actors);
    %
    %         % plot the estimated factors
    %         viz_ktensor(est_factors, ...
    %             'Plottype', {'bar', 'line', 'scatter'}, ...
    %             'Modetitles', {'neurons', 'time', 'trials'})
    %         set(gcf, 'Name', ['estimated factors - fit #' num2str(n)])
    %     end
end

[~,idx_err]=sort(err,'ascend');
est_factors_sorted=est_factors(idx_err);
for n=1:10
    % score aligns t                                                       he cp decompositions
    %         [sc, est_factors] = score(est_factors, true_f                                                                                                                                                        actors);

    % plot the estimated factors
    viz_ktensor(est_factors_sorted{n}, ...
        'Plottype', {'bar', 'line', 'scatter'}, ...
        'Modetitles', {'neurons', 'time', 'trials'})
    set(gcf, 'Name', ['estimated factors - fit #' num2str(n)])
end

figure(); hold on
plot(randn(n_fits,1), err, 'ob')
% plot(0, true_err, 'or', 'markerfacecolor','r');
xlim([-10,10])
ylim([0 1.0])
set(gca,'xtick',[])
ylabel('model error')
% legend('fits','true model')