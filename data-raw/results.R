library(dplyr)
library(glue)
library(here)
library(purrr)
library(readr)
library(stringr)
library(tictoc)

ccli_greedy <- function(problem_file, seed = 42, type = "random", ordering = "lbfsd") {
  system2("ccli",
          args = glue::glue("greedy --type={type} --ordering={ordering} --seed={seed} {problem_file}"),
          env = "PATH=$PATH:/opt/color/bin:/opt/ccli/",
          stdout = FALSE, stderr = FALSE)
}

ccli_greedy_clrs <- function(problem_file, seed = 42, type = "simple", ordering = "random") {

  output_file <- paste0(problem_file, ".res")
  if(file.exists(output_file)) {
    file.remove(output_file)
  }
  x <- ccli_greedy(problem_file, seed, type, ordering)
  output <- readr::read_file(output_file)
  file.remove(output_file)
  as.numeric(stringr::str_match_all(output, "CLRS ([0-9]+)")[[1]][,2])

}

n_iter <- 50
orders <- 5:16

set.seed(42)

seeds <- sample(1:100000, n_iter)
files <- glue("queen{orders}_{orders}.col") %>% as.character()

experiments <- list(
    problem_file = here("graphs", files),
    type = c("simple", "large", "small", "random"),
    ordering = c("inorder", "random", "decdeg", "incdeg"),
    seed = seeds
  ) %>%
    cross_df()

tic()
results <- experiments %>%
  mutate(
    n_colours = pmap_dbl(experiments, ccli_greedy_clrs)
  )
toc()

results <- results %>%
  mutate(
    n = as.numeric(str_match(problem_file, "([0-9]+).col")[,2])
  )

write_rds(results, here("data", "results.rds"))
