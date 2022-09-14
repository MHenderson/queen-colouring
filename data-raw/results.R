library(dplyr)
library(glue)
library(here)
library(purrr)
library(readr)
library(stringr)
library(tictoc)

source(here("R", "ccli_greedy.R"))
source(here("R", "ccli_greedy_clrs.R"))

n_iter <- 5
orders <- 5:16

set.seed(42)

seeds <- sample(1:100000, n_iter)
files <- glue("queen{orders}_{orders}.col") %>% as.character()

experiments <- list(
    problem_file = here("graphs", files),
    type = c("simple", "large", "small", "random"),
    ordering = c("inorder", "random", "decdeg", "incdeg"),
    seed = seeds,
    cheat = c(TRUE, FALSE),
    kempe = c(TRUE, FALSE)
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
