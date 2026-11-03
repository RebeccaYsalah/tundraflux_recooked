# tundraflux_recooked

This repository reproduces ("re-cooks") the analysis from the following paper:

> Maes, S. L. et al. (2024). *Environmental drivers of increased ecosystem respiration in a warming tundra.*

## Aim

The project has two steps:

1. **Reproduction:** Use the data and R code provided with the paper to check whether the original analysis can be redone and the published results reproduced.
2. **Critical review and optimization:** Critically investigate the original analysis (methods, assumptions, code) and, where appropriate, improve or optimize it.

## Original data and code

The original R scripts and data that accompany the paper are available here:

- Github (this repository) contains all R scripts on https://github.com/mjalava/tundraflux
- Zenodo contains all data on https://zenodo.org/10.5281/zenodo.10572480

All credit for the original data, code and analysis goes to the authors of the paper. This repository is an independent re-analysis and is not affiliated with the original authors.

## Folder structure

The analysis is organized in the following project structure:

```
PROJECT
├── data
└── git_repositories
    ├── tundraflux
    └── tundraflux_recooked
```

| Folder | Description |
|---|---|
| `PROJECT` | Root folder of the whole project. |
| `data` | Data used in the analysis, kept outside the git repositories. |
| `git_repositories/tundraflux` | Local clone of the original repository (https://github.com/mjalava/tundraflux), kept unchanged as the reference. |
| `git_repositories/tundraflux_recooked` | This repository: the re-run, review and optimized version of the analysis. |

## Getting started

Clone both repositories into the `git_repositories` folder:

```bash
cd PROJECT/git_repositories
git clone https://github.com/mjalava/tundraflux.git
git clone https://github.com/RebeccaYsalah/tundraflux_recooked.git
```

Place the data in `PROJECT/data`, then follow the scripts in this repository.

## Status

Work in progress.
