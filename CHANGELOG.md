# Changelog

## 1.0.0 — 2026-08-20

- Promoted the toolkit to the first public-release candidate after MATLAB runtime verification.
- Confirmed the complete self-test suite passes in MATLAB.
- Confirmed both supplied example scripts execute successfully.
- Retained the NASA Glenn three-grid GCI benchmark regression test.
- Retained conservative guards for non-monotonic refinement and non-positive apparent order.
- No open-source license is granted with this release.

## 0.9.0-rc2 — 2026-08-20

- Preserved the NASA Glenn three-grid GCI benchmark regression test.
- Added a conservative guard for non-monotonic/oscillatory refinement.
- Removed the absolute-value treatment of apparent order so a negative
  order cannot be misrepresented as positive convergence.
- Added a regression test for non-positive apparent order.
- Added a regression test for non-monotonic refinement.
- Withheld an open-source license pending an explicit reuse decision.

## 0.9.0-rc1 — 2026-08-20

- Added NASA Glenn benchmark regression test.
- Added fine and coarse-pair GCI reporting.
- Added asymptotic-range ratio.
- Added basic input-validation tests.
- Marked package as pre-publication.
