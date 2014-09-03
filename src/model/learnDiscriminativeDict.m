function learnDiscriminativeDict( params, sqrt_alpha, sqrt_beta, lambda )

fgPath = fullfile(params.path.data, 'smc', 'patches_fg');
bgPath = fullfile(params.path.data, 'smc', 'patches_bg');
    
X = [];
H = [];
S = [];
filesFg = dir(fullfile(fgPath, '*.mat'));
filesBg = dir(fullfile(bgPath, '*.mat'));
N1=length(filesFg);
N2=length(filesBg);
X=zeros(7*7*31+14, N1+N2);
H=zeros(1,N1+N2);
S=zeros(1,N1+N2);
for k=1:N1
    load(fullfile(fgPath, filesFg(k).name));
    x1 = patchHog(:,:,1:31);
    x2 = mean(mean(patchItti));
    X(:,k) = [x1(:); x2(:)];
    H(k) = gtSal;
    S(k) = s;
end

for k=1:N2
    load(fullfile(bgPath, filesBg(k).name));
    x1 = patchHog(:,:,1:31);
    x2 = mean(mean(patchItti));
    X(:,N1+k) = [x1(:); x2(:)];
    H(N1+k) = gtSal;
    S(N1+k) = s;
end

X = X-repmat(mean(X,2), [1 size(X,2)]);
st = std(X,0,2);
st(st==0)=1;
X = X./repmat(st, [1 size(X,2)]);

%% constant
sparsitythres = 20; % sparsity prior
% sqrt_alpha = 5; % weights for label constraint term
% sqrt_beta = 20; % weights for classification err term
dictsize = 800; % dictionary size
iterations = 50; % iteration number
iterations4ini = 20; % iteration number for initialization

%% dictionary learning process
% get initial dictionary Dinit and Winit
fprintf('\nLC-KSVD initialization... ');
[Dinit,Tinit,Winit,Q_train] = initialization4SalKSVD(X,H,S,dictsize,iterations4ini,sparsitythres,lambda);
fprintf('done!');

% % run LC K-SVD Training (reconstruction err + class penalty)
% fprintf('\nDictionary learning by LC-KSVD1...');
% [D1,X1,T1,W1] = labelconsistentksvd1(training_feats,Dinit,Q_train,Tinit,H_train,iterations,sparsitythres,sqrt_alpha);
% save('.\trainingdata\dictionarydata1.mat','D1','X1','W1','T1');
% fprintf('done!');

% run LC k-svd training (reconstruction err + class penalty + classifier err)
fprintf('\nDictionary and classifier learning by LC-KSVD2...')
[D,X,T,W] = labelconsistentksvd2(X,Dinit,Q_train,Tinit,H,Winit,iterations,sparsitythres,sqrt_alpha,sqrt_beta);
fprintf('done!');

save(fullfile(params.path.data, 'smc', 'DS.mat'), 'D', 'W', 'X', 'T', ...
    'sparsitythres', 'sqrt_alpha', 'sqrt_beta', 'dictsize', 'iterations', 'iterations4ini');
