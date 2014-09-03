function [ output_args ] = extractIttiFeats ( params )

scales = [3 4 5 6];
for s=1:length(scales)
    mkdir(fullfile(params.path.data, 'smc', num2str(scales(s)), 'itti'));
end

p = makeGBVSParams;
p.useIttiKochInsteadOfGBVS = 1;
p.channels = 'CIO';
p.verbose = 0;
p.unCenterBias = 0;

p.salmapmaxsize = round( 64 );
p.ittiCenterLevels = [ 3 4 5 6 ];   % the 'c' scales for 'center' maps
p.ittiDeltaLevels = [ 2 3 ];      % the 'delta' in s=c+delta levels for 'surround' scales

parfor i=1:length(params.stimuli)
    ittiFeats = cell(length(scales), 1);
    for s=1:length(scales)
        ittiFeats{i} = [];
    end
    fileName = params.stimuli{i};
    img = im2double(imread(fullfile(params.path.stimuli, fileName)));
    [H W C] = size(img);
    out = gbvs(img, p);
    maps = out.intermed_maps.normalizedActivationMaps;
    for j=1:length(maps)
        map = maps{j};
        scale_ctr = map.maptype(2);
        ittiFeats{scale_ctr-2} = cat(3, ittiFeats{scale_ctr-2}, imresize(map.map, [H / 2^(scale_ctr), W/ 2^(scale_ctr)]));
    end
    for s=1:length(scales)
        ittiFeat = ittiFeats{s};
        saveFeats(fullfile(params.path.data, 'smc', num2str(scales(s)), 'itti', [fileName(1:end-3), 'mat']), ittiFeat);
    end    
end
end

function saveFeats(filename, ittiFeat)
    save(filename, 'ittiFeat');
end