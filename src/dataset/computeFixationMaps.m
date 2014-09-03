function computeFixationMaps(params)

data = load(fullfile(params.path.eye, 'fixations.mat'));
fixations = data.fixations;

outputPath = params.path.maps.fixation;
if ~exist(outputPath, 'dir')
    mkdir(outputPath);
end 

tic;
parfor i = 1 : params.nStimuli
    filename = params.stimuli{i};
    shortname = filename(1 : end - length(params.ext));
    img = im2double(imread(fullfile(params.path.stimuli, filename)));
    [h w ~] = size(img);
    map = zeros([h w]);

    fix_x = [];
    fix_y = [];
    for j = 1:length(fixations{i}.subjects)
        sub = fixations{i}.subjects{j};
        fix_x = [fix_x max(1, min(round(sub.fix_x), w))];
        fix_y = [fix_y max(1, min(round(sub.fix_y), h))];
    end
    
    fix_x = floor(fix_x);
    fix_y = floor(fix_y);
    for k = 1 : length(fix_x)
        map(fix_y(k), fix_x(k)) = 1;
    end
    saveFixations(fullfile(outputPath, [shortname '.mat']), map, fix_x, fix_y);
    map = imfilter(map, params.eye.gaussian, 0);
    map = normalise(map);
    imwrite(map, fullfile(outputPath, filename));
end
toc;
end

function saveFixations(filename, fixationPts, fix_x, fix_y)
    save(filename, 'fixationPts', 'fix_x', 'fix_y');
end

