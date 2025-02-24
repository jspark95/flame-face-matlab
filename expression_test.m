load('FLAME_G.mat', 'C');

for i = 301:400
    betas = zeros(400,1);
    betas(1:300) = shape';
    betas(i) = 1;
    v = squeeze(sum(permute(C.shapeDirs, [3 1 2]) .* betas)) + C.meanVerts;
%     h = figure('visible','off');
%     dispFace(v, C.F, [.8 .8 .8])
%     saveas(h, sprintf('result/%03d_3.png', i-300));
    fName = sprintf('%05d.obj', i-300);
    vertface2obj(v, C.F, fName);
%     close(h);
end

for i = 1:20
    betas = zeros(400,1);
    betas(1:300) = shape';
    betas(301:400) = exp{i};
    v = squeeze(sum(permute(C.shapeDirs, [3 1 2]) .* betas)) + C.meanVerts;
%     h = figure('visible','off');
%     dispFace(v, C.F, [.8 .8 .8])
%     saveas(h, sprintf('result/%03d_3.png', i-300));
    fName = sprintf('%05d.obj', i);
    vertface2obj(v, C.F, fName);
%     close(h);
end
