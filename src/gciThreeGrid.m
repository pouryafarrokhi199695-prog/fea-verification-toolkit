function G = gciThreeGrid(phiFine, phiMedium, phiCoarse, r)
%GCITHREEGRID Three-grid Richardson extrapolation and GCI assessment.
%
%   G = gciThreeGrid(phiFine, phiMedium, phiCoarse, r)
%
% Inputs
%   phiFine, phiMedium, phiCoarse : scalar response quantities ordered from
%                                  finest to coarsest grid.
%   r                              : constant refinement ratio (> 1).
%
% Output
%   G : structure containing:
%       apparentOrder
%       extrapolatedResponse
%       approxRelativeErrorFinePct
%       GCI_finePct
%       GCI_coarsePairPct
%       asymptoticRatio
%       isMonotonic
%       note
%
% Assumptions
%   - three systematically refined grids;
%   - approximately constant refinement ratio;
%   - scalar response suitable for Richardson extrapolation;
%   - monotonic convergence for the conventional GCI result reported here.
%
% A factor of safety Fs = 1.25 is used for the three-grid GCI calculation.
% The monotonic calculation follows the standard three-grid
% Richardson/GCI form used in NASA Glenn's published grid-convergence
% example.
%
% Verification aid only: convergence does not establish physical validation.

    validateattributes(phiFine, {'numeric'}, {'scalar','real','finite'});
    validateattributes(phiMedium, {'numeric'}, {'scalar','real','finite'});
    validateattributes(phiCoarse, {'numeric'}, {'scalar','real','finite'});
    validateattributes(r, {'numeric'}, {'scalar','real','finite','>',1});

    e21 = phiFine - phiMedium;
    e32 = phiMedium - phiCoarse;

    G = struct();
    G.refinementRatio = r;
    G.isMonotonic = (e21 * e32) > 0;

    % Fine/medium change is still a useful descriptive quantity even when
    % a Richardson/GCI estimate is not admissible.
    G.approxRelativeErrorFinePct = ...
        abs(e21) / max(abs(phiFine), eps) * 100;

    if abs(e21) <= eps || abs(e32) <= eps
        G.apparentOrder = NaN;
        G.extrapolatedResponse = NaN;
        G.GCI_finePct = NaN;
        G.GCI_coarsePairPct = NaN;
        G.asymptoticRatio = NaN;
        G.note = ['Apparent order is undefined because one refinement ', ...
                  'difference is near zero.'];
        return
    end

    if ~G.isMonotonic
        G.apparentOrder = NaN;
        G.extrapolatedResponse = NaN;
        G.GCI_finePct = NaN;
        G.GCI_coarsePairPct = NaN;
        G.asymptoticRatio = NaN;
        G.note = ['Non-monotonic/oscillatory refinement detected. ', ...
                  'The conventional monotonic Richardson/GCI estimate ', ...
                  'implemented here is intentionally not reported.'];
        return
    end

    ratio = abs(e32 / e21);
    p = log(ratio) / log(r);

    % A non-positive apparent order indicates that the refinement changes
    % are not decreasing in the conventional asymptotic-convergence sense.
    if ~isfinite(p) || p <= 0
        G.apparentOrder = p;
        G.extrapolatedResponse = NaN;
        G.GCI_finePct = NaN;
        G.GCI_coarsePairPct = NaN;
        G.asymptoticRatio = NaN;
        G.note = ['The apparent order is non-positive or undefined. ', ...
                  'Do not interpret this mesh sequence as conventional ', ...
                  'asymptotic convergence.'];
        return
    end

    denom = r^p - 1;
    if abs(denom) <= eps
        G.apparentOrder = p;
        G.extrapolatedResponse = NaN;
        G.GCI_finePct = NaN;
        G.GCI_coarsePairPct = NaN;
        G.asymptoticRatio = NaN;
        G.note = 'Richardson denominator is too small for a stable estimate.';
        return
    end

    phiExt = phiFine + e21 / denom;

    ea21 = abs(e21) / max(abs(phiFine), eps);
    ea32 = abs(e32) / max(abs(phiMedium), eps);

    Fs = 1.25;
    gci21 = Fs * ea21 / denom * 100;
    gci32 = Fs * ea32 / denom * 100;

    asymptoticRatio = gci32 / (r^p * gci21);

    G.apparentOrder = p;
    G.extrapolatedResponse = phiExt;
    G.GCI_finePct = abs(gci21);
    G.GCI_coarsePairPct = abs(gci32);
    G.asymptoticRatio = asymptoticRatio;

    if abs(asymptoticRatio - 1) <= 0.05
        G.note = ['Monotonic refinement with an asymptotic-range ratio ', ...
                  'close to 1. Confirm the mesh sequence and monitored ', ...
                  'quantity are physically appropriate.'];
    else
        G.note = ['Monotonic refinement, but the asymptotic-range ratio ', ...
                  'is not close to 1. Additional refinement may be needed.'];
    end
end
