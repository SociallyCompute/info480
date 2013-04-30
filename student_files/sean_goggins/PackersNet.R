## Look at the networksis package for this data...
## Quite a gap between methods used in journals and the methods that
## are available for use.  R plays a role 
# install.packages("RODBC")
# install.packages("MASS")
# install.packages("igraph")
# install.packages("statnet")
# install.packages("network")

rm(list=ls(all=TRUE))

library(network)
library(statnet)
library(MASS)
library(ggplot2)
library(rgl)

#### This one cycles through all CSV files in a particular directory.  Its
# designed for period specific .csvs to be dumped and then ordered to 
# work so that a file by timeperiod is produced.
# Another script "github-statnet-performance-Vn-SPG.R handles a file
# where time period is already embedded, adn includes performance proxies
# including merged and status .. this file also includes the type of 
# activity include.

files <- system ("ls packersNet.csv", intern=T)

for (i in 1:length(files)) {
	fileNamer = as.character(i)
	infile <- files[i]
	# Import the files
	el <- read.table(files[i], sep=",", header=TRUE, fill=TRUE, dec=".")
	timers <- unique(el$timeperiodNum)
	timers <- sort(timers)
	#### This removes time periods for github where the time period length is greater than one month.
	timers <- subset(timers,timers[]>24)
	print(timers)
	n=network(el,matrix.type="edgelist")
	for (lfp in 1: length(timers))
	{	
		rm(n)
		subel <- subset(el, timeperiodNum == lfp-1)
		n=network(subel,matrix.type="edgelist")
		set.edge.attribute(n,"timeperiodNum",el[,3])	
	
		##################################New Stats by Performance Data ####################
	
		## Gettign the individual neighborhoods for each node in the network
		nodeCount <- length(degree(n))
		for (nodeStats in 1:nodeCount )
		{
			neighbs <- get.neighborhood(n,nodeStats)
			print(paste("I am ... ",(network.vertex.names(n)[nodeStats])))
			neighbCount <- length(get.neighborhood(n,nodeStats))
			if (neighbCount > 0)
			{
				for (neighberhoodz in 1:neighbCount)
				{
					print(network.vertex.names(n)[neighbs[neighberhoodz]])
				}
			}
			else {				
			print("-------i live alone")
			}				
		print(neighbs)
		print("next person")	
		}
		print(i)
		
		ideg <- degree(n, cmode="indegree")
		odeg <- degree(n, cmode="outdegree")
		N <- length(degree(n))
	
		##################################New Stats by Performance Data ####################
		#						END	
		##################################New Stats by Performance Data ####################
		
	###########################################
	## Summary Network Statistics
	###########################################
		inDegree <-rbind(0)
		outDegree <-rbind(0)
		betweenness <-rbind(0)
		totalDegree <- rbind(0)
	
		fileListA <- data.frame(txt=rep("", N), txt=rep("", N), num=rep(NA, N), 
			num=rep(NA, N), num=rep(NA, N), num=rep(NA, N), txt=rep("",N), num=rep(NA, N),  # as many cols as you need
		                 stringsAsFactors=FALSE) 
	    colnames(fileListA)[2] <- 'person'             
		colnames(fileListA)[3] <- 'inDegree'
	    colnames(fileListA)[4] <- 'outDegree'
	    colnames(fileListA)[5] <- 'betweenness'
	    colnames(fileListA)[6] <- 'totalDegree'
	    colnames(fileListA)[7] <- 'timeperiod'
	    colnames(fileListA)[8] <- 'timeperiodNum'
		
		for (j in 1:N)
		{
			degree(n)
			names <- network.vertex.names(n)[j]
			idegA <- degree(n, nodes=j, cmode="indegree")
			odegA <- degree(n, nodes=j, cmode="outdegree")
			between <- betweenness(n, nodes=j)
			totDegree <- degree(n, nodes=j)
			timePeriod <- infile
			timePeriodNum <- lfp-1
			fileListA[j,] <- c(N[j],names,idegA,odegA,between,totDegree,timePeriod,timePeriodNum)
	
		}
		namerDude <- paste("output/longMatrix",lfp, infile,".csv")
		write.csv(file=namerDude, fileListA)
		namerTwo <- paste("output/allStuff", infile, ".csv")
		
		if (lfp-1==0){
			write.table(file=namerTwo, fileListA, sep=",", row.names=FALSE, col.names=TRUE)
		}
		else
			write.table(file=namerTwo, fileListA, sep = ",", append=TRUE,col.names=FALSE, row.names=FALSE)
	
	###########################################
	###########################################
		
		# Basic Graph
		filename=paste("output/",lfp," 1graphOne",infile,".png")
		png(filename)
		gplot(n, displayisolates=FALSE,edge.len=(1/n$mel.dist),label=network.vertex.names(n), boxed.labels=FALSE, 	label.pad=0.01, main=filename)
		dev.off()
	
		# Show graph of centrality measures
		filename=paste("output/",lfp," 2graphTwo-MidPlots",infile,".png")
		png(filename)
		plot(ideg, odeg, type="n", xlab="In Degree", ylab="Out Degree", main=filename)
		abline(0,1, lty=3)
		text(jitter(ideg), jitter(odeg), network.vertex.names(n), cex=0.75, col=2)
		dev.off()
	
		# Simple histograms of degree distribution
		par(mfrow=c(2,2))
		filename=paste("output/",lfp," 3graphThree-histogram",infile,".png")
		png(filename)
		atitle=paste(filename,i, "Total Degree Distribution")
		hist(ideg, xlab="Indegree", main="Indegree Distribution", prob=TRUE)
		hist(odeg, xlab="Outdegree", main="Outdegree Distribution", prob=TRUE)
		hist(odeg+ideg, xlab="Total degree", main=atitle, prob=TRUE)
		dev.off()
		par(mfrow=c(1,1))
	
		# Use centrality scores to size and color the network plot
		filename=paste("output/",lfp," 4graphFourCentralityColorized",infile,".png")
		png(filename)
			
		# weighted vertex size adjustment
		gplot(n,vertex.cex=(ideg+odeg)^0.5/7, vertex.sides=50, label.cex=0.8, vertex.col=rgb(odeg/max(odeg), 0, ideg/max	(ideg)), label=network.vertex.names(n), displayisolates=FALSE,  boxed.labels=FALSE, pad=5, main=filename)
		
		dev.off()
	
		# Show network diagram with betweenness centrality as the key sizing dimension
		bet <- betweenness(n,gmode="graph")
		filename=paste("output/",lfp," 5graphFiveBetweennessPlot",infile,".png")
		png(filename)
		gplot(n, vertex.cex=sqrt(bet)/12, gmode="graph", label.cex=0.8, label=network.vertex.names(n), 	displayisolates=FALSE,  boxed.labels=FALSE, main=filename)
		dev.off()
		
		## Plot the largest weak component
		cl <- component.largest(n, connected="weak")        # Who's in the largest component? 
		cl 
		filename=paste("output/",lfp, " 6graphSixLargest-Weak-Component",infile,".png")
		png(filename)
		gplot(n[cl,cl], boxed.lab=TRUE, label.cex=0.5, label.col=4, label=network.vertex.names(n)[cl], displayisolates=FALSE, main=filename) # Plot the largest 		weak component
		dev.off()
		
		cl <- component.largest(n, connected="strong")        # Who's in the largest component? 
		cl 
		filename=paste("output/",lfp, " 7graphSevenLargest-Strong-Component",infile,".png")
		png(filename)
		gplot(n[cl,cl], boxed.lab=TRUE, label.cex=0.5, label.col=4, label=network.vertex.names(n)[cl], displayisolates=FALSE, main=filename) # Plot the largest 		weak component
		dev.off()
		
		filename=paste("output/",lfp, " 8neighborhoods",infile,".png")
		png(filename)
		neigh<-neighborhood(n,9,return.all=TRUE)
		par(mfrow=c(3,3))
		for(k in 1:9)
		{
			gplot(neigh[k,,],main=paste("Partial Neighborhood of Order",k))
		}
		dev.off()
  }	## end of time period clause
     
} ### end of for files clause

