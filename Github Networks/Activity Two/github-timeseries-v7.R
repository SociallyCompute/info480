## TODO
# 1. QUalitative groupings of people
# 2. Grouped by person who is a committer v non-committer
# 3. Look at qual groups and individuals identified as present across time periods
# 4. Adapt these sets to use different colors and shapes over time
# 5. Visualization and statistics related to indivdual network change
# 6. White board out and implement notions of structural fluidity
# 7. COnnect structural fluidity to type of contribution and whether or not it is merged
# 8. Consider weighting in some way by "diff/comment" in a time period ... perhaps including a notion of contribution type
# 9. Profile indidivual users whom we know become more active ...


rm(list=ls(all=TRUE))

library(network)
library(statnet)
library(MASS)
library(ggplot2)
library(Hmisc)
library(reshape)
library(Matrix)


filez <- system ("ls allStuff*.csv", intern=T)
pullerz <- system ("ls z-pullrequesters.csv", intern=T)
mergerz <- system ("ls z-committers.csv", intern=T)

## top pull requestors
pullers <- read.table(pullerz, sep=",", header=TRUE, fill=TRUE, dec=".")

## top mergers
mergers <- read.table(mergerz, sep=",", header=TRUE, fill=TRUE, dec=".")

for (kk in 1:length(filez))
{
	
	tsA <- read.table(filez[kk], sep=",", header=TRUE, fill=TRUE, dec=".")

	infile <- filez[kk]

	tsam <- as.data.frame(tsA)
	
	drops <- c("txt")
	#DF[,!(names(DF) %in% drops)]
	
	tsamB <- tsam
	tsamB <- tsamB[,!(names(tsamB) %in% drops)]
	tsamC <- as.data.frame(tsamB, stringsAsFactors=TRUE)
	newfact <- interaction(tsamC$person, tsamC$timeperiod)
	
	tsamC[7:8, "personTimeperiod"] <- NA
	tsamC$personTimeperiod <- interaction(tsamC$person, tsamC$timeperiod)
	
	###############  VIZ SECTION #########################################
	##This generates a histogram of summary statistics
	filename=paste("timeseries/", "histogram and qplot", infile, ".png")
	png(filename)

	hist.data.frame(tsamC)
	##
	qplot(timeperiodNum, totalDegree, data=tsamC, geom="jitter")
	dev.off()
	###############  VIZ SECTION #########################################
	
	
	wide <- reshape(tsamC, idvar="person", timevar="timeperiod", direction="wide")
	
	### This melting does not preserve the NAs
	melted <- melt(tsamC, id=c("person", "timeperiodNum", "timeperiod", "personTimeperiod"), preserve.na=FALSE)
	viztestA <- cast(melted, person+timeperiodNum ~ variable)
	viztestB <- cast(melted, timeperiodNum+person ~ variable)
	viztestC <- cast(melted, timeperiodNum+timeperiod+person ~ variable)
	viztestD <- cast(melted, person ~ variable)
	
	
	## This selects the people who have more than four of the 11 sessions that they were actually part of
	timePresence <- 4
	xx <- subset(viztestD, inDegree>timePresence, select=c(person))
	#xx <- viztestD
	factor(xx$person)
	fVizA <- viztestA
	fVizA$fPerson <- factor(fVizA$person)
	merged <- merge(xx, fVizA, by = "person", all=FALSE)
	fVizB <- viztestB
	fVizB$fPerson <- factor(fVizB$person)
	mergedB <- merge(fVizB, xx,  by = "person", all=FALSE)
	##these don't give me readable names
	
	
	###############  VIZ SECTION #########################################
	#overview visualizations.  Help to get a sense of the variance in the top people that show up in a network set
	###############  VIZ SECTION #########################################
	filename=paste("timeseries/", "boxplots Total Degree", infile, ".png")
	png(filename)
	qplot(person, totalDegree, data = mergedB, geom = "boxplot", label=totalDegree)
	dev.off()

	filename=paste("timeseries/", "boxplots in Degree", infile, ".png")
	png(filename)
	qplot(person, inDegree, data = mergedB, geom = "boxplot", label=inDegree)
	dev.off()

	filename=paste("timeseries/", "boxplots out Degree", infile, ".png")
	png(filename)
	qplot(person, outDegree, data = mergedB, geom = "boxplot", label=outDegree)
	dev.off()

	filename=paste("timeseries/", "boxplots Betweenness", infile, ".png")
	png(filename)
	qplot(person, betweenness, data = mergedB, geom = "boxplot", label=betweenness)
	dev.off()
	###############  VIZ SECTION #########################################
	
	##TODO##
	# 1. Consider just running everything for the 11 full months of data that we have.  This would 
	## provide a more consistent measure and visualization.
	
	#### Another Melting that preserves the NAs
	library(reshape)
	meltedB <- melt(tsamC, id=c("person", "timeperiodNum", "timeperiod", "personTimeperiod"), na.rm=FALSE)
	viztestA2 <- cast(meltedB, person+timeperiodNum ~ variable, add.missing=TRUE)
	viztestB2 <- cast(meltedB, timeperiodNum+person ~ variable, add.missing=TRUE)
	viztestC2 <- cast(meltedB, timeperiodNum+timeperiod+person ~ variable, add.missing=TRUE)
	viztestD2 <- cast(meltedB, person ~ variable, add.missing=TRUE)
	
	library(reshape2)
	viztestA3 <- cast(meltedB, person+timeperiodNum ~ variable, fill=0, add.missing=TRUE)
	viztestB3 <- cast(meltedB, timeperiodNum+person ~ variable, fill=0, add.missing=TRUE)
	viztestC3 <- cast(meltedB, timeperiodNum+timeperiod+person ~ variable, fill=0, add.missing=TRUE)
	viztestD3 <- cast(meltedB, person ~ variable, fill=0, add.missing=TRUE)
	
	
	library(scales)
	
	gVizA <- viztestA3
	gVizA$fPerson <- factor(gVizA$person)
	gMerged <- merge(xx, gVizA, by = "person", all=FALSE)
	gVizB <- viztestB
	gVizB$fPerson <- factor(fVizB$person)
	gmergedB <- merge(gVizB, xx,  by = "person", all=FALSE)

	daMergers <- merge(mergers, gVizA, by="person", all=FALSE)
	daPullers <- merge(pullers, gVizA, by="person", all=FALSE)

	################ A summary plot incorporating all network statistics, revealing role #############
	### Code to manually vary the color scheme for N different samples
	### --- Function to create more color variance
	library(RColorBrewer)
	my.cols <- function(y) {
		blacky <- "#000000"
		if (y < 9) {
			c(black,brewer.pal(y-1, "Set2"))
		}
		else {
			c(blacky,hcl(h=seq(0,(y-2)/(y-1), length=y-1)*360, l=65, fixup=TRUE))
		}
		
	}
	
	##### Getting mergers and pull requesters filtered #####
		
	long.visualize <- function(gMerged,subgroup){
		
			###############  VIZ SECTION #########################################
			###############  OVERALL STATS #######################################
			
			pa <- ggplot(gMerged, aes(timeperiodNum, inDegree, group=person))
			pa <- pa + geom_line(aes(colour = betweenness))
			ggsave(paste(filez[kk], subgroup, "betweenness exploratory graph over time.png"), dpi=600, plot=pa, width=12, height=12)
		
			pb <- ggplot(gMerged, aes(timeperiodNum, outDegree, group=person))
			pb <- pb + geom_line(aes(colour = betweenness))
			ggsave(paste(filez[kk], subgroup, "out degree exploratory graph by time.png"), dpi=600, plot=pb, width=12, height=12)
		
			pc <- ggplot(gMerged, aes(timeperiodNum, betweenness, group=person))
			pc <- pc + geom_line(aes(colour = totalDegree))
			ggsave(paste(filez[kk], subgroup, "betweenness exploratory graph by time.png"), dpi=600, plot=pc, width=12, height=12)
		
			
			pc <- ggplot(gMerged, aes(timeperiodNum, betweenness, group=person))
			pc <- pc + geom_line(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=12), legend.position="top")
			ggsave(paste(filez[kk], subgroup, "betweenness exploratory graph by time-WITHNAMES.png"), dpi=600, plot=pc, width=12, height=12)
		
			
			########### Summmary Plots by network statistic ###############################
			pc <- ggplot(gMerged, aes(timeperiodNum, log(betweenness), group=person))
			pc <- pc + geom_line(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=12), legend.position="top") 
			ggsave(paste(filez[kk], subgroup, "betweenness exploratory graph by time-WITHNAMES.png"), dpi=600, plot=pc, width=12, height=12)
		
			
			pc <- ggplot(gMerged, aes(timeperiodNum, log(inDegree), group=person))
			pc <- pc + geom_line(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=12), legend.position="top") 
			ggsave(paste(filez[kk], subgroup, "inDegree exploratory graph by time-WITHNAMES.png"), dpi=600, plot=pc, width=12, height=12)
		
			pc <- ggplot(gMerged, aes(timeperiodNum, log(outDegree), group=person))
			pc <- pc + geom_line(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=12), legend.position="top") 
			ggsave(paste(filez[kk], subgroup, "outDegree exploratory graph by time-WITHNAMES.png"), dpi=600, plot=pc, width=12, height=12)
		
			pc <- ggplot(gMerged, aes(timeperiodNum, log(totalDegree), group=person))
			pc <- pc + geom_line(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=12), legend.position="top") 
			ggsave(paste(filez[kk], subgroup, "totalDegree exploratory graph by time-WITHNAMES.png"), dpi=600, plot=pc, width=12, height=12)
			
		
			####IN DEGREE - OUT DEGREE -- Showing Roles####
			pc <- ggplot(gMerged, aes(timeperiodNum, inDegree-outDegree, group=person))
			pc <- pc + geom_line(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=12), legend.position="top") 
			ggsave(paste(filez[kk], subgroup, "MEASURE ROLES - InDegree-OutDegree difference exploratory graph by time-WITHNAMES.png"), plot=pc, dpi=600, width=12, height=12)
		
			#############################
		
			
			################
			#x <- my.cols(40)
			x <- my.cols(120)
			pc <- ggplot(gMerged, aes(timeperiodNum, inDegree-outDegree, group=person, size=betweenness))
			pc <- pc  + geom_line(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=20), legend.title=theme_text(size=24),legend.position="top",axis.text.x=theme_text(size=20), axis.text.y=theme_text(size=20),   axis.title.x = theme_text(size=20), axis.title.y = theme_text(size=20, angle=90), panel.background = theme_rect(fill = "white", colour = NA)) +ylab("In Degree MINUS Out Degree")+xlab("Time Period Number")	
			ggsave(paste("pubtweak/",filez[kk], subgroup, "MEASURE ROLES - InDegree-OutDegree difference exploratory graph by time-WITHNAMES + LineThickness.png"), dpi=600, plot=pc, width=12, height=12)	
			pc <- pc + geom_boxplot(width=.4, alpha=.3)
			ggsave(paste("pubtweak/",filez[kk], subgroup, "Boxplot - MEASURE ROLES - InDegree-OutDegree difference exploratory graph by time-WITHNAMES + LineThickness.png"), dpi=600, plot=pc, width=12, height=12)	
			######### A plot using points with the same data as the section with betweenness
			pc <- ggplot(gMerged, aes(timeperiodNum, inDegree-outDegree, group=person, size=betweenness))
			pc <- pc + geom_point(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=20), legend.title=theme_text(size=24), axis.text.x=theme_text(size=20), axis.title.x = theme_text(size=20), axis.title.y = theme_text(size=20, angle=90), axis.text.y=theme_text(size=20), legend.position="top", panel.background = theme_rect(fill = "white", colour = NA)) +ylab("In Degree MINUS Out Degree")+xlab("Time Period Number")

			ggsave(paste("pubtweak/",filez[kk], subgroup, "KEY--MEASURE ROLES - InDegree-OutDegree difference exploratory graph by time-WITHNAMES.png"), dpi=600, plot=pc, width=12, height=12)	
			################
			
			######## A plot using the text of the names as the dot in the dotplot iteration above ##########
			pc <- ggplot(gMerged, aes(timeperiodNum, inDegree-outDegree, group=person, size=betweenness, label=person, alpha=0.1))
			pc <- pc + geom_text(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=12), legend.position="top", panel.background = theme_rect(fill = "white", colour = NA)) + scale_colour_manual(values=x)
			ggsave(paste(filez[kk], subgroup, "KEY--MEASURE ROLES - InDegree-OutDegree difference exploratory graph by time-WITHNAMES.png"), dpi=600, plot=pc, width=12, height=12)
			
			########shortened Names ########################################################################
			####^^^^^^^^^^^^^^^^^^^^^ indegree - out degree ###############################
			
			pc <- ggplot(gMerged, aes(timeperiodNum, inDegree-outDegree, group=person, size=betweenness, label=substr(person, 1,6), alpha=0.1))
			pc <- pc + geom_text(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=12), title = "ROLES: In Degree minus Out Degree with Betweenness",  legend.position="top", panel.background = theme_rect(fill = "white", colour = NA)) + scale_colour_manual(values=x)
			ggsave(paste(filez[kk], subgroup, "KEY--MEASURE ROLES - InDegree-OutDegree difference exploratory graph by time-WITHNAMES.png"), dpi=600, plot=pc, width=12, height=12)
		
			####^^^^^^^^^^^^^^^^^^^^^ in degree  ###############################
			pc <- ggplot(gMerged, aes(timeperiodNum, inDegree, group=person, size=betweenness, label=substr(person, 1,6), alpha=0.1))
			pc <- pc + geom_text(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=12), title = "ROLES (talked to most by others): In Degree with Betweenness",  legend.position="top", panel.background = theme_rect(fill = "white", colour = NA)) + scale_colour_manual(values=x)
			ggsave(paste(filez[kk], subgroup, "KEY--MEASURE ROLES - INDEGREE exploratory graph by time-WITHNAMES.png"), dpi=600, plot=pc, width=12, height=12)
			
			####^^^^^^^^^^^^^^^^^^^^^ out degree  ###############################
			pc <- ggplot(gMerged, aes(timeperiodNum, outDegree, group=person, size=betweenness, label=substr(person, 1,6), alpha=0.1))
			pc <- pc + geom_text(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=12), title = "ROLES (Talking the Most): Out Degree with Betweenness",  legend.position="top", panel.background = theme_rect(fill = "white", colour = NA)) + scale_colour_manual(values=x)
			ggsave(paste(filez[kk], subgroup, "KEY--MEASURE ROLES - InDegree-OutDegree difference exploratory graph by time-WITHNAMES.png"), dpi=600, plot=pc, width=12, height=12)	
			####################################################
			
			####^^^^^^^^^^^^^^^^^^^^^ betweenness  ###############################
			pc <- ggplot(gMerged, aes(timeperiodNum, betweenness, group=person, size=totalDegree, label=substr(person, 1,6), alpha=0.1))
			pc <- pc + geom_text(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=12), title = "Betweenness and Total Degree Centrality",  legend.position="top", panel.background = theme_rect(fill = "white", colour = NA)) + scale_colour_manual(values=x)
			ggsave(paste(filez[kk], subgroup, "KEY--MEASURE ROLES - betweenness exploratory graph by time-WITHNAMES.png"), dpi=600, plot=pc, width=12, height=12)
			#######################################################################
	}

		long.visualize(gMerged,"not classified")
		long.visualize(daPullers," PULL REQUESTERS ")
		long.visualize(daMergers," MERGERS ")
}

