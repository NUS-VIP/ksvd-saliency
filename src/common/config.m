function [ params ] = config( name )
    if nargin < 1
        params = defaultParams('default');
        file = fullfile('config', 'default.json');
        savejson('', params, file);
    else
        file = fullfile('config', [name '.json']);
        if ~exist(file, 'file')
            params = defaultParams(name);
            savejson('', params, file);
        else
            params = loadjson(file);
        end
    end
    
    params = postConfig(params);
end

function [params] = defaultParams( name )
    params.root = '/Sync/Data/Saliency';
    
    params.path.dataset = [params.root, '/dataset/' name];
    params.path.stimuli = [params.path.dataset, '/stimuli'];
    params.path.maps.fixation = [params.path.dataset, '/fixation_maps'];

    params.path.labels = [params.path.dataset, '/labels'];
    params.path.eye = [params.path.dataset, '/eye'];
    params.path.raw = [params.path.dataset, '/eye/raw'];
    
    params.path.data = [params.root, '/data/', name];
    params.path.maps.feature = [params.path.data, '/feature_maps'];
    params.path.maps.saliency = [params.path.data, '/saliency_maps'];
    params.path.maps.heat = [params.path.data, '/heat_maps'];
    
    params.path.fig = [params.path.data, '/figures'];
    
    params.file.fixations = [params.path.eye, '/fixations.mat'];
    
    params.eye.radius = 26;
    
    params.ext = '.jpg';
    
    params.ml.nSplit = 10;
    
    params.out.sigma = 7.2;
    params.out.width = 256;
    params.out.height = 192;
    
    params.model.hou.colorChannels = 'LAB';
    params.model.hou.blurSigma = 0; 
    params.model.hou.mapWidth = 240;
    params.model.hou.resizeToInput = 1;
    params.model.hou.subtractMin = 1; 
    
    params.model.aim.scale = 0.25;
    params.model.sun.scale = 0.25;
    
    params.model.myobj.ms.spatial = 8;
    params.model.myobj.ms.range = 6;
    params.model.myobj.ms.minArea = 100;
    
    params.model.myobj.ers.nSegment = 100;
   
end


function [params] = postConfig( params )
    winSize = ceil(params.eye.radius * 7);
    params.eye.gaussian = fspecial('gaussian', [winSize winSize], params.eye.radius);

    winSize = ceil(params.out.sigma * 7);
    params.out.gaussian = fspecial('gaussian', [winSize winSize], params.out.sigma);
    params.stimuli = stimuliFiles(params);
    params.nStimuli = length(params.stimuli);
end