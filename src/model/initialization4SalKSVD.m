function [Dinit,Tinit,Winit,Q]=initialization4SalKSVD(training_feats,H_train,S_train,dictsize,iterations,sparsitythres,lambda)

H_train = H_train>0.2;
scales = unique(S_train);
numScale = length(scales); % number of objects
classes = unique(H_train);
numClass = length(classes);
numPerBlock = round(dictsize/numScale/numClass); % initial points from each classes
Dinit = []; % for LC-Ksvd1 and LC-Ksvd2
dictLabel = [];
for class=1:numClass
    for scale=1:numScale
        col_ids = find(S_train==scales(scale) & H_train==classes(class));
        data_ids = 1:length(col_ids);
        %data_ids = find(colnorms_squared_new(training_feats(:,col_ids)) > 1e-6);   % ensure no zero data elements are chosen
        %    perm = randperm(length(data_ids));
        perm = [1:length(data_ids)]; 
        %%%  Initilization for LC-KSVD (perform KSVD in each class)
        Dpart = training_feats(:,col_ids(data_ids(perm(1:numPerBlock))));
        para.data = training_feats(:,col_ids(data_ids));
        para.Tdata = sparsitythres;
        para.iternum = iterations;
        para.memusage = 'high';
        % normalization
        para.initdict = normcols(Dpart);
        % ksvd process
        [Dpart,Xpart,Errpart] = ksvd(para,'');
        Dinit = [Dinit Dpart];

        labelvector = zeros(numScale,1);
        labelvector(scales(scale)) = 1;
        dictLabel = [dictLabel repmat(labelvector,1,numPerBlock)];
    end
end

% Q (label-constraints code); T: scale factor
T = eye(dictsize,dictsize); % scale factor
Q = zeros(dictsize,size(training_feats,2)); % energy matrix
Q2 = zeros(dictsize,size(training_feats,2));

k=0;
for class=1:numClass
    for scale=1:numScale
        col_ids = find(S_train==scales(scale) & H_train==classes(class));
        row_ids = (k * numPerBlock + 1):(k*numPerBlock+numPerBlock);
        k=k+1;
        Q(row_ids, col_ids)=1;
        
        Q2(row_ids, H_train==classes(class))=1;
    end
end
Q = Q*(1-lambda)+Q2*lambda;


params.data = training_feats;
params.Tdata = sparsitythres; % spasity term
params.iternum = iterations;
params.memusage = 'high';

% normalization
params.initdict = normcols(Dinit);

% ksvd process
[Dtemp,Xtemp,Errtemp] = ksvd(params,'');

% learning linear classifier parameters
Winit = inv(Xtemp*Xtemp'+eye(size(Xtemp*Xtemp')))*Xtemp*H_train';
Winit = Winit';

Tinit = inv(Xtemp*Xtemp'+eye(size(Xtemp*Xtemp')))*Xtemp*Q';
Tinit = Tinit';
