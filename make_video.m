clear; clc;
frame_num = 16;
for i = 1:frame_num
    tmp = [int2str(i) '_0.png'];
    imageNames{i} = tmp;
end

outputVideo = VideoWriter(fullfile('test.avi'));
outputVideo.FrameRate = 8;
open(outputVideo);

for ii = 1:length(imageNames)
   img = imread(fullfile(imageNames{ii}));
   writeVideo(outputVideo,img)
end

close(outputVideo);
