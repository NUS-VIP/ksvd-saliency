function computeSaliencyMaps( params )


mkdir(fullfile(params.path.maps.saliency, 'smc'));

load(fullfile(params.path.data, 'split.mat'));
testImgs = split(1).files.test;
for i=1:length(testImgs)
    fileName = testImgs{i};
    map = saliencyLCKSVD(params, fileName);
    imwrite(map, fullfile(params.path.maps.saliency, 'smc', fileName));
end