###############  OVERALL STATS #######################################
###############  VIZ SECTION #########################################
################## END ###############################################


###########################################################################################
########## work line ######################################################################
library(directlabels)
pc <- ggplot(gMerged, aes(timeperiodNum, inDegree-outDegree, group=person, size=betweenness, alpha=0.1))
pc + geom_line(aes(colour = person)) + guides(colour=guide_legend(nrow=5)) + opts(legend.text = theme_text(colour="blue", size=12), legend.position="top", panel.background = theme_rect(fill = "white", colour = NA)) + scale_colour_manual(values=x) 
### to to ### +direct.labels(parameters... )


#### TODO:  Would like to add a data table to the plot
data_table <- ggplot(gMerged, aes(x = inDegree-outDegree, y = factor(person),
     label = format(value, nsmall = 1), colour = person)) +
     geom_text(size = 3.5) + theme_bw() + scale_y_discrete(formatter = abbreviate)
     #limits = c("Minneapolis", "Raleigh", "Phoenix")) +
     opts(panel.grid.major = none 
         #+ opts(plot.margin = unit(c(-0.5, 1, 0, 0.5), "lines")) 
         + xlab(NULL) + ylab(NULL))
         
data_table <- ggplot(gMerged, aes(outDegree, factor(person)))
     + theme_bw()
     
##TODO - Larger color palette or split into multiple groups.

############
## summary statistics
############
aggdata <- aggregate(meltedB, by=list(meltedB$person, meltedB$variable), FUN=sd)


########## work line ######################################################################
###########################################################################################


#+opts(legend.text = theme_text(colour="blue", size=12), legend.position="top")


#identify(pc$timeperiodNum,pc$betweenness,labels=pc$person)
###############  VIZ SECTION #########################################


##########ARCHIVE NOTES###################
##Converts to a matrix
testrr <- dcast(tsamC, person~timeperiodNum, value.var="inDegree", fill=0)

p <- ggplot(viztestA,aes(x=inDegree,y=timeperiodNum,label=rownames(viztestA), color=res*10, size=abs(res*10)))+xlab("Betweenness Centrality")+ylab("Eigenvector Centrality")



