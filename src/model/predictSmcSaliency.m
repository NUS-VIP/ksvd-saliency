function [ prediction ] = predictSmcSaliency( D, W, data, sparsity )
% sparse coding
G = D'*D;
Gamma = omp(D'*data,G,sparsity);

% classify process
prediction = zeros(1, size(data,2));
for featureid=1:size(data,2)
    spcode = Gamma(:,featureid);
    score_est =  W * spcode;
    prediction(featureid) = score_est;
end
