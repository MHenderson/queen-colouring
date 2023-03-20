# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed. # nolint
library(tibble) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("dplyr", "ggplot2", "glue", "here", "igraph", "purrr", "stringr", "tidygraph"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(
  mapped <- tar_map(
    values = tibble(
      order = 5:16
    ),
    tar_target(
      name = runs,
      command = run_experiments(order, n_iter = 10)
    )
  ),
  combined <- tarchetypes::tar_combine(
    results,
    mapped,
    command = dplyr::bind_rows(!!!.x)
  ),
  tar_target(
    name = results_v,
    results %>%
      mutate(
        grundy = map2_lgl(problem_file, colouring, is_grundy_pc)
      )
  ),
  tar_target(
    name = results_end,
    compute_n_colours(results_v)
  ),
  tar_target(
    name = plot,
    plot_results(results_end %>% filter(grundy))
  ),
  tar_render(
    name = readme,
    "README.Rmd"
  )
)
