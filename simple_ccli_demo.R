library(here)

source(here("R", "ccli_greedy.R"))

ccli_greedy_colouring(here("graphs", "queen5_5.col"))

ccli_greedy_n_colours(here("graphs", "queen5_5.col"))
