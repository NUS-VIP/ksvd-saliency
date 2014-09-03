function extractHogFeats( params )

scales = [3 4 5 6];
for s=1:length(scales)
    mkdir(fullfile(params.path.data, 'smc', num2str(scales(s)), 'hog'));
end

parfor i=1:params.nStimuli
    fileName = params.stimuli{i};
    for s=1:length(scales)
        img = im2double(imread(fullfile(params.path.data, 'smc', num2str(scales(s)-3), 'img', fileName)));
        img = padarray(img, [8 8], 'replicate');
        hogFeat = features(img, 8, 1);
        saveFeats(fullfile(params.path.data, 'smc', num2str(scales(s)), 'hog', [fileName(1:end-3), 'mat']), hogFeat);
    end
end

end

function saveFeats(filename, hogFeat)
    save(filename, 'hogFeat');
end