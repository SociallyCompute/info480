# > install.packages("MASS")
# install.packages("igraph")
# install.packages("statnet")
# install.packages("network")
# Clean space
rm(list=ls(all=TRUE))

# set the working directory
#setwd("/Users/sgoggins/Dropbox/02.  Active Design and Data Gathering/51.  UCERN")

library(igraph)
library(RODBC)
library(RMySQL)

con<-dbConnect(MySQL(), user="student", password="spock450", 
              dbname="getmathy", host="sociotechnical.ischool.drexel.edu")
        
el <- dbGetQuery(con, "
        select b.userID as source, b.parentMessageID as target, sum(counter) as weight
        from _temp_parentthread a, jiveMessage b
        where 
        a.counter >10
        and a.threadID = b.threadID
        and b.userID is not NULL
        and b.parentMessageID is not null 
        group by source, target")

el$source <- as.character(el$source)
el$target <- as.character(el$target)



igraph.options("print.vertex.attributes", TRUE)
igraph.options("print.edge.attributes", TRUE)


##el <- read.table("DataJuly16.txt", header=TRUE)
# remove weights that are low
# After some experimentation, it appears that removing edge weights of 3 or lower
# produces the most parsimonious graph and subgraph
el <- el[el$weight>50,]
#Get the complete list of vertices from the database
#vert <- read.table("vertices.txt", header=TRUE)
#Get the list of vertices that matter after filtering down based on edge weights above
# Each of these below is a bit misleading.  Since this is a bipartite network, the vertex
# list contains two edge type (hence the "bi" part..).. One is a "person", the other is 
# a discussion board.  
##
# Create a list of the people and discussions involved in the edges

PeopleList <- as.data.frame(unique(el$source)) #[el$DiscussionID %in% el$EventCreator]
colnames(PeopleList)[1] <- "vertex"
PeopleList["type"] <- FALSE
DiscussionList <- as.data.frame(unique(el$target)) #[vert$DiscussionID %in% el$DiscussionID]
colnames(DiscussionList)[1] <- "vertex"
DiscussionList["type"] <- TRUE

# Create a combined list of the vertices that stay
#vert3 <- vert[vert$DiscussionID %in% PeopleList,]
#vert4 <- vert[vert$DiscussionID %in% DiscussionList,]
# use rbind to combine them.  

vert5 <- rbind(PeopleList, DiscussionList)
#
#create the graph
g <- graph.data.frame(el, vertices=vert5)
V(g)$degree <- degree(g)

#setup parameters for the graph
#line weights and layout style
#layout.fruchterman.reingold(g, weights=E(g)$weight)
# layout.kamada.kawai(g, weights=E(g)$weight)
layout.lgl(g, weights=E(g)$weight)

	E(g)$width <- log(E(g)$weight)
	E(g)$arrow.size <-.4
	V(g)$label <- V(g)$name
	V(g)[ type == FALSE ]$color <- "yellow"
	V(g)[ type == TRUE ]$color <- "pink"
	V(g)[ type == FALSE ]$label.color <- "black"
	V(g)[ type == TRUE ]$label.color <- "blue"
	V(g)$size <- sqrt(V(g)$degree)*2


plot.igraph(g)


# decompose the graph into a series of smaller subgraphs that indicate connectivity

lugnut <-  decompose.graph(g, min.vertices=5)

for (i in 1:length(lugnut)) {
	layout.fruchterman.reingold(lugnut[[i]], weights=(E(lugnut[[i]])$weight))
	E(lugnut[[i]])$width <- log10(E(lugnut[[i]])$weight)
	E(lugnut[[i]])$arrow.size <-.7
	V(lugnut[[i]])$label <- V(lugnut[[i]])$name
	V(lugnut[[i]])[ type == FALSE ]$color <- "yellow"
	V(lugnut[[i]])[ type == TRUE ]$color <- "pink"
	V(lugnut[[i]])[ type == FALSE ]$label.color <- "black"
	V(lugnut[[i]])[ type == TRUE ]$label.color <- "blue"	
  #size calc gave an error
  #V(lugnut[[i]])$size <- 4*sqrt(alpha.centrality(lugnut[[i]], V(lugnut[[i]])))	
		#V(lugnut[[i]])[ type == TRUE ]$label.color <- "white"
	V(lugnut[[i]])$label.cex <- 1 	
	# V(lugnut[[i]])$size <- V(lugnut[[i]])$degree

		
	#output the file	
	filename=paste("output/","subgraph",i,".pdf")
	pdf(filename)
	plot.igraph(lugnut[[i]])
	dev.off()
}

for (i in 1:length(lugnut)) {
	b <- c(alpha.centrality(lugnut[[1]], V(lugnut[[1]])))
}

plot.igraph(lugnut[[40]])
# How do I plot a bipartite graph?
# How do I get rid of vertices that are unused in a large graph?
# Create line weights and colors

mean(E(g)$weight)
# [1] 1.297741

median(E(g)$weight)
# [1] 1


