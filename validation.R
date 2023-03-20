library(dplyr)
library(igraph)
library(ggraph)
library(here)
library(targets)
library(tidygraph)

tar_source()

results <- tar_read(results2)

N <- 5

X <- results %>%
  filter(n_colours == 2*n) %>%
  filter(n == N) %>%
  filter(kempe == FALSE)

i <- 1

queen_graph <- read_graph(X[[i, "problem_file"]], format = "dimacs")

queen5_tbl <- as_tbl_graph(queen_graph)

queen5_tbl_c <- queen5_tbl %>%
  activate(nodes) %>%
  mutate(colour = X[[i, "colouring"]][[1]])


is_proper(queen5_tbl_c)

is_grundy(queen5_tbl_c)

G <- queen5_tbl_c

# grundy vertices
V(G)[is_grundy_vertex(G, V(G))]

# non-grundy vertices
V(G)[!is_grundy_vertex(G, V(G))]
