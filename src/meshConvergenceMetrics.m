function M = meshConvergenceMetrics(meshSize, response)
%MESHCONVERGENCEMETRICS Basic mesh-refinement response metrics.
%
%   M = meshConvergenceMetrics(meshSize, response)
%
% Inputs
%   meshSize : vector of characteristic mesh sizes. Larger values are
%              treated as coarser meshes.
%   response : vector of scalar response values corresponding to meshSize.
%
% Output
%   M : structure containing sorted data and a summary table.
%
% The function reports:
%   - successive relative change (%);
%   - absolute relative difference from the finest available mesh (%).
%
% This is a verification aid. It does not establish model validation.

    validateattributes(meshSize, {'numeric'}, ...
        {'vector','real','finite','positive','nonempty'});
    validateattributes(response, {'numeric'}, ...
        {'vector','real','finite','nonempty'});

    meshSize = meshSize(:);
    response = response(:);

    if numel(meshSize) ~= numel(response)
        error('meshSize and response must have the same number of entries.');
    end

    if numel(meshSize) < 2
        error('At least two mesh levels are required.');
    end

    [h, idx] = sort(meshSize, 'descend');
    phi = response(idx);

    n = numel(h);
    successiveChangePct = NaN(n,1);

    for k = 2:n
        denom = max(abs(phi(k)), eps);
        successiveChangePct(k) = abs(phi(k) - phi(k-1)) / denom * 100;
    end

    finest = phi(end);
    denomFinest = max(abs(finest), eps);
    errorToFinestPct = abs(phi - finest) / denomFinest * 100;

    level = (1:n).';
    T = table(level, h, phi, successiveChangePct, errorToFinestPct, ...
        'VariableNames', {'Level','MeshSize','Response', ...
        'SuccessiveChangePct','ErrorToFinestPct'});

    M = struct();
    M.meshSize = h;
    M.response = phi;
    M.finestResponse = finest;
    M.table = T;
end
