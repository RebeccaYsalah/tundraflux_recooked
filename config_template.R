# config_template.R
# -----------------------------------------------------------------------------
# Copy this file to config.R and adjust the paths ONLY if your folder
# structure differs from the default:
#
#   PROJECT/
#   ├── data/
#   └── git_repositories/
#       ├── tundraflux/             (original repository, reference)
#       └── tundraflux_recooked/    (this repository)
#
# config.R is ignored by git (personal paths); config_template.R is tracked.
# Use in scripts:
#   library(here)
#   source(here("config.R"))
# -----------------------------------------------------------------------------

library(here)

# Root of this repository: PROJECT/git_repositories/tundraflux_recooked
repo_dir <- here()

# Root of the whole project: two levels above this repository
project_dir <- normalizePath(file.path(repo_dir, "..", ".."), mustWork = FALSE)

# Data folder (outside the repositories): PROJECT/data
data_dir <- file.path(project_dir, "data")

# Local clone of the original repository (reference, kept unchanged)
orig_dir <- file.path(project_dir, "git_repositories", "tundraflux")

# --- Optional: set absolute paths instead if your setup is different ---------
# data_dir <- "/Users/yourname/some/other/place/data"   # macOS / Linux
# data_dir <- "D:/tundra_data"                           # Windows
# orig_dir <- "/path/to/tundraflux"
# -----------------------------------------------------------------------------

# --- Check that the paths exist ----------------------------------------------
check_paths <- c(data_dir = data_dir, orig_dir = orig_dir)
missing <- names(check_paths)[!dir.exists(check_paths)]

if (length(missing) > 0) {
  stop(
    "These folders were not found: ",
    paste0(missing, " (", check_paths[missing], ")", collapse = ", "),
    "\nCheck the paths in config.R and the folder structure in the README.",
    call. = FALSE
  )
}

message("Config loaded. Repository root: ", repo_dir)