
library(Matrix)


gitLists <- 1

for (i in 1:length(gitLists))
{
  filename <- "edgelist-topforums-1884113.csv"
  el <- read.csv(filename, header=TRUE, row.names=NULL)
  ###These lines added because the node names are numeric, and 
  ## R interprets them as ints by default
  el$source <- as.character(el$source)
  el$target <- as.character(el$target)
  ###
  elM <- as.matrix(el) 

  library(Matrix)
  A <- spMatrix(nrow=length(unique(el$source)),
                ncol=length(unique(el$target)),
                i = as.numeric(factor(el$source)),
                j = as.numeric(factor(el$target)),
                x = rep(1, length(as.numeric(el$source))) )
  row.names(A) <- levels(factor(el$source))
  colnames(A) <- levels(factor(el$target))
  A
  
  Arow <- A %*% t(A)
  Acol <- t(A) %*% A
  
  library(igraph)
  iA <- graph.incidence(A, mode=c("all"))  ###very dense
  iA <- delete.vertices(iA, V(iA)[ degree(iA)<30])
  plot(iA, layout=layout.kamada.kawai)
  
  ### This generates an error
  ### Error in graph.bipartite(xs) : 
  ########(list) object cannot be coerced to type 'logical'
  xs <- bipartite.projection(iA)
  print(xs[[1]], g=TRUE, e=TRUE)
  print(xs[[2]], g=TRUE, e=TRUE)

  
}