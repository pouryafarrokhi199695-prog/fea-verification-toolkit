clear; clc;

addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src'));

% Synthetic demonstration data only.
t = linspace(0, 600, 1201);
y = 260 .* (1 - exp(-t/90)) + 20 .* exp(-t/240) .* sin(2*pi*t/85);

idx = markerByTime(t, 12);

figure;
plot(t, y, '-o', ...
    'LineWidth', 1.2, ...
    'MarkerIndices', idx, ...
    'MarkerFaceColor', 'w');

xlabel('Time (s)');
ylabel('Synthetic response');
title('Equal-time marker placement');

applyPublicationStyle(gca);
