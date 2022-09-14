Colouring Queen Graphs
================
Matthew Henderson
14/09/2022

-   [Colouring Queen Graphs in R with
    ccli](#colouring-queen-graphs-in-r-with-ccli)
-   [Minimal Number of Colours in a Greedy Colouring of a Queen
    Graph](#minimal-number-of-colours-in-a-greedy-colouring-of-a-queen-graph)

# Colouring Queen Graphs in R with ccli

``` r
library(dplyr)
library(ggplot2)
library(here)
library(igraph)
library(readr)
library(stringr)

source(here("R", "ccli_greedy.R"))

queen_path <- here("graphs", "queen5_5.col")

queen5 <- read_graph(queen_path, format = "dimacs")

coloured_queen <- set_vertex_attr(queen5, "color", value = greedy(queen_path))

plot(queen5,
     vertex.size = 8,
     vertex.size2 = 8,
     vertex.label = NA,
     vertex.color = vertex_attr(coloured_queen, "color"),
     edge.arrow.mode = 0,
     layout = layout_on_grid)
```

![](figure/queen_colouring-1.png)<!-- -->

# Minimal Number of Colours in a Greedy Colouring of a Queen Graph

![](figure/results_plot-1.png)<!-- -->

![](figure/other_results_plot-1.png)<!-- -->
