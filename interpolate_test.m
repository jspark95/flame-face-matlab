numVerts = length(C_noEye.meanVerts);
numFaces = length(C_noEye.F);

newV = zeros(numVerts + numFaces, 3);
newF = zeros(3 * numFaces, 3);
newShapeDirs = zeros(numVerts + numFaces, 3, 400);
newPoseDirs = zeros(numVerts + numFaces, 3, 18);
newBlendWeights = zeros(numVerts + numFaces, 3);

numJoints = 2;

newV(1:numVerts, :) = C_noEye.meanVerts;
newF(1:numFaces, :) = C_noEye.F;
newShapeDirs(1:numVerts, :, :) = C_noEye.shapeDirs;
newPoseDirs(1:numVerts, :, :) = C_noEye.poseDirs;
newRegJoint = full(C_noEye.regJoint);
newRegJoint = [newRegJoint, zeros(3,numFaces)];
newRegJoint = sparse(newRegJoint);
newBlendWeights(1:numVerts, :) = C_noEye.blendWeights;


for i = 1:numFaces
    vertIdx = numVerts + i;
    tmpV = (newV(C_noEye.F(i,1),:) + newV(C_noEye.F(i,2),:) + newV(C_noEye.F(i,3),:))./3;
    tmpF = [vertIdx, C_noEye.F(i,1), C_noEye.F(i,2); vertIdx, C_noEye.F(i,2), C_noEye.F(i,3); vertIdx, C_noEye.F(i,3), C_noEye.F(i,1)];
    
    dist1 = norm(tmpV - newV(C_noEye.F(i,1),:));
    dist2 = norm(tmpV - newV(C_noEye.F(i,2),:));
    dist3 = norm(tmpV - newV(C_noEye.F(i,3),:));
    
    w1 = (1/dist1) ./ ((1/dist1)+(1/dist2)+(1/dist3));
    w2 = (1/dist2) ./ ((1/dist1)+(1/dist2)+(1/dist3));
    w3 = (1/dist3) ./ ((1/dist1)+(1/dist2)+(1/dist3));
    
%     w1 = 1/3;
%     w2 = 1/3;
%     w3 = 1/3;
    
    newV(vertIdx, :) = tmpV;
    newF(3*i-2:3*i, :) = tmpF;

    tmpShapeDirs = w1*C_noEye.shapeDirs(C_noEye.F(i,1), :, :) + w2*C_noEye.shapeDirs(C_noEye.F(i,2), :, :) + w3*C_noEye.shapeDirs(C_noEye.F(i,3), :, :);
    newShapeDirs(vertIdx, :, :) = tmpShapeDirs;
    
    tmpPoseDirs = w1*C_noEye.poseDirs(C_noEye.F(i,1), :, :) + w2*C_noEye.poseDirs(C_noEye.F(i,2), :, :) + w3*C_noEye.poseDirs(C_noEye.F(i,3), :, :);
    newPoseDirs(vertIdx, :, :) = tmpPoseDirs;
    
    % Joint dependent part
    
    % global Joint
    tmpBlendWeights = w1*C_noEye.blendWeights(C_noEye.F(i,1), :) + w2*C_noEye.blendWeights(C_noEye.F(i,2), :) + w3*C_noEye.blendWeights(C_noEye.F(i,3), :);
    newBlendWeights(vertIdx, :) = tmpBlendWeights;

        
end

    
interpC.shapeDirs = newShapeDirs;
interpC.meanVerts = newV;
interpC.poseDirs = newPoseDirs;
interpC.kinTree = C_noEye.kinTree;
interpC.blendWeights = newBlendWeights;
interpC.F = newF;
interpC.regJoint = newRegJoint;