##################################This section creates statistics at the network level #################
	centA <-rbind(0)
	centB <-rbind(0)
	densa <-rbind(0)
	dyadicRec <- rbind(0)
	edgewiseRec <- rbind(0)
	transitivity <- rbind(0)
	transitiveCompletion <-rbind(0)
	timeperiod <- rbind(0)
	
	N <- length(files)
	fileList <- data.frame(txt=rep("", N), num=rep(NA, N), 
	num=rep(NA, N), num=rep(NA, N), num=rep(NA, N), num=rep(NA, N), 
	num=rep(NA, N), num=rep(NA, N), num=rep(NA, N),# as many cols as you need
                 stringsAsFactors=FALSE) 
                 
	colnames(fileList)[2] <- 'centralization'
    colnames(fileList)[3] <- 'EVCent'
    colnames(fileList)[4] <- 'density'
    colnames(fileList)[5] <- 'dyadicReciprocity'
    colnames(fileList)[6] <- 'edgeWiseRecip'
    colnames(fileList)[7] <- 'transitivity'
    colnames(fileList)[8] <- 'trans completion'
    colnames(fileList)[9] <- 'timeperiod'
	
for (i in 1:length(files)) {
	# this function is in the MASS package
	fileNamer = as.character(i)
	infile <- files[i]
	# Import the files
	el <- read.table(files[i], sep=",", header=TRUE, fill=TRUE, dec=".")
	# netName = "n"+as.character(i)
	# print(el)
	timers <- unique(el$timeperiodNum)
	timers <- sort(timers)
	#### This removes time periods for github where the time period length is greater than one month.
	timers <- subset(timers,timers[]<12)
	print(timers)
	n=network(el,matrix.type="edgelist")
	for (lfp in 1: length(timers))
	{
		rm(n)
		subel <- subset(el, timeperiodNum == lfp-1)
		n=network(subel,matrix.type="edgelist")
		#print(n)
		set.edge.attribute(n,"timeperiodNum",el[,3])
		#set.edge.attribute(n,"status",el[,4])
		set.edge.attribute(n,"MergedCode",el[,5])
		set.edge.attribute(n,"codeCode",el[,6])
		set.edge.attribute(n,"pullRequestID",el[,7])		
		
		## Do MIDS concentrate?
		a<-centralization(n, degree, cmode="indegree")
		## Eigenvector Centralization
		b<-centralization(n, evcent)
		## Basic network level indices
		c<-gden(n) #density
		d<-grecip(n)  # Dyadic reciprocity
		e<-grecip(n, measure="edgewise") # edgewise reciprocity
		f<-gtrans(n)	#transitivity
		g<-log(gtrans(n)/gden(n)) ## transitive completion LRR
		h<-i
		fileList[i,] <- c(files[i],a,b,c,d,e,f,g,h)
	
		centA <-rbind(centA,a)
		centB <-rbind(centB,b)
		densa <-rbind(densa,c)
		dyadicRec <- rbind(dyadicRec,d)
		edgewiseRec <- rbind(edgewiseRec,e)
		transitivity <- rbind(transitivity,f)
		transitiveCompletion <-rbind(transitiveCompletion,g)
		timeperiod <- rbind(timeperiod,h)
		
		filename=paste("output/networkLevel/",infile, "cent-trans",i,lfp,".png")
		png(filename)
		plot(centB, transitivity, type="n", xlab="Eigenvector Centralization", ylab="Transitivity", pch=g)
		abline(0,1, lty=3)
		text(jitter(centB), jitter(transitivity), round(centB[,], digits=3), cex=0.75, col=2)
		dev.off()
	
		filename=paste("output/networkLevel/",infile, "in degree cent-trans",i,lfp,".png")
		png(filename)
		plot(centA, transitivity, type="n", xlab="In Degree Centralization", ylab="Transitivity")
		abline(0,1, lty=3)
		text(jitter(centA), jitter(transitivity), round(centA[,], digits=3), cex=0.75, col=2)
		dev.off()
	
		filename=paste("output/networkLevel/",infile, "dyadic-rec--edgewise-rec",i,lfp,".png")
		png(filename)
		plot(dyadicRec, edgewiseRec, type="n", xlab="Dyadic Reciprocity", ylab="Edgewise Reciprocity")
		abline(0,1, lty=3)
		text(jitter(dyadicRec), jitter(edgewiseRec), round(dyadicRec[,], digits=3), cex=0.75, col=2)
		dev.off()
		
		filename=paste("output/networkLevel/",infile, "transcomp-trans",i,lfp,".png")
		png(filename)
		plot(transitiveCompletion, transitivity, type="n", xlab="Transitive Completion", ylab="Transitivity")
		abline(0,1, lty=3)
		text(jitter(transitiveCompletion), jitter(transitivity), round(transitiveCompletion[,], digits=3), cex=0.75, col=2)
		dev.off()
	
		filename=paste("output/networkLevel/",infile, "density-trans",i,lfp,".png")
		png(filename)
		plot(centA, transitivity, type="n", xlab="Density", ylab="Transitivity")
		abline(0,1, lty=3)
		text(jitter(centA), jitter(transitivity), round(centA[,], digits=3), cex=0.75, col=2)
		dev.off()
	}
}


