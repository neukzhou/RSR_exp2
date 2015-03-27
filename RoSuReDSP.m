%%============================================================================
% RoSuReDSP.m
% Description: This script is to solve the problem presented in the paper
%       of Robust Subspace Recovery via Dual Sparsity Pursuit.
% Target Function:
%                       min ||W||_1 + lambda*||E||_1
%                       s.t X = L+E, L = LW, diag(W)=0
%
% Input:
%                       X: d-by-n data matrix, d is the data dimension,
%                           n is the number
%                       lambda: Lagrange multiplier
%                       opt: parameter setting
% Output:
%                       W,E,L: as show in the equation
%                       stat: state record of the iteration
%%============================================================================
% Author: Zhou Hao
% Date: 2015-3-27
% Paper: Robust Subspace Recovery via Dual Sparsity Pursuit, by Xiao Bin et
% al.
%%============================================================================
%%
function [W,E,L,stat] = RoSuReDSP(X, lambda, opt)

if nargin < 2
    lambda = 1/(max(size(X)))^0.5;
end
if nargin <3
    opt.tol =1e-3;
    opt.maxIter =1e6;
    opt.rho =1.1;
    opt.mu_max =1e6;
end

%% Parameter setting
tol = opt.tol; % threshold of convergency
maxIter = opt.maxIter; % max number of the algorithm's iteration
mu_max =opt.mu_max; % max value of mu
rho =opt.rho; % parameter that control the rise of mu
[m, n] = size(X); % dimension of data
epsilon = 1e-5; % an infinitesimal
QUIET = 0; % if false, the process will be exhibited, and vice versa.
%% Initialization

W = zeros(n,n);
E = zeros(m,n);
Y = zeros(m,n);
% L = zeros(m,n);

X_norm_two =normest(X, 0.1);
X_norm_inf = norm( X(:), inf);
mu =1.25/X_norm_two;

What = eye(size(W)) - W;


%% Main process
for k = 1:maxIter
    
    L = X - E;
    eta1 = normest(L,0.1)^2;
    
    %% W update
    W = softthresholding(W+1/eta1*L'*(L*What - 1/mu*Y), 1/(mu*eta1));
    W = W-diag(diag(W));

    %% E update
    What = eye(size(W)) - W;
    
    % Calculation for eta2
    eta2 = normest(What,0.1)^2;
    
    E = softthresholding(E+1/eta2*(L*What-lambda/mu*Y)*What', lambda/(mu*eta2));

    
    %% Stopping Criteria
    leq = X - L*W - E;
    RelChg = norm(leq, 'fro') / (norm(X, 'fro')+epsilon);
    if k==1 || mod(k,100)==0 || RelChg<tol
        rankLW =rank(L*W,1e-3*norm(L*W,2));
        if ~QUIET
            disp(['iter ' num2str(k) ': mu=' num2str(mu,'%2.1e'), ...
                    ', eta1=',num2str(eta1, '%2.1e'), ...
                    ', eta2=' num2str(eta2, '%2.1e'), ...
                    ', rank=' num2str(rankLW), ...
                    ', err=' num2str(RelChg,'%2.3e')]);
        
        end
        stat.iter =k;
        stat.rank =rankLW;
        stat.err =RelChg;
    end
    
    if (RelChg < tol) || (mu > mu_max), break; end
    
    %% Y & mu update
    Y = Y + mu * (L * W - L);
    mu = min(mu*rho,mu_max);
    

end