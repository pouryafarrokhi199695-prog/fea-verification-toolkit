clear; clc;

addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src'));

% Synthetic demonstration data only.
meshSize = [0.20 0.10 0.05];
response = [412.0 421.5 424.0];

M = meshConvergenceMetrics(meshSize, response);

disp('Mesh-convergence summary:')
disp(M.table)

G = gciThreeGrid(response(3), response(2), response(1), 2.0);

disp('Three-grid Richardson/GCI summary:')
disp(G)

figure;
plot(M.meshSize, M.response, '-o', ...
    'LineWidth', 1.2, ...
    'MarkerFaceColor', 'w');

set(gca, 'XDir', 'reverse');
xlabel('Characteristic mesh size');
ylabel('Response quantity');
title('Synthetic mesh-convergence example');

applyPublicationStyle(gca);
