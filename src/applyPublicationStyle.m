function applyPublicationStyle(ax)
%APPLYPUBLICATIONSTYLE Apply a restrained publication-ready figure style.
%
%   applyPublicationStyle()
%   applyPublicationStyle(ax)
%
% Defaults:
%   - Times New Roman
%   - white figure background
%   - 16 cm x 9 cm figure size
%   - boxed axes
%   - major and minor grid
%
% The function intentionally does not force line colors.

    if nargin < 1 || isempty(ax)
        ax = gca;
    end

    fig = ancestor(ax, 'figure');

    set(fig, 'Color', 'w', ...
        'Units', 'centimeters', ...
        'Position', [2 2 16 9]);

    set(ax, ...
        'FontName', 'Times New Roman', ...
        'FontSize', 10, ...
        'LineWidth', 0.8, ...
        'Box', 'on');

    grid(ax, 'on');
    ax.XMinorGrid = 'on';
    ax.YMinorGrid = 'on';

    xlabelHandle = get(ax, 'XLabel');
    ylabelHandle = get(ax, 'YLabel');
    titleHandle = get(ax, 'Title');

    set([xlabelHandle ylabelHandle titleHandle], ...
        'FontName', 'Times New Roman');
end
