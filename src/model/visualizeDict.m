function [ output_args ] = visualizeDict ( params )

load(fullfile(params.path.data, 'smc', 'DS.mat'));
d=7;
k=0;
blockSize = dictsize/2/4;
mmin=1000;
mmax=0;
for lbl=1:2
    for scale = 1:4
        w=8*(d+2)+1;
%         hogs = zeros(d*blockSize/10, d*10, 32); 
        im1 = zeros(w*blockSize/10, w*10);
        im2 = zeros(d*blockSize/10, d*10);
        for i=1:blockSize/10
            for j=1:10
                k=k+1;
                h1 = reshape(D(1:d*d*31,k),[d d 31]);
                h1 = padarray(h1, [0 0 1], 'post');
%                 hogs((i-1)*d+1:(i-1)*d+d, (j-1)*d+1:(j-1)*d+d,:) = h1;
                h2 = reshape(D(d*d*31+1:end,k), [1 1 14]);
        %         im((i-1)*81+1:(i-1)*81+80, (j-1)*81+1:(j-1)*81+80) = HOGpicture(h, 20);
                im1((i-1)*w+1:(i-1)*w+w, (j-1)*w+1:(j-1)*w+w) = invertHOG(h1);
                im2((i-1)*d+1:(i-1)*d+d, (j-1)*d+1:(j-1)*d+d) = sum(h2);
                mmin=min(mmin,sum(h2));
                mmax=max(mmax,sum(h2));
            end
        end
%         im1=invertHOG(hogs);
        imwrite(im1, fullfile(params.path.data, 'smc', sprintf('hogDt_c%d_s%d.jpg', lbl, scale)));
        II{lbl,scale} = im2;

    end
end

for lbl=1:2
    for scale = 1:4
%         for i=1:14
            im2=II{lbl,scale};
            imwrite((im2-mmin)./(mmax-mmin), fullfile(params.path.data, 'smc', sprintf('ittiDt_c%d_s%d.jpg', lbl, scale)));
%         end
    end
end

% imwrite(normalise(im2), fullfile(PATH_DATA, 'smc', 'ittiDt.jpg'));
imshow(im1);