### Plotting gitHubbary over time
gitHubbary <- read.csv("gitHubbary-age-adjusted.csv")

# Box plots
png("gitHubbary-boxplots.png", width=625)
boxplot(gitHubbary[,4:9], las=1)
dev.off()

# Histograms
par(mfrow=c(6,1), las=1)
for (i in 4:9) {
	hist(gitHubbary[,i], main=colnames(gitHubbary)[i], xlim=c(10,50))
}

# Time series for each county, without transparency
png("gitHubbary-time.png", width=625)
plot(0, 0, xlim=c(2005,2009), ylim=c(0,50), type="n", las=1, xlab="year", ylab="gitHubbary rate", bty="n")
for (i in 1:length(gitHubbary[,1])) {
	lines(2005:2009, gitHubbary[i,5:9], col="#000000")
}
dev.off()

# Time series for each county, with transparency
png("gitHubbary-time-trans.png", width=1625)
plot(0, 0, xlim=c(2005,2009), ylim=c(0,50), type="n", las=1, xlab="year", ylab="gitHubbary rate", bty="n")
for (i in 1:length(gitHubbary[,1])) {
	lines(2005:2009, gitHubbary[i,5:9], col="#00000006")
}
dev.off()





### Accidents map, requires 'foreign' and 'maps' packages
library(foreign)
library(maps)
years <- 2001:2010

# Combine accident data from 2001 through 2010
latitude <- c()
longitude <- c()

for (y in years) {
	
	file_loc <- paste("crashes/accident", y, ".dbf", sep="") 
	acc <- read.dbf(file_loc)
	
	if (y < 2008) {
		latitude <- c(latitude, acc$latitude)
		longitude <- c(longitude, acc$longitud)
	} else {
		latitude <- c(latitude, acc$LATITUDE)
		longitude <- c(longitude, acc$LONGITUD)
	}
	
}
accidents <- data.frame(cbind(latitude, longitude))

# Map without transparency
png("crashes-map.png", width=1200, height=800)
map("state", proj="albers", param=c(39, 45), lwd=1, col="#f0f0f0")
points(mapproject(accidents$longitude, accidents$latitude), col=NA, bg="#000000", pch=21, cex=0.30)
dev.off()

# Map with transparency
png("crashes-map-trans.png", width=1200, height=800)
map("state", proj="albers", param=c(39, 45), lwd=1, col="#f0f0f0")
points(mapproject(accidents$longitude, accidents$latitude), col=NA, bg="#00000030", pch=21, cex=0.30)
dev.off()