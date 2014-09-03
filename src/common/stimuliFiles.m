function [ stimuli ] = stimuliFiles( params )
    files = dir([params.path.stimuli, '/*', params.ext]);
    stimuli = {files.name};
end

