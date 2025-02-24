finalBeta = zeros(400,1);
finalTheta = zeros(5,3);

sourceBeta = zeros(400,1);
sourceTheta = zeros(5,3);

targetBeta = databt(20).beta;
targetTheta = databt(20).theta;

for i = 0:23
    finalBeta = ((24-i)*sourceBeta + i*targetBeta)/24;
    finalTheta = ((24-i)*sourceTheta + i*targetTheta)/24;
    v = FLAMEModel(C,finalBeta,finalTheta);
    vertface2obj(v,C.F,sprintf('%d.obj', i));
    h = figure('visible','off');
    dispFace(v, C.F, [.8 .8 .8]);
    saveas(h, sprintf('%d.png', i));
    close(h);
end

sourceBeta = targetBeta;
sourceTheta = targetTheta;

targetBeta = databt(24).beta;
targetTheta = databt(24).theta;

for i = 0:23
    finalBeta = ((24-i)*sourceBeta + i*targetBeta)/24;
    finalTheta = ((24-i)*sourceTheta + i*targetTheta)/24;
    v = FLAMEModel(C,finalBeta,finalTheta);
    vertface2obj(v,C.F,sprintf('%d.obj', 24+i));
    h = figure('visible','off');
    dispFace(v, C.F, [.8 .8 .8]);
    saveas(h, sprintf('%d.png', 24+i));
    close(h);
end

sourceBeta = targetBeta;
sourceTheta = targetTheta;

targetBeta = databt(19).beta;
targetTheta = databt(19).theta;

for i = 0:23
    finalBeta = ((24-i)*sourceBeta + i*targetBeta)/24;
    finalTheta = ((24-i)*sourceTheta + i*targetTheta)/24;
    v = FLAMEModel(C,finalBeta,finalTheta);
    vertface2obj(v,C.F,sprintf('%d.obj', 48+i));
    h = figure('visible','off');
    dispFace(v, C.F, [.8 .8 .8]);
    saveas(h, sprintf('%d.png', 48+i));
    close(h);
end

sourceBeta = targetBeta;
sourceTheta = targetTheta;

targetBeta = databt(19).beta+databt(1).beta;
targetTheta = databt(19).theta+databt(1).theta;

for i = 0:23
    finalBeta = ((24-i)*sourceBeta + i*targetBeta)/24;
    finalTheta = ((24-i)*sourceTheta + i*targetTheta)/24;
    v = FLAMEModel(C,finalBeta,finalTheta);
    vertface2obj(v,C.F,sprintf('%d.obj', 72+i));
    h = figure('visible','off');
    dispFace(v, C.F, [.8 .8 .8]);
    saveas(h, sprintf('%d.png', 72+i));
    close(h);
end

sourceBeta = targetBeta;
sourceTheta = targetTheta;

targetBeta = databt(15).beta+databt(14).beta;
targetTheta = databt(15).theta+databt(14).theta;

for i = 0:23
    finalBeta = ((24-i)*sourceBeta + i*targetBeta)/24;
    finalTheta = ((24-i)*sourceTheta + i*targetTheta)/24;
    v = FLAMEModel(C,finalBeta,finalTheta);
    vertface2obj(v,C.F,sprintf('%d.obj', 96+i));
    h = figure('visible','off');
    dispFace(v, C.F, [.8 .8 .8]);
    saveas(h, sprintf('%d.png', 96+i));
    close(h);
end

sourceBeta = targetBeta;
sourceTheta = targetTheta;

targetBeta = zeros(400,1);
targetTheta = zeros(5,3);

for i = 0:23
    finalBeta = ((24-i)*sourceBeta + i*targetBeta)/24;
    finalTheta = ((24-i)*sourceTheta + i*targetTheta)/24;
    v = FLAMEModel(C,finalBeta,finalTheta);
    vertface2obj(v,C.F,sprintf('%d.obj', 120+i));
    h = figure('visible','off');
    dispFace(v, C.F, [.8 .8 .8]);
    saveas(h, sprintf('%d.png', 120+i));
    close(h);
end

B = zeros(644, 1143, 3);
for i = 421:545
    A = imread(sprintf('%d.png', i));
    B1 = imresize(A(:, :, 1), [644 1143]);
    B2 = imresize(A(:, :, 2), [644 1143]);
    B3 = imresize(A(:, :, 3), [644 1143]);
    B(:, :, 1) = B1;
    B(:, :, 2) = B2;
    B(:, :, 3) = B3;
    B = uint8(B);
    imwrite(B, sprintf('%d.png', i));
end