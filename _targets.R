library(targets)

tar_option_set(
  packages = c("dplyr", "ggplot2", "glue", "here", "purrr", "stringr"),
    format = "rds"
)

tar_source()

list(
  tar_target(
       name = experiments,
    command = generate_experiments(n_iter = 20, orders = 5:16, seed = 42)
  ),
  tar_target(
       name = results,
    command = run_experiments(experiments)
  ),
  tar_target(
       name = results2,
    command = compute_n_colours(results)
  ),
  tar_target(
       name = plot,
    command = plot_results(results2)
  )
)
