function computeIttiMaps(params)

features = {'color', 'intensity', 'orientation'};
n = length(features);
outputPath = cell(n, 1);
for k = 1 : n
    outputPath{k} = fullfile(params.path.maps.feature, features{k});
    if ~exist(outputPath{k}, 'dir')
        mkdir(outputPath{k});
    end 
end

tic;
for i = 1 : params.nStimuli
    fileName = params.stimuli{i};
    img = imread(fullfile(params.path.stimuli, fileName));
    out = ittikochmap(img);
    for k = 1 : n
        map = imresize(out.top_level_feat_maps{k}, [params.out.height params.out.width]);
        map = imfilter(map, params.out.gaussian);
        map = normalise(map);
        imwrite(map, fullfile(outputPath{k}, fileName));
    end
    fprintf('.');
end
toc;