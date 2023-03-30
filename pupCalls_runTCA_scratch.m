%% shape data into 3D array for TCA

% pupCalls_saveMultiDayDataStructs; %script to run to make and save out
% structs
pupCalls_gcamp8_paths;
fieldToLoad=3; %choose which imaging field to run
  % find name of directory to save to
    tmpidx=regexp(matchFilePath{fieldToLoad},'/');
    path2save=matchFilePath{fieldToLoad}(1:tmpidx(end));
  load([path2save,'dFbyTrial_all.mat'],'dFallTrials',"trialIdx",'dFByTrial_calls')

%% run TCA

for d=1:numel(dFallTrials)
    data_all{d}=permute(dFallTrials{d},[3,2,1]);
end


data=data_all{1}; % run on first day's data
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
for R=3:25%size(data,1)
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
    est_factors = cp_als(tensor(data),R,'printitn',0);
    
    % store error
    err(n) = norm(full(est_factors) - data)/norm(data);
    
 %   visualize fit for first several fits
    if n < 4
        % score aligns t                                                       he cp decompositions
%         [sc, est_factors] = score(est_factors, true_f                                                                                                                                                        actors);
        
        % plot the estimated factors
        viz_ktensor(est_factors, ... 
            'Plottype', {'bar', 'line', 'scatter'}, ...
            'Modetitles', {'neurons', 'time', 'trials'})
        set(gcf, 'Name', ['estimated factors - fit #' num2str(n)])
    end                 
end


figure(); hold on
plot(randn(n_fits,1), err, 'ob')
% plot(0, true_err, 'or', 'markerfacecolor','r');
xlim([-10,10])      
ylim([0 1.0])
set(gca,'xtick',[])
ylabel('model error')
% legend('fits','true model')