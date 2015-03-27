% USSCE.m
% Description: This code is for the Unified Sparse Subspace Clustering Ensemble. In SSCE, the "ensemble" enjoys two-fold meanings:
%                       (1) A Unified Optimization Framework for Sparse Representation and Spectral Clustering <sometimes it helps.>
%                       ? (2) More Reliable Clustering via Clustering Ensemble <when k is large, it works.>
%                       ? (3) More Efficient Solver via Linearized ADMM. <NO change.>
%
%                       
%   [missrate, C, Theta] = USSCE(X,s,r,affine,alpha,outlier,rho, iter_max, T)
%
%    Inputs:  X - data matrix, of d x n
%                 idx - data points groundtruth label;
%                 alpha - parameter to set the 'lambda' for the term ||D - DZ||_fro
%                 dim - Target dimension for dimension reduction by PCA. If 'dim' is 0, there is no projection
%                 affine - use the affine constraint if true
%                 outlier - use the term ||E||_1 for outliers if true
%                 T - repeatation number in clustering ensemble
%                 rho - the proportion of coefficients to keep for construct weight matrix, e.g. rho =0.7 is meaning to keep
%                 70% coefficients.
%
% 
% Copyright by Chun-Guang Li      
% Date: May. 19, 2014

function [acc_i, err_i, E, Z] = USSCE(X, idx0, lambda, opt)
if nargin < 3   
    lambda = 0.5 /computeLambda_mat(X, X);
end
if nargin < 4
    opt.tol =1e-3;
    opt.maxIter =1e6;
    opt.rho =1.1;
    opt.mu_max =1e6;
    opt.iter_max = 1;
    opt.tau =0;
    opt.nu =1;
end

% initialization
n = size(X, 2);
Theta =zeros(n);
Theta_old =Theta;
tau = opt.tau; %0.1;
nu = opt.nu; %1.2;
iter_max = opt.iter_max;

opt.Z =zeros(n);
iter =0;
while (iter < iter_max)
    
    iter = iter +1;
    %% Find Z
    [D, Z, E] = admm_struct_rsr_E1_approx(X, lambda, Theta, opt);
    err_i = norm(D - X, 'fro')/norm(X, 'fro');
    
    %% find Theta
    rho = 1; 
    nbcluster =max(idx0);
    CKSym = BuildAdjacency(thrC(Z,rho));
    grps = SpectralClustering(CKSym, nbcluster);
    if (max(idx0) <10)
        acc_i = 1 - Misclassification(grps,idx0);
    else
        acc_i = compacc(grps',idx0);
    end    
    Theta = form_structure_matrix(grps);
    disp(['Str. Robust SSC (approx.) err_i = ',num2str(err_i), '   acc_i = ', num2str(acc_i)]);
    
    %% Checking stop criterion
    tmp =Theta - Theta_old;
    if (max(abs(tmp(:))) < 0.5) 
        break; % if Q didn't change, stop the iterations.
    end
    Theta_old =Theta;
    opt.Z =Z;
    opt.tau = tau * nu;
    lambda = 0.5 /computeLambda_mat(D, D);
end

function M = form_structure_matrix(idx,n)
if nargin<2
    n =size(idx,2);
end
M =zeros(n);
id =unique(idx);
for i =1:length(id)
    idx_i =find(idx == id(i));
    M(idx_i,idx_i)=ones(size(idx_i,2));
end