addpath('./utilities/');
addpath('./utilities/detect_num_subspaces');
addpath('./mat/data/');

load('output_90*135_by2*3');


X = data(:,1:1000);

%% Parameter setting
QUIET = 1; % if false, results of the recovery will be exhibited, and vice versa.
opt.tol =1e-4; % threshold of convergency
opt.maxIter =2e3; % max number of the algorithm's iteration
opt.rho =1.1; % parameter that control the rise of mu
opt.mu_max = 3e6; % max value of mu
opt.factor = 0.27; % the multiplier relevant with lambda

%% Main loop
lam1 =1 / ( max ( size(X) ) )^0.5;
lam2 = opt.factor * computeLambda_mat(X, X);
lambda = min(lam1,lam2);

[W,E,L,~] = RoSuReDSP(X, lambda, opt);

if ~QUIET
    figure;
    colormap(gray);
    mat  = @(x) reshape( x, 90, 135 );
    figure(1); clf;
    colormap( 'Gray' );
    for k = 1:200
        imagesc( [mat(X(:,k)), mat(L(:,k)), mat(E(:,k))] );
        axis off
        axis image
        drawnow;
        pause(.1);  
    end
end
