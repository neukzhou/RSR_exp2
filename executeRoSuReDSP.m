function [err, data] = executeRoSuReDSP(opt)
addpath('./utilities/');
addpath('./utilities/detect_num_subspaces');

%% Data generating
data = generate_data(opt);

corruptionLevel = opt.corruptionLevel;
corruptionInterval = opt.corruptionInterval;
err = [];
maxIter = ceil(corruptionLevel/corruptionInterval);
for i = 1:maxIter
    disp(['sparsity = ', num2str(i*corruptionInterval),]);
    [erri] = test_RoSuReDSP(data, i, opt.factor);
    err = [err;erri];
end