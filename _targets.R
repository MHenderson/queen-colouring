library(targets)

tar_option_set(
  packages = c("dplyr", "ggplot2", "glue", "here", "purrr", "stringr"),
    format = "rds"
)

tar_source()

list(
  tar_target(
       name = experiments,
    command = {
      
      orders <- 5:6

      set.seed(42)

      seeds <- sample(1:100000, 4)
      files <- glue("queen{orders}_{orders}.col") |> as.character()

      list(
        problem_file = here("graphs", files),
                type = c("simple", "large", "small", "random"),
            ordering = c("inorder", "random", "decdeg", "incdeg"),
                seed = seeds,
               cheat = c(TRUE, FALSE),
               kempe = c(TRUE, FALSE)
      ) |> cross_df()
    }

  ),
  tar_target(
       name = results,
    command = {
      experiments |>
        mutate(
          colouring = pmap(experiments, ccli_greedy_colouring)
        )
    }
  ),
  tar_target(
       name = results2,
    command = {
      results |>
        mutate(
                  n = as.numeric(str_match(problem_file, "([0-9]+).col")[,2]),
          n_colours = map_dbl(colouring, max)
        )
    }
  ),
  tar_target(
       name = plot,
    command = {
      results2 |>
        group_by(n) |>
        slice_max(n_colours) |>
        group_by(n) |>
        slice(1) |>
        ggplot(aes(n, n_colours)) +
          geom_point() +
          geom_text(hjust = -.2, vjust = .8, aes(label = paste0("(", n, ",", n_colours, ")"))) +
          geom_abline(colour = "blue", alpha = .2, slope = 1, intercept = 0) +
          ylim(0, 30) +
          xlim(0, 30) +
          theme_minimal()

    }
  ),
  tar_target(
       name = save_plot,
    command = {
      ggsave(
            plot = plot,
        filename = "plot/results.png",
           width = 4000,
          height = 3000,
           units = "px"
      )
    }
  )
)
