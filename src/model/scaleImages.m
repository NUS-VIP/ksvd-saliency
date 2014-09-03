function [ output_args ] = scaleImages ( params )

scales = 0:4;
for s=1:length(scales)
    mkdir(fullfile(params.path.data, 'smc', num2str(scales(s)), 'img'));
    mkdir(fullfile(params.path.data, 'smc', num2str(scales(s)), 'fix'));
end

parfor i=1:length(params.stimuli)
    fileName = params.stimuli{i};
    map = im2double(imread(fullfile(params.path.maps.fixation, fileName)));
    img = im2double(imread(fullfile(params.path.stimuli, fileName)));
    
    if (size(img,3)==3)
        imgr=img(:,:,1);
        imgg=img(:,:,2);
        imgb=img(:,:,3);
        is_color =1;
    else
        imgi = img;
        is_color =0;
    end
    imgL = {};
    imgR = {};
    imgG = {};
    imgB = {};
    if (is_color)
        imgR{1} = mySubsample(imgr); imgG{1} = mySubsample(imgg); imgB{1} = mySubsample(imgb);
    else
        imgL{1} = mySubsample(imgi);
    end

    for j=2:max(scales)
        if ( is_color )
            imgR{j} = mySubsample( imgR{j-1} );
            imgG{j} = mySubsample( imgG{j-1} );
            imgB{j} = mySubsample( imgB{j-1} );
        else
            imgL{j} = mySubsample( imgL{j-1} );
        end
    end

    
    imwrite(img, fullfile(params.path.data, 'smc', num2str(0), 'img', fileName));
    for s=2:length(scales)
        if is_color
            s_img = cat(3, imgR{scales(s)}, imgG{scales(s)}, imgB{scales(s)});
        else
            s_img = imgL{scales(s)};
        end
        imwrite(s_img, fullfile(params.path.data, 'smc', num2str(scales(s)), 'img', fileName));
    end
end