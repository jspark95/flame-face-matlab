clear; close('all'); fclose('all');
% addpath('./Module'); addpath('./tensorlab'); 

load FLAME_G.mat;


%%%%%%%%%% DATA SET %%%%%%%%%%%%
DIR1 = "./cohn-kanade-images";
landDir = './Lands';

SELECTED_PER_NO = 1;
SELECTED_POSE_NO = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% PARAMETERS %%%%%%%%%%
OptimIter = 3;
WregEXP = 0.005;
WregID = 0.5;

initLx = 0.5; initLy = 0.6;

isUseL2Reg = true;                  % DELTA_REG Parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Inner and Outer Landmarks Definition
idx_intraocular = [40 43];
idx_inner = 18:66;

% opts = optimoptions(@lsqnonlin, 'Display', 'off');
opts = optimoptions(@fmincon, 'Display', 'off');

% %% Make Result Directory
% PATH = '';
% for i = 1:10000
%     PATH = sprintf('./OUT_%s_%d', date, i);
%     [~,~,pCorr] = mkdir(PATH);
% 
%     if strcmp(pCorr, 'MATLAB:MKDIR:DirectoryExists') == 0
%         break;
%     end
% end

%% List Database
dirs = dir(sprintf('%s/S*', DIR1));
nperson = size(dirs, 1);

fprintf('Person %03d/%03d\n', SELECTED_PER_NO, nperson);

subdirs = dir(sprintf('%s/%s/0*', DIR1, dirs(SELECTED_PER_NO).name));
npose = size(subdirs, 1);

fprintf('Pose %03d/%03d\n', SELECTED_POSE_NO, npose);

files = dir(sprintf('%s/%s/%s/*.png', DIR1, dirs(SELECTED_PER_NO).name, subdirs(SELECTED_POSE_NO).name));
nfile = size(files, 1);


[im, S, Q] = readDataset(sprintf('%s/%s/%s', DIR1, dirs(SELECTED_PER_NO).name, subdirs(SELECTED_POSE_NO).name), landDir, files, initLx, initLy);
S = S(idx_inner, :); % Landmark

%% Initialize
R0 = [0 0 1 0];
t0 = [0; 0; 10];

Ground2D = S(:);



%% Function Set

function res = EfuncLocalReg(S, Q, R, t, Core, beta, theta, WregEXP, isUseL2Reg)
    Shape2D = gen2DLandShape(Q, R, t, Core, beta, theta);

    Land2D = reshape(S, [length(S)/2, 2]);
    
    LandDif = (Land2D - Shape2D);
    LandDif = LandDif ./ sqrt(length(LandDif));

    Reg = [];
    if (WregEXP > 0)
        if (isUseL2Reg)
            Reg = e;  % L2 Normaliization
        else
            Reg = sqrt(abs(e));  % L1 Normalization
        end

        Reg = Reg .* sqrt(WregEXP); % Expression Regulization Weight
        Reg = Reg .* sqrt((max(Land2D(:, 1))-min(Land2D(:, 1)))); % 얼굴의 너비의 제곱에 비례하게 Weighting 작동 확인 안함
    end

    res = [LandDif(:) ; Reg(:)];
end


function [Img, Lands, Q] = readDataset(ImgDir, landDir, files, initLx, initLy)
    nPoses = size(files, 1);

    Img = imread(sprintf('%s/%s', ImgDir, files(nPoses).name));
    [~, onlyname, ~] = fileparts(files(nPoses).name);
    land_file = sprintf('%s/%s.txt', landDir, onlyname);
    land_text = fopen(land_file,'r');
    landmark_data = fscanf(land_text,'%f');

    %% Custumized
    nLands = 68;
    tmp68 = [landmark_data((1:nLands)*2-1,1),landmark_data((1:nLands)*2,1)];
    tmp =  [tmp68(1:60,:);tmp68(62:64,:);tmp68(66:68,:)];
    
    
    %% Landmark 
    Lands = [tmp(:,1) (size(Img, 1) - tmp(:,2))];
    fclose(land_text);

    Q = zeros(3,3);
    f = max(size(Img)); %*- %Initial focal length
    Q(1,3) = size(Img, 2) * initLx;
    Q(2,3) = size(Img, 1) * initLy;
    
    Q(1,1) = f; Q(2,2) = f; Q(3,3) = 1;
end