library(igraph)
library(purrr)

is_grundy_vertex_ <- function(G, v) {

  colour_of_v <- vertex_attr(G, "colour", v)

  if(colour_of_v == 1) {
    result <- TRUE
  } else {
    colours_of_neighbours_of_v <- vertex_attr(G, "colour", neighbors(G, v))
    result <- setequal(union(1:(colour_of_v - 1), colours_of_neighbours_of_v), colours_of_neighbours_of_v)
  }

  return(result)

}

is_proper_vertex_ <- function(G, v) {

  colour_of_v <- vertex_attr(G, "colour", v)
  colours_of_neighbours_of_v <- vertex_attr(G, "colour", neighbors(G, v))

  result <- !is.element(colour_of_v, colours_of_neighbours_of_v)

  return(result)

}

is_grundy_vertex <- Vectorize(is_grundy_vertex_, vectorize.args = "v")
is_proper_vertex <- Vectorize(is_proper_vertex_, vectorize.args = "v")

is_grundy <- function(G) {
  all(is_grundy_vertex(G, V(G)))
}

is_proper <- function(G) {
  all(is_proper_vertex(G, V(G)))
}

add_graphs <- function(X) {
  X %>%
    mutate(
      G = map(problem_file, ~ read_graph(., format = "dimacs"))
    ) %>%
    mutate(
      tG = map(G, as_tbl_graph)
    )
}

apply_colouring <- function(tG, colouring) {
  tG %>%
    activate(nodes) %>%
    mutate(colour = colouring)
}

# this should also test properness?
is_grundy_pc <- function(path, colouring) {
  G <- read_graph(path, format = "dimacs")
  tG <- as_tbl_graph(G)
  tGc <- tG %>%
    activate(nodes) %>%
    mutate(colour = colouring)
  is_grundy(tGc)
}


