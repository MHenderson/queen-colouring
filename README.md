Colouring Queen Graphs
================
Matthew Henderson
22/09/2021

-   [Using ccli from R](#using-ccli-from-r)
-   [Number of colours used in a greedy
    colouring](#number-of-colours-used-in-a-greedy-colouring)
-   [Colouring Queen Graphs](#colouring-queen-graphs)

## Using ccli from R

ccli is a bash script for calling Culberson’s colouring programs from
the command-line.

The `ccli_greedy` function below is used to call Culberson’s greedy
program from R via ccli.

There is no return value from `ccli_greedy`. Instead the result if
written to a file which has the same name as the input file appended
with a .res extension.

Notice here that both ccli and culberson’s colouring programs have been
installed under /opt and so those paths have to be given in the env
argument.

``` r
ccli_greedy <- function(problem_file, seed = 42, type = "random", ordering = "lbfsd") {
  system2("ccli",
    args = glue::glue("greedy --type={type} --ordering={ordering} --seed={seed} {problem_file}"),
    env = "PATH=$PATH:/opt/color/bin:/opt/ccli/",
    stdout = FALSE, stderr = FALSE)
}
```

For example, to colour the 16x16 queen graph using random vertex
ordering and a simple greedy approach.

``` r
set.seed(42)

ccli_greedy(problem_file = "graphs/queen16_16.col",
            type = "simple", ordering = "random")
```

``` r
readLines(file("graphs/queen16_16.col.res"))
#>  [1] "CLRS 23 FROM GREEDY cpu =  0.00 pid = 2842"                                      
#>  [2] " 20   5   7  22  10  12   4   9   6  11  14   2   8   3   1  15   1  15  11   6 "
#>  [3] " 18  14  19   2  17   5   4   3  16  13   7  10   2   3   8   9  17  10  11   1 "
#>  [4] " 13  18  21   7  15  20   4   6  12   4  10  13  15  20   5  18   8   1  11  19 "
#>  [5] " 17   6   3   7   5  17  12  11   3   4   1  15  16   6  10  14   7   8  18   9 "
#>  [6] " 11   2   1  10   8  16   7   4  12   9   3  20  13  15  19  17   7  14  13   2 "
#>  [7] "  6  22  12   8  23  21   1   9   3  10  11   5  18  16   9  21  13   7  17  14 "
#>  [8] "  2   3  20  22   5  19  12   4   4   7   3  16  11   9  18  19  22  10   5   1 "
#>  [9] "  2  21  15   8  10  11   6  20   1   3  16  21  15  19  12   8   9   5  17  14 "
#> [10] " 19   1  15  14  12  13   8   5  11   4   9  16  10   7   6   2   9  18   2   7 "
#> [11] "  5  15  21   6  14  16  13  11  20  12   8   3   6  20  16  12   9   1  13   3 "
#> [12] "  7  15   8  18   4  14   2  11  15   8  18  17   7   2  20  10   4  14  19   5 "
#> [13] " 12   1  13  16  17  10   5  19   4   8   3  11   9  12  15   6  14   2  21   1 "
#> [14] "  8  13  14   1  16   6  22  12   3   2   7   4  21   9   5  18 "
```

## Number of colours used in a greedy colouring

In the next section we present the results of an experiment into greedy
colouring of queen graphs. For this experiment we need a function that
calls `ccli_greedy` and parses the number of colours used from the
resulting output file.

``` r
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
```

For example,

``` r
ccli_greedy_clrs(problem_file = "graphs/queen16_16.col",
                 type = "simple", ordering = "random")
#> [1] 23
```

Notice that this number can be much larger than the number of colours in
a colouring with the minimal number of colours.

# Colouring Queen Graphs

Put every experiment into a row of a tibble.

For many experiments use the cross functions.

``` r
library(tibble)

(experiments <- tribble(~problem_file, ~seed, ~type, ~ordering,
        "graphs/queen10_10.col", 42, "simple", "random",
        "graphs/queen10_10.col", 43, "simple", "random",
        "graphs/queen10_10.col", 44, "simple", "random",
        "graphs/queen16_16.col", 42, "simple", "random",
        "graphs/queen16_16.col", 41, "simple", "random",
        "graphs/queen16_16.col", 40, "simple", "random",
        ))
#> # A tibble: 6 x 4
#>   problem_file           seed type   ordering
#>   <chr>                 <dbl> <chr>  <chr>   
#> 1 graphs/queen10_10.col    42 simple random  
#> 2 graphs/queen10_10.col    43 simple random  
#> 3 graphs/queen10_10.col    44 simple random  
#> 4 graphs/queen16_16.col    42 simple random  
#> 5 graphs/queen16_16.col    41 simple random  
#> 6 graphs/queen16_16.col    40 simple random
```

Use pmap from purrr to run an experiment for each row.

``` r
library(dplyr)
library(purrr)

(results <- experiments %>%
  mutate(
    n_colours = pmap_dbl(experiments, ccli_greedy_clrs)
  ))
#> # A tibble: 6 x 5
#>   problem_file           seed type   ordering n_colours
#>   <chr>                 <dbl> <chr>  <chr>        <dbl>
#> 1 graphs/queen10_10.col    42 simple random          16
#> 2 graphs/queen10_10.col    43 simple random          17
#> 3 graphs/queen10_10.col    44 simple random          15
#> 4 graphs/queen16_16.col    42 simple random          23
#> 5 graphs/queen16_16.col    41 simple random          23
#> 6 graphs/queen16_16.col    40 simple random          23
```

Now we can use summarise to find the minimum number of colours for each
graph.

``` r
results %>%
  group_by(problem_file) %>%
  summarise(
    n_colours = min(n_colours)
  )
#> # A tibble: 2 x 2
#>   problem_file          n_colours
#>   <chr>                     <dbl>
#> 1 graphs/queen10_10.col        15
#> 2 graphs/queen16_16.col        23
```

Notice that in this experiment we are trusting that the files represent
the graphs they claim to represent. But we don’t really know that. So
here is a good application for the work on graph property testing.
