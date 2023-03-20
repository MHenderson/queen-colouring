library(dplyr)
library(igraph)
library(ggraph)
library(here)
library(targets)
library(tidygraph)

tar_source()

results <- tar_read(results2)

results <- head(results, n = 100)

X <- results %>%
  mutate(
    G = map(problem_file, ~ read_graph(., format = "dimacs"))
  ) %>%
  mutate(
    tG = map(G, as_tbl_graph)
  ) %>%
  mutate(
    tGc = map2(tG, colouring, f)
  )

X %>%
  mutate(
    proper = map_lgl(tGc, is_proper),
    grundy = map_lgl(tGc, is_grundy)
  )
