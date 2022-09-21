generate_experiments <- function(n_iter = 1, orders = 5:7, seed = 42) {

  set.seed(seed)

  seeds <- sample(1:100000, n_iter)
  files <- glue("queen{orders}_{orders}.col") %>% as.character()

  experiments <- list(
    problem_file = here("graphs", files),
            type = c("simple", "large", "small", "random"),
        ordering = c("inorder", "random", "decdeg", "incdeg"),
            seed = seeds,
           cheat = c(TRUE, FALSE),
           kempe = c(TRUE, FALSE)
  ) %>% cross_df()

}

run_experiments <- function(experiments) {

  results <- experiments %>%
    mutate(
      n_colours = pmap_dbl(experiments, ccli_greedy_n_colours)
    )

  results <- results %>%
    mutate(
      n = as.numeric(str_match(problem_file, "([0-9]+).col")[,2])
    )

  return(results)

}

plot_results <- function(results) {

  results %>%
    group_by(n) %>%
    slice_max(n_colours) %>%
    group_by(n) %>%
    slice(1) %>%
    ggplot(aes(n, n_colours)) +
    geom_point() +
    geom_text(hjust = -.2, vjust = .8, aes(label = paste0("(", n, ",", n_colours, ")"))) +
    geom_abline(colour = "blue", alpha = .2, slope = 1, intercept = 0) +
    ylim(0, 30) +
    xlim(0, 30) +
    theme_minimal()

}
