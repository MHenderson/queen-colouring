ccli_greedy_clrs <- function(problem_file, seed = 42, type = "simple", ordering = "random", cheat = FALSE, kempe = FALSE) {

  output_file <- paste0(problem_file, ".res")

  if(file.exists(output_file)) {
    file.remove(output_file)
  }

  x <- ccli_greedy(problem_file, seed, type, ordering, cheat, kempe)

  output <- readr::read_file(output_file)
  file.remove(output_file)
  as.numeric(stringr::str_match_all(output, "CLRS ([0-9]+)")[[1]][,2])

}
