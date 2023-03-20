run_experiments <- function(x, n_iter = 20, seed = 42) {

  set.seed(seed)

  seeds <- sample(1:100000, n_iter)

  experiments <- list(
    problem_file = here::here("graphs", glue::glue("queen{x}_{x}.col")) %>% as.character(),
    type = c("simple", "large", "small", "random"),
    ordering = c("inorder", "random", "decdeg", "incdeg"),
    seed = seeds,
    cheat = FALSE,
    kempe = c(TRUE, FALSE)
  ) %>%
    purrr::cross_df()

  experiments %>%
    mutate(
      colouring = pmap(experiments, ccli_greedy_colouring)
    )

}

compute_n_colours <- function(results) {
  results %>%
    mutate(
      n = as.numeric(str_match(problem_file, "([0-9]+).col")[,2]),
      n_colours = map_dbl(colouring, max)
    )
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
