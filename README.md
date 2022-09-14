Colouring Queen Graphs
================
Matthew Henderson
14/09/2022

![](figure/results_plot-1.png)<!-- -->

``` r
results %>%
  group_by(n) %>%
  slice_min(n_colours) %>%
    ggplot(aes(n, n_colours, colour = method)) +
    geom_jitter(size = 1, alpha = .3, height = 0) +
    geom_abline(colour = "blue", alpha = .2, slope = 1, intercept = 0) +
    ylim(0, 30) +
    xlim(0, 30) +
    theme_minimal()
```

![](figure/other_results_plot-1.png)<!-- -->
