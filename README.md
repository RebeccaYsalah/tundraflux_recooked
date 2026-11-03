# tundraflux_recooked

This repository reproduces ("re-cooks") the analysis from the following paper:

> Maes, S. L. et al. (2024). *Environmental drivers of increased ecosystem respiration in a warming tundra.* https://doi.org/10.1038/s41586-024-07274-7

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
    ├── tundraflux                  (original repository, kept unchanged)
    └── tundraflux_recooked         (this repository)
        ├── config_template.R
        ├── meta-analysis           (R scripts)
        └── upscaling               (R scripts)
```
The scripts are not in the repository root but in the subfolders. `config_template.R` (and your personal `config.R`) stay in the **root** of `tundraflux_recooked`.

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
git clone https://github.com/mjalava/tundraflux.git tundraflux
git clone https://github.com/RebeccaYsalah/tundraflux_recooked.git tundraflux_recooked
```

Place the data in `PROJECT/data`

## Step 1: get the code running

- Only work and make changes in the scripts of **`tundraflux_recooked`** (commit and push them to regularly)
- Keep **`tundraflux`** unchanged as a reference

### Setting the working directory

Paths are handled in two steps, so nobody has to edit scripts:

1. **`here()`** finds the root of this repository, no matter which subfolder a script is in.
2. **`config.R`** (your personal copy of `config_template.R`) defines where the data and the original repository are on *your* computer.

### One-time setup

1. Install the package: `install.packages("here")`.
2. Open `tundraflux_recooked` as an **RStudio project** (File → New Project → Existing Directory), or open the folder itself in VS Code. This makes sure R starts in the repository root.
3. Create your personal config file in the repository root:

   ```r
   file.copy("config_template.R", "config.R")
   ```

4. Open `config.R` and change a path only if your folders differ from the structure above. `config.R` is in `.gitignore`, so it is never committed.

### Using it in scripts

Scripts in `meta-analysis` and `upscaling` start with the same lines. Because `here()` always points to the repository root, the path to `config.R` is the same from every subfolder:

```r
library(here)
source(here("config.R"))

# Load data: Paths from config.R: data_dir
dat <- read.csv(file.path(data_dir, "<insert_file_name>.csv"))

```


# Files inside this repository: give the subfolders ("meta-analysis" or "upscaling") as separate arguments
```r
source(here("meta-analysis", "df_0_study_design_fig1.R"))
```

Never use `setwd()`, `../` or absolute paths in scripts. Use `here()` for files inside this repository and `data_dir` / `orig_dir` for everything outside it.

### Check that it works

```r
library(here)
here()                      # should end in .../tundraflux_recooked
source(here("config.R"))
stopifnot(dir.exists(data_dir), dir.exists(orig_dir))

# Original scripts in their subfolders
list.files(orig_dir, pattern = "\\.R$", recursive = TRUE)
```

If `here()` prints a different folder, restart R (`Ctrl+Shift+F10` in RStudio) and make sure the repository is opened as a project or folder.

This setup works on Windows, macOS and Linux. Use the Terminal on macOS/Linux, or Git Bash / the RStudio terminal on Windows.
