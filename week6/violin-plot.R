library(lattice)
library(latticeExtra)

data(Chem97, package = "mlmRev")
bwplot(factor(score) ~ gcsescore | gender, data=Chem97, xlab="Average GCSE Score")

clusterBoy <- read.csv("postCountByForumDateandPerson.csv")
clusterBoy[order(clusterBoy$PostDate),]

bwplot(Days ~ log(FSC.H), gvhd10, panel=panel.violin, box.ratio=3)

bwplot(PostDate ~ userID | threadID, clusterBoy, panel=panel.violin, box.ration=3)