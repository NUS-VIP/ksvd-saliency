setup;

% configuration for MIT dataset
p = config('mit');

% generate eye fixation maps
computeFixationMaps(p);

% extract features
scaleImages(p);
extractIttiFeats(p);
extractHogFeats(p);

% create training and test sets
splitData(p);

% sampling
sampleFgPatches(p);
sampleBgPatches(p);

% training
learnDiscriminativeDict(p, 5, 20, 0.5);

% test
computeSaliencyMaps(p);

cleanup;