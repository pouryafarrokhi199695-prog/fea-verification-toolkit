# Verification Notes

## 1. Verification is not validation

A mesh-converged finite-element result can still be physically wrong.

Verification asks whether the numerical solution is being solved consistently with respect to discretization and implementation. Validation asks whether the model is an adequate representation of the physical system for the intended use.

Both matter.

## 2. Select response quantities deliberately

A single global maximum can be unstable because the controlling location may migrate between meshes. Consider tracking:

- a global quantity;
- one or more physically justified local quantities;
- reaction or energy measures where relevant;
- thermal gradients for coupled thermal–structural problems.

The selected quantities should be defined consistently on every mesh.

## 3. Be cautious with singularities

Peak stresses at sharp re-entrant corners, idealized point loads, rigid constraints, contact edges, crack tips, and other singular regions may not converge to a finite stress value.

In such cases, use a response quantity appropriate to the mechanics of the problem instead of claiming convergence of a mathematically singular stress peak.

## 4. Richardson extrapolation and GCI

A conventional three-grid GCI estimate is most meaningful when:

1. grids are systematically refined;
2. the refinement ratio is known and approximately constant;
3. the selected response is in the asymptotic convergence range;
4. the response behaves monotonically, or oscillatory behavior is explicitly addressed.

The GCI is not a universal uncertainty bound. It is a structured discretization-error indicator under specific assumptions.

## 5. Report enough information to reproduce the check

A defensible convergence statement should normally identify:

- element formulation;
- characteristic mesh sizes or element counts;
- refinement strategy;
- monitored response quantities;
- values at each refinement level;
- relative change or GCI metric;
- rationale for the adopted mesh.

## 6. Coupled thermal–structural models

For sequential thermal–structural analysis, convergence should be considered in both stages.

A structural result can appear stable even if the underlying thermal field is not adequately resolved, particularly near steep temperature gradients, local cooling patches, or interfaces.


## 7. Reference benchmark used by this repository

The automated regression test reproduces the three-grid example published by
NASA Glenn Research Center in *Examining Spatial (Grid) Convergence*.

Reference values used by `tests/run_tests.m`:

| Quantity | Published value |
| --- | ---: |
| Apparent order, p | 1.786170 |
| Richardson extrapolated value | 0.97130 |
| Fine-grid GCI | 0.103083% |
| Medium/coarse-pair GCI | 0.356249% |
| Asymptotic-range ratio | approximately 1 |

Reference:
https://www.grc.nasa.gov/www/wind/valid/tutorial/spatconv.html

The benchmark verifies that the implemented three-grid arithmetic reproduces
the published example within tight numerical tolerances. It does not certify
the toolkit for every possible FEA application.


## 8. Conservative guards in this implementation

This toolkit intentionally does not report a conventional Richardson/GCI
estimate when the three supplied response values are non-monotonic.

It also rejects a non-positive apparent order. A negative apparent order can
occur when the change between the fine and medium grids is larger than the
change between the medium and coarse grids; taking an absolute value of that
order would incorrectly make a diverging/non-asymptotic sequence appear to
have a positive convergence order.

These guards are deliberate. More advanced treatment of oscillatory
convergence requires methods beyond the simple monotonic three-grid
implementation provided here.
