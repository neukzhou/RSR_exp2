% lambda_test.m

addpath('./utilities/');
addpath('./utilities/detect_num_subspaces');

%% Parameter Setting
n = 40; % number of data points in each subspace
nS = 5;%10; % number of subspaces
d_arr = 5; % The dimensions of each subspace
D = 200; % dim of observation
nRound = 40; % repeat times of random trials: 5, 10
max_noise = 1;
d_range = 1:15;%5:15;
corruptionLevel = 8; % from 1 to 21 :, at interval of 1%.

opt.n = n; % number of data points in each subspace
opt.nS =nS; % number of subspaces
opt.D = D; % dim of observation
opt.nRound = nRound; % repeat times of random trials: 5, 10
opt.max_noise =max_noise;
opt.corruptionLevel =corruptionLevel; % from 1 to 21 :, at interval of 1%.

opt.type ='sparse_noise'; % e.g. 'sparse_noise', 'gross_corruption', 'outliers'.

%RecErr=zeros(corruptionLevel, nRound);
%Acc=zeros(size(d_range, 2), corruptionLevel, nRound);
date_str =datestr(now,30);
%x = 0:1:(corruptionLevel-1);

%% Data generating
%d_arr = d_range(j_d) * ones(1,nS);%[5 5 5 5 5]; % The maximum dim of subspace
opt.d_arr = d_arr * ones(1,nS);%[5 5 5 5 5]; % The maximum dim of subspace

data = generate_data(opt);