clear; clc;

addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src'));

fprintf('FEA Verification Toolkit - self tests\n');
fprintf('-------------------------------------\n');

%% 1. meshConvergenceMetrics
h = [0.20 0.10 0.05];
phi = [100 104 105];

M = meshConvergenceMetrics(h, phi);

assert(numel(M.meshSize) == 3);
assert(M.finestResponse == 105);
assert(abs(M.table.ErrorToFinestPct(end)) < 1e-12);
fprintf('[PASS] meshConvergenceMetrics basic checks\n');

%% 2. NASA published three-grid GCI benchmark
% NASA Glenn Research Center, "Examining Spatial (Grid) Convergence"
% Published example:
%   fine   = 0.97050
%   medium = 0.96854
%   coarse = 0.96178
%   r      = 2
% Reference results:
%   p      = 1.786170 (approximately)
%   f_ext  = 0.97130  (approximately)
%   GCI12  = 0.103083 %% (approximately)
%   GCI23  = 0.356249 %% (approximately)
%
% Reference:
% https://www.grc.nasa.gov/www/wind/valid/tutorial/spatconv.html

G = gciThreeGrid(0.97050, 0.96854, 0.96178, 2.0);

assert(abs(G.apparentOrder - 1.786170) < 1e-5);
assert(abs(G.extrapolatedResponse - 0.9713003) < 1e-6);
assert(abs(G.GCI_finePct - 0.103083) < 1e-5);
assert(abs(G.GCI_coarsePairPct - 0.356249) < 1e-5);
assert(abs(G.asymptoticRatio - 1.0) < 0.01);
fprintf('[PASS] NASA GCI benchmark regression test\n');

%% 3. markerByTime
x = linspace(0, 10, 101);
idx = markerByTime(x, 6);

assert(idx(1) == 1);
assert(idx(end) == 101);
assert(all(diff(idx) > 0));
fprintf('[PASS] markerByTime endpoint/order checks\n');

%% 4. Input validation
didFail = false;
try
    gciThreeGrid(1, 0.9, 0.8, 1.0);
catch
    didFail = true;
end
assert(didFail);
fprintf('[PASS] invalid refinement-ratio rejection\n');

didFail = false;
try
    meshConvergenceMetrics([0.2 0.1], [1 2 3]);
catch
    didFail = true;
end
assert(didFail);
fprintf('[PASS] inconsistent input-length rejection\n');

%% 5. Non-monotonic refinement must not produce conventional GCI
Gosc = gciThreeGrid(1.00, 0.90, 0.95, 2.0);

assert(~Gosc.isMonotonic);
assert(isnan(Gosc.apparentOrder));
assert(isnan(Gosc.GCI_finePct));
assert(isnan(Gosc.extrapolatedResponse));
fprintf('[PASS] non-monotonic refinement guard\n');

%% 6. Monotonic sequence with non-positive apparent order must be rejected
% Differences increase toward the finer mesh:
% e21 = 0.10 and e32 = 0.05, so log(|e32/e21|)/log(r) < 0.
Gdiv = gciThreeGrid(1.00, 0.90, 0.85, 2.0);

assert(Gdiv.isMonotonic);
assert(Gdiv.apparentOrder <= 0);
assert(isnan(Gdiv.GCI_finePct));
assert(isnan(Gdiv.extrapolatedResponse));
fprintf('[PASS] non-positive apparent-order guard\n');

fprintf('\nAll tests passed.\n');
