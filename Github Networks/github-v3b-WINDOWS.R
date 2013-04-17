#!/usr/bin/env Rscript 

## Look at the networksis package for this data...
## Quite a gap between methods used in journals and the methods that
## are available for use.  R plays a role 

## TODO - GOOGLE VIS in R

rm(list=ls(all=TRUE))

library(network)
library(statnet)

########
## Other Libraries with Utility for network analysis
########
#library(tnet)
#library(igraph)
#library(lsa)
#library(RODBC)
#library(ggplot2)
#library(blockmodeling)
#igraph.par("print.vertex.attributes", TRUE)
#igraph.par("print.edge.attributes", TRUE)

graphSetArray <- c()
graphPrefixArray <- c()
inDegArray <- c()
outDegArray <- c()
betweennessArray <- c()
labelArray <- c()
nodeArray <- c()

####################################################################
# Read the Data in
####################################################################

### Windows version of file directory listing
gitLists <- shell("dir /B project*edgelist.csv", intern=TRUE)

### Mac version of file directory listing
# gitLists <- system("ls project*edgelist.csv", intern=T)

for (i in 1:length(gitLists))
{
	filename <- gitLists[i]
	el <- read.csv(filename, header=TRUE, row.names=NULL)
	disAll=network(el,matrix.type="edgelist")
  
  centered <- centralization(disAll, degree, normalize)
	
	ideg <- degree(disAll, cmode="indegree")
	odeg <- degree(disAll, cmode="outdegree")
	
	set.vertex.attribute(disAll, "indegree", degree(disAll, cmode="indegree"))
	set.vertex.attribute(disAll, "outdegree", degree(disAll, cmode="outdegree"))

	viz1=paste("output/",filename,"viz1",i,".png")
	png(viz1)
	plot(disAll, displayisolates = FALSE, vertex.col="blue", edge.len=(1/n$mel.dist)) 
	dev.off()

	viz2=paste("output/",filename,"viz2",i,".png")
	png(viz2)
	gplot(disAll,vertex.cex=(ideg+odeg)^0.5/2, vertex.sides=50, label.cex=0.8, vertex.col=rgb(odeg/max(odeg), 0, ideg/max(ideg)), label=network.vertex.names(disAll), displayisolates=FALSE,  boxed.labels=FALSE)
	gplot(disAll,vertex.cex=(ideg+odeg)^0.2/2, vertex.sides=50, label.cex=0.8, 	vertex.col=rgb(odeg/max(odeg), 0, ideg/max(ideg)),  displayisolates=FALSE)
	dev.off()

	viz3=paste("output/",filename,"viz3",i,".png")
	png(viz3)
	hist(ideg, xlab="Indegree", main="Indegree Distribution", prob=TRUE)
	hist(odeg, xlab="Outdegree", main="Outdegree Distribution", prob=TRUE)
	hist(odeg+ideg, xlab="Total degree", main="Total degree Distribution", prob=TRUE)
	plot(ideg, odeg, type="n", xlab="incoming", ylab="outgoing")
	abline(0,1, lty=3)
	text(jitter(ideg), jitter(odeg), network.vertex.names(disAll), cex=0.75, col=2)
	dev.off()
  
  viz4=paste("output/", filename, "nameline", i, ".png")
  png(viz4)
	plot(ideg, odeg, type="n", xlab="incoming", ylab="outgoing", main=centered)
	abline(0,1, lty=3)
	text(jitter(ideg), jitter(odeg), network.vertex.names(disAll), cex=2.0, col=1)
  dev.off()
}


# 
#  This code does not work right now; and its not needed.  Derived from another program used a while ago.
# 
# 	V(disAll)$ideg<-degree(disAll, mode="in")
# 	V(disAll)$odeg<-degree(disAll, mode="out")
# 	V(disAll)$BTW<-signif(betweenness(disAll), digits=2)
# 	labelTwo=paste(V(disAll)$name, "\n", " IN=", V(disAll)$ideg, " OUT=", V(disAll)$odeg,"\n", "Betweenness=",V(disAll)$BTW)
# 	labelThree=paste(V(disAll)$name,",",V(disAll)$ideg,",", V(disAll)$odeg,",", V(disAll)$BTW,",")
# 	#V(disAll)$label <- V(disAll)$name
# 	V(disAll)$label <- labelTwo
# 	V(disAll)$nodeSummary <- labelThree
# 	#print(V(disAll)$label)
# 	labelArray <<- rbind(labelArray, paste(V(disAll)$nodeSummary, collapse=" "))
# 
# 
# 	modeg=max(V(disAll)$odeg)
# 	mideg=max(V(disAll)$ideg)
# 	E(disAll)$width <- E(disAll)$w
# 	E(disAll)$arrow.size <-0.99
# 	E(disAll)$edgeBetween <- edge.betweenness(disAll)
	#E(disAll)$label <- paste("edge betweenness","\n", E(disAll)$edgeBetween)
# 	#layout.spring(disAll,weights=E(disAll)$weight+.01)
# 	V(disAll)$size <-20^((V(disAll)$ideg+V(disAll)$odeg)/(modeg+mideg))
# 	V(disAll)$color <- rgb(V(disAll)$odeg/modeg, 0, V(disAll)$ideg/mideg)
# 
