library(igraph)

queen5 <- read_graph("graphs/queen5_5.col", format = "dimacs")

gorder(queen5)
ecount(queen5)

plot(queen5, vertex.size = 5, vertex.size2 = 5, vertex.label = NA, edge.arrow.mode = 0, layout = layout_in_circle)

colouring_res <- readLines(file("graphs/queen5_5.col.res"))

d <- as.numeric(stringr::str_split(paste(colouring_res[2:3], collapse = " "), " ")[[1]])

d <- d[!is.na(d)]

coloured_queen <- set_vertex_attr(queen5, "color", value = d)

plot(queen5,
     vertex.size = 5,
     vertex.size2 = 5,
     vertex.label = NA,
     vertex.color = vertex_attr(coloured_queen, "color"),
     edge.arrow.mode = 0,
     layout = layout_in_circle)


