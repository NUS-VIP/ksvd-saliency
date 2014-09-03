function splitData(params)
split = [];

ind = randperm(params.nStimuli);
nSample = floor(params.nStimuli / params.ml.nSplit);
for iSplit = 1:params.ml.nSplit
    if (iSplit < params.ml.nSplit)
        split(iSplit).ind.train = [ind(1:(iSplit-1)*nSample) ind(iSplit*nSample+1:end)];
        split(iSplit).ind.test = ind(((iSplit-1)*nSample+1):(iSplit*nSample));
    else
        split(iSplit).ind.train = [ind(1:(iSplit-1)*nSample)];
        split(iSplit).ind.test = ind(((iSplit-1)*nSample+1):end);
    end
    split(iSplit).files.train = params.stimuli(split(iSplit).ind.train);
    split(iSplit).files.test = params.stimuli(split(iSplit).ind.test);
end

outdir = params.path.data;
if ~exist(outdir, 'dir')
    mkdir(outdir);
end
save(fullfile(params.path.data, 'split.mat'), 'split');