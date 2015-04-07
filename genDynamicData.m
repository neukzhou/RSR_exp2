% function [data] = genDynamicData(video, rows, cols, stepY, stepX)

video = './data/output.avi';
rows = 90; %374
cols = 135; %561
stepY = 2;
stepX = 3;
factor = 0.25;

% video with format .avi must be uncompressed.
vObj = VideoReader(video);

nFrames = vObj.NumberOfFrames;
height = vObj.Height * factor;
width = vObj.Width * factor;

rows = min(rows, height);
cols = min(cols, width);

data = zeros(rows*cols, nFrames);

idxX = width - cols + 1;
idxY = height - rows + 1;
flag = -1;
for i = 1:nFrames
    % generate the assigned patches of frames
    disp(['Frame #', num2str(i)]);
    rgbFrame = read(vObj, i);
    grayFrame = im2double(rgb2gray(rgbFrame));
    resizedFrame = imresize(grayFrame,factor);
    patch = resizedFrame(idxY:idxY+rows-1, idxX:idxX+cols-1);
    
    data(:,i) = patch(:);
    tmpX = idxX + flag * stepX;
    tmpY = idxY + flag * stepY;
    if tmpX < 1 || tmpY < 1 || tmpX + cols >= width || tmpY + rows >= height
        flag = -1 * flag;
    else
        idxX = tmpX;
        idxY = tmpY;
    end
end

[~,nameFile] = fileparts(video);
str = ['save ./mat/data/' nameFile, '_' num2str(rows) '*' num2str(cols), '_by' num2str(stepY) '*' num2str(stepX), '.mat data -v7.3'];
eval(str);

mat  = @(x) reshape( x, rows, cols );
figure(1); clf;
colormap( 'Gray' );
for k = 1:nFrames
    imagesc( [mat(data(:,k))] );
    axis off
    axis image
    drawnow;
    pause(.05);  
end

