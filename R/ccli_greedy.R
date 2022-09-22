ccli_greedy <- function(problem_file, seed = 42, type = "random", ordering = "lbfsd", cheat = FALSE, kempe = FALSE) {

  if(cheat && kempe) {
    args_string <- "greedy --cheat --kempe --type={type} --ordering={ordering} --seed={seed} {problem_file}"
  } else if(cheat && !kempe) {
    args_string <- "greedy --cheat --type={type} --ordering={ordering} --seed={seed} {problem_file}"
  } else if(!cheat && kempe) {
    args_string <- "greedy --kempe --type={type} --ordering={ordering} --seed={seed} {problem_file}"
  } else {
    args_string <- "greedy --type={type} --ordering={ordering} --seed={seed} {problem_file}"
  }

  output_file <- paste0(problem_file, ".res")

  if(file.exists(output_file)) {
    file.remove(output_file)
  }

  system2("ccli",
          args = glue::glue(args_string),
          env = "PATH=$PATH:/opt/color/bin:/opt/ccli/",
          stdout = FALSE, stderr = FALSE)

  result <- readLines(file(output_file))

  file.remove(output_file)

  return(result)

}

ccli_greedy_colouring <- function(problem_file, seed = 42, type = "simple", ordering = "random", cheat = FALSE, kempe = FALSE) {
  colouring_res <- ccli_greedy(problem_file, seed, type, ordering, cheat, kempe)
  n_output_rows <- length(colouring_res)
  d <- as.numeric(stringr::str_split(paste(colouring_res[2:n_output_rows], collapse = " "), " ")[[1]])
  d <- d[!is.na(d)]
  return(d)
}

ccli_greedy_n_colours <- function(problem_file, seed = 42, type = "simple", ordering = "random", cheat = FALSE, kempe = FALSE) {
  colouring_res <- ccli_greedy(problem_file, seed, type, ordering, cheat, kempe)
  as.numeric(stringr::str_match_all(colouring_res, "CLRS ([0-9]+)")[[1]][,2])
}
