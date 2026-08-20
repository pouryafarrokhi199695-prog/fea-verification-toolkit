# FEA Verification Toolkit

A compact MATLAB toolkit for **mesh-convergence assessment** and **reproducible finite-element post-processing**.

> **Release status:** v1.0.0. The supplied self-test suite passed in MATLAB, both example scripts executed successfully, and the three-grid GCI implementation reproduces NASA Glenn Research Center's published benchmark within the stated numerical tolerances.

The repository is intentionally solver-agnostic. It is designed for engineers and researchers who want transparent, auditable numerical checks around finite-element results without depending on proprietary model files.

## What it includes

- Successive mesh-refinement change metrics
- Error relative to the finest available mesh
- Three-grid Richardson extrapolation and Grid Convergence Index (GCI) for uniform refinement
- Equal-time marker placement for time-history plots
- A reusable publication-figure formatting helper
- Synthetic examples that can be run without external data
- Lightweight MATLAB self-tests

## Engineering intent

This toolkit supports **verification**, not validation.

Mesh convergence can show whether a selected numerical response is stabilizing with discretization. It does **not** prove that the constitutive model, loads, boundary conditions, contacts, or physical assumptions are correct.

For structural FEA, convergence should normally be checked on more than one response quantity, for example:

- global stress or displacement measures;
- local stress/strain at a justified monitoring location;
- thermal gradients;
- reaction forces;
- energy quantities where relevant.

## Repository structure

```text
fea-verification-toolkit/
├─ src/
│  ├─ meshConvergenceMetrics.m
│  ├─ gciThreeGrid.m
│  ├─ markerByTime.m
│  └─ applyPublicationStyle.m
├─ examples/
│  ├─ example_mesh_convergence.m
│  └─ example_time_history.m
├─ tests/
│  └─ run_tests.m
├─ docs/
│  └─ verification_notes.md
├─ CITATION.cff
└─ README.md
```

## Quick start

Add `src` to the MATLAB path:

```matlab
addpath('src')
```

Run the convergence example:

```matlab
run('examples/example_mesh_convergence.m')
```

Run the time-history example:

```matlab
run('examples/example_time_history.m')
```

Run the tests:

```matlab
run('tests/run_tests.m')
```

## Example: mesh-convergence metrics

```matlab
h = [0.20 0.10 0.05];
response = [412.0 421.5 424.0];

M = meshConvergenceMetrics(h, response);
disp(M.table)
```

For a three-grid, constant-refinement-ratio study:

```matlab
phiFine   = 424.0;
phiMedium = 421.5;
phiCoarse = 412.0;
r = 2.0;

G = gciThreeGrid(phiFine, phiMedium, phiCoarse, r);
disp(G)
```

## Verification benchmark

`tests/run_tests.m` includes a regression test against NASA Glenn Research Center's published three-grid convergence example. The test checks apparent order, Richardson extrapolation, both reported GCI values, and the asymptotic-range ratio.

## Notes on GCI

`gciThreeGrid` is intended for a conventional three-grid study with a **constant refinement ratio**. The result should be interpreted cautiously when:

- the response is oscillatory or non-monotonic (the function intentionally withholds a conventional GCI result);
- the solution is not in the asymptotic range;
- the apparent order is unstable;
- the response crosses zero;
- local singularities dominate the selected quantity.

See [`docs/verification_notes.md`](docs/verification_notes.md).

## Data policy

All example values in this repository are **synthetic demonstration data**. No proprietary client model, unpublished project dataset, or confidential finite-element model is included.

## Author

**Pourya Farrokhi**  
Structural Engineering · Advanced FEA & Structural Integrity  
[Axis FEA](https://axisfea.com) · [ORCID](https://orcid.org/0009-0006-4463-308X)

## Reuse and licensing

No open-source license is granted with this release. The source is publicly viewable on GitHub, but no additional permission to copy, modify, or redistribute is granted beyond rights provided by applicable law and GitHub's platform terms.
