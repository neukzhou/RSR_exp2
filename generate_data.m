function [data] = generate_data(opt)
% n = 50; % number of data points in each subspace
% d = 10; % dim of subspace
% D = 100; % dim of observation
% nS =10; % number of subspaces
% nRound = 10; % repeat times of random trials
% max_noise =0.3;
n =opt.n;
d_arr =opt.d_arr;
D = opt.D;
nS =opt.nS;
nRound =opt.nRound;
corruptionLevel =opt.corruptionLevel;
max_noise =opt.max_noise;
noise_type =opt.type;
corruptionInterval = opt.corruptionInterval;

[U,~,~] = svd(rand(D));
cids = [];
U_cell =cell(1,nS);
X_cell =cell(1,nS);
R = orth(rand(D));
X =[];

for ii=1:nS
    d =max(d_arr);
    if (ii==1)
        U_cell{ii} =U(:,1:d);
    else
        U_cell{ii} =R*U_cell{1,ii-1};
    end
    %% Generate subspace with different dimenion d_ii which is specified by d
    d_ii =d_arr(ii);
    tmp =U_cell{ii};
    X_cell{ii} =tmp(:, 1:d_ii)*rand(d_ii,n);
    
    cids = [cids,ii*ones(1,n)];
    X =[X,X_cell{ii}];
end

data.X = X;
data.cids = cids;
data.Xs = cell(corruptionLevel,nRound);% in 5% interval of proportion
%data.Omega = cell(corruptionLevel,nRound);% in 5% interval of proportion
%data.X0fill = cell(21,nRound);% in 5% interval of proportion
nX = size(X,2);
norm_x = sqrt(sum(X.^2,1));
norm_x = repmat(norm_x,D,1);

maxIter = ceil(corruptionLevel/corruptionInterval);
for i=1:maxIter
    %gn = norm_x.*randn(D,nX);
    gn = randn(D,nX);
    for j=1:nRound        
        data.Xs{i,j} = X;% The origianl data
        %data.Xs{i,j}(:,inds) = X(:,inds) + 0.3*gn(:,inds); % adding 0.3 gn noise to X(:,inds).
        % THIS IS GROSS CORRUPTION: outliers  --> L_(2,1) norm
        % data.Xs{i,j}(:,inds) = X(:,inds) + max_noise*gn(:,inds); % adding 0.3 gn noise to X(:,inds).      
        
        %% Add sparse noise
        switch noise_type
            
            case 'Gaussian_noise' % max_noise: ~0.05 (<0.1)
                inds =rand(D,nX)<=i*corruptionInterval/100;
                data.Xs{i,j}(inds) = X(inds) + max_noise * gn(inds) .* norm_x(inds);
                
            case 'sparse_noise' % max_noise: 0.1~1
                inds =rand(D,nX)<=i*corruptionInterval/100;
                data.Xs{i,j}(inds) = X(inds) + max_noise * gn(inds) .* norm_x(inds);
                
            case 'gross_corruption'
                inds = rand(1,nX)<=i*corruptionInterval/100;% when i goes from 1 t0 21, the inds changes from 0% to 100%. That is the percentage of corrupted proportion.
                data.Xs{i,j}(:,inds) = X(:,inds) + max_noise * gn(:,inds) .* norm_x(inds); % adding 0.3 gn noise to X(:,inds).
                
            case 'outliers' % How to define outliers?
                inds = rand(1,nX)<=i*corruptionInterval/100;% when i goes from 1 t0 21, the inds changes from 0% to 100%. That is the percentage of corrupted proportion.
                data.Xs{i,j}(:,inds) = X(:,inds) + max_noise * gn(:,inds) .* norm_x(inds); % adding 0.3 gn noise to X(:,inds).
                
        end
    end
end