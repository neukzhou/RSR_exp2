function [err] = test_RoSuReDSP(data, id, factor)

%% Data loaded
X_c = data.Xs(id,:);
X =data.X;
clear data;

%% Parameter setting
QUIET = 1; % if false, results of the recovery will be exhibited, and vice versa.
opt.tol =1e-4; % threshold of convergency
opt.maxIter =2e3; % max number of the algorithm's iteration
opt.rho =1.1; % parameter that control the rise of mu
opt.mu_max = 3e6; % max value of mu
opt.factor = factor; % the multiplier relevant with lambda
nRound =size(X_c,2); % repeat times of random trials

%% Main loop
err = zeros(1, nRound); 
for i=1:nRound
    Xi = X_c{i};
    
    lam1 =1 / ( max ( size(Xi) ) )^0.5;
    lam2 = factor / computeLambda_mat(Xi, Xi);
    lambda = min(lam1,lam2);
    
    disp(['#' num2str(i)]);
    [W,E,L,~] = RoSuReDSP(Xi, lambda, opt);
    if ~QUIET
        figure;
        colormap(gray);
        subplot(2,2,1); imagesc(L);
        subplot(2,2,2); imagesc(W);
        subplot(2,2,3); imagesc(L-X);
        subplot(2,2,4); imagesc(E);
    end
    err_i = norm(X - L, 'fro')/norm(X, 'fro');
    err(i) = err_i;
end