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

  system2("ccli",
          args = glue::glue("greedy --type={type} --ordering={ordering} --seed={seed} {problem_file}"),
          env = "PATH=$PATH:/opt/color/bin:/opt/ccli/",
          stdout = FALSE, stderr = FALSE)

}

greedy <- function(filename) {
  ccli_greedy(filename)
  colouring_res <- readLines(file(paste0(queen_path, ".res")))
  d <- as.numeric(stringr::str_split(paste(colouring_res[2:3], collapse = " "), " ")[[1]])
  d <- d[!is.na(d)]
  return(d)
}
