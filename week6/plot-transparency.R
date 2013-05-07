### Venn diagram
plot(0, type="n", xlim=c(20,90), ylim=c(20,90), bty="n", xlab="", xaxt="n", yaxt="n", ylab="", asp=1)
rect(0,0,100,100,col="#000000")
colors <- c("#ffff0095", "#ff000095")
symbols(c(45,65), c(55,55), circles=c(20,20), add=TRUE, bg=colors, fg=colors, inches=FALSE)


### Area plot
plot(0, type="n", xlim=c(0,100), ylim=c(0,50), bty="n", xlab="time", ylab="y", las=1)
polygon(c(60,80,100,60), c(0,20,0,0), col="#ffff0095", border=NA)
polygon(c(30,60,90,30), c(0,30,0,0), col="#0000ff95", border=NA)
polygon(c(0,30,60,0), c(0,40,0,0), col="#ff000095", border=NA)


### Plotting obesity over time
obesity <- read.csv("obesity-age-adjusted.csv")

# Box plots
png("obesity-boxplots.png", width=625)
boxplot(obesity[,4:9], las=1)
dev.off()

# Histograms
par(mfrow=c(6,1), las=1)
for (i in 4:9) {
	hist(obesity[,i], main=colnames(obesity)[i], xlim=c(10,50))
}

# Time series for each county, without transparency
png("obesity-time.png", width=625)
plot(0, 0, xlim=c(2005,2009), ylim=c(0,50), type="n", las=1, xlab="year", ylab="obesity rate", bty="n")
for (i in 1:length(obesity[,1])) {
	lines(2005:2009, obesity[i,5:9], col="#000000")
}
dev.off()

# Time series for each county, with transparency
png("obesity-time-trans.png", width=1625)
plot(0, 0, xlim=c(2005,2009), ylim=c(0,50), type="n", las=1, xlab="year", ylab="obesity rate", bty="n")
for (i in 1:length(obesity[,1])) {
	lines(2005:2009, obesity[i,5:9], col="#00000006")
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