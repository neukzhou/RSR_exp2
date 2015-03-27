
dim = 15; % the max dimension of each subspace

%% Parameter setting
opt.n = 40; % number of data points in each subspace
opt.nS = 5; % number of subspaces
subDim = ones(1,5); % the dimensions of each subspace
opt.D = 200; % dimension of observation
opt.nRound = 40; % repeat times of random trials
opt.max_noise = 1; % magnitude of noise
opt.corruptionLevel = 15; % the max percentage of corrupted pixels is 15%
opt.corruptionInterval = 0.5; % corruption at intervals of 0.5%
opt.factor = 0.18; % the multiplier relevant with lambda
opt.type ='sparse_noise'; % e.g. 'sparse_noise', 'gross_corruption', 'outliers'.

i = 0;
while (isempty(find(subDim==(dim+1))))
    i = i + 1;
    data = {};
    err = {};
    for j = 1:5
        disp(['dim = ' num2str(i+(j-1)/5),]);
        
        opt.d_arr = subDim;
        [errDim,dataDim] = executeRoSuReDSP(opt);
        data{j} = dataDim;
        err{j} = errDim;
        disp(['mean err = ',num2str(mean(errDim')),]);
        subDim(find(subDim == i, 1)) = i + 1;
    end
    if ~isdir('./mat'), mkdir('mat'); end
    if ~isdir('./mat/data'), mkdir('./mat', 'data'); end
    if ~isdir('./mat/err'), mkdir('./mat', 'err'); end
    str = ['save ./mat/data/data_dim' num2str(i) , '.mat data'];
    eval(str);
    str = ['save ./mat/err/err_dim' num2str(i) , '.mat err'];
    eval(str);
end