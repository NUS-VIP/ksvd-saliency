function [ map ] = saliencyLCKSVD( params, fileName )

    DS = load(fullfile(params.path.data, 'smc', 'DS.mat'));
    D = DS.D;
    W = DS.W;
    sparsitythres = DS.sparsitythres;
    scales = [3 4 5 6];
    %patch size
    d = 7;
    hd = ceil(d/2);
    salMapSize = 32;
    
    img = im2double(imread(fullfile(params.path.stimuli, fileName)));
    [imgH imgW ~] = size(img);
    sal = zeros(imgH, imgW, length(scales));
    parfor s=1:length(scales)
        data = load(fullfile(params.path.data, 'smc', num2str(scales(s)), 'hog', [fileName(1:end-3), 'mat']), 'hogFeat');
        hogFeat = data.hogFeat;
        data = load(fullfile(params.path.data, 'smc', num2str(scales(s)), 'itti', [fileName(1:end-3), 'mat']), 'ittiFeat');
        ittiFeat = data.ittiFeat;
        [h w c] = size(hogFeat);
        padHog = padarray(hogFeat, [hd-1 hd-1 0]);
        padItti = padarray(ittiFeat, [hd-1 hd-1 0]);
        X=zeros(d*d*31+14, w*h);
        k=0;
        for q=0:w-1
            for p=0:h-1
                x1 = padHog(p+1:p+d,q+1:q+d,1:31);
                x2 = mean(mean(padItti(p+1:p+d,q+1:q+d,:)));
                k=k+1;
                X(:,k) = [x1(:); x2(:)];
            end
        end

        X = X - repmat(mean(X,2), [1 size(X,2)]);
        st = std(X,0,2);
        st(st==0) = 1;
        X = X./ repmat(st, [1 size(X,2)]);
        prediction = predictSmcSaliency(D, W, X, sparsitythres);
        salMap = reshape(prediction, [h w]);
        salMap = exp(salMap);
        salMap = imresize(salMap, [imgH imgW]/salMapSize);
        nn=4;
        salMap = ordfilt2(salMap, nn*nn, true(nn));
        salMap = salMap/sum(salMap(:));
        sal(:, :, s) = imresize(salMap, [imgH imgW]);
    end
    map = normalise(prod(sal, 3));
end

