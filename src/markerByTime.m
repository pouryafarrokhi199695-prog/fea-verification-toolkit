function idx = markerByTime(x, nMarkers)
%MARKERBYTIME Select marker indices at approximately equal x-intervals.
%
%   idx = markerByTime(x, nMarkers)
%
% Useful for time-history curves whose sampling density is nonuniform.
% The first and last samples are always included when nMarkers >= 2.

    validateattributes(x, {'numeric'}, {'vector','real','finite','nonempty'});
    validateattributes(nMarkers, {'numeric'}, ...
        {'scalar','integer','positive','finite'});

    x = x(:);
    n = numel(x);

    if nMarkers >= n
        idx = (1:n).';
        return
    end

    if nMarkers == 1
        idx = 1;
        return
    end

    if any(diff(x) < 0)
        error('x must be monotonically nondecreasing.');
    end

    targets = linspace(x(1), x(end), nMarkers);
    idx = zeros(nMarkers,1);

    for k = 1:nMarkers
        [~, idx(k)] = min(abs(x - targets(k)));
    end

    idx = unique(idx, 'stable');

    if idx(1) ~= 1
        idx = [1; idx];
    end
    if idx(end) ~= n
        idx = [idx; n];
    end
end
