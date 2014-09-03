function sampleBgPatches( params )

scales = [3 4 5 6];
th = 0.01;
mkdir(fullfile(params.path.data, 'smc', 'patches_bg'));

%patch size
d = 7;
hd=ceil(d/2);
splits = load(fullfile(params.path.data, 'split.mat'));
k=0;
trainingImgs = splits.split(1).files.train;

for i=1:length(trainingImgs)
    fileName = trainingImgs{i};
    map = im2double(imread(fullfile(params.path.maps.fixation, fileName)));
    
    for s=1:length(scales)
        img = im2double(imread(fullfile(params.path.data, 'smc', num2str(scales(s)-3), 'img', fileName)));
        load(fullfile(params.path.data, 'smc', num2str(scales(s)), 'hog', [fileName(1:end-3), 'mat']), 'hogFeat');
        load(fullfile(params.path.data, 'smc', num2str(scales(s)), 'itti', [fileName(1:end-3), 'mat']), 'ittiFeat');
        [h, w, c] = size(hogFeat);
        if (h<d || w<d)
            continue;
        end

        [hIm wIm tmp] = size(img);
        img = imresize(img, [h w]*8);
        tmp = imresize(map, [h w]);
        BW = imregionalmax(tmp.*(tmp<th));
        BW = bwmorph(BW, 'shrink', inf);

        idx = find(BW);
        idx = idx(randperm(length(idx)));        
        
        for j=1:min(2,length(idx))
            idx_max=idx(j);

            % salient pixel position in map
            col = ceil(idx_max / h);
            row = idx_max - (col - 1) * h;
                        
            % salient pixel position in hog      
            sc = col;
            sr = row;

            sr = sr - hd;
            sc = sc - hd;

            sr = max(min(sr, h-d), 0);
            sc = max(min(sc, w-d), 0);

            gtSal = tmp(sr+hd, sc+hd);
            if (gtSal > 0.2)
                continue;
            end
            
            patchImg = img(sr*8+1:sr*8+d*8, sc*8+1:sc*8+d*8, :);
            patchHog = hogFeat(sr+1:sr+d, sc+1:sc+d, :);
            patchItti = ittiFeat(sr+1:sr+d, sc+1:sc+d, :);

            %output
            k=k+1;
            imwrite(patchImg, fullfile(params.path.data, 'smc', 'patches_bg', sprintf('%5d.jpg', k)));
            save(fullfile(params.path.data, 'smc', 'patches_bg', sprintf('%5d.mat', k)), 'patchHog', 'patchItti', 'gtSal','s');
        end
    end
end