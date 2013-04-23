###iconv -f iso-8859-1 -t utf-8 "officialdemocrat.csv" > "officialdemocrat.utf8.csv"
####erase all data in R
rm(list=ls(all=TRUE))

startime<-Sys.time()

###Input file structure - .csv
##created_at,text,from_user,source,rt,to


##########VERSION 5 CHANGES
#######RETWEET EXTERNAL/INTERNAL IDENTIFICATION AND OUTPUT
#######CHANGED REGEX TO ACCOUNT FOR _'S IN USERNAMES

###TODO::::: IDENTIFY IF A USERS ONLY CONTRIBUTION IS A RETWEET
####TODO::::POWER USER SYNTACTICAL FEATURES
####TODO:::CREATE EDGE LIST WITH USERS AND TWEETS
#####TODO::::TRY TO IDENTIFY SIMILAR TWEET TEXT
####TODO::::ADD TRIM QUOTE

##################################################################################
#########THIS SECTION NORMALIZES THE DATA, CREATES THE TRIM FUNCTION TO ELIMINATE @ FROM THE DATA AND CREATE THE REPLY TO MESSAGES AND RETWEET MESSAGES

library(twitteR)
library(stringr)
library(zoo)

####input file
#inputfile <- "Debate8.csv"

<<<<<<< HEAD
inputfile <- "j_tsar.csv"
=======
inputfile <- "allhungertweets.csv"
>>>>>>> test

df <- read.csv(file=inputfile)
#####convert UTF-8 just to be safe, if the script is hanging up, it might be because of this
#df$text=sapply(df$text,function(row) iconv(row,to='UTF-8'))

numberoftweets<-nrow(df)
####function to trim the @ from the columns we extract
trimat <- function (x) sub('@','',x)
###function trims out period before the .@ messages
trimperiod <- function (x) sub('\\.','',x)
####take out colon
trimcolon <- function (x) sub(':','',x)
####take out comma
trimcomma <- function (x) sub(',','',x)
trimslash <- function (x) sub('\\/', '', x)

#####ADD TRIM QUOTE FUNCTION
####

#pull out reply to messages and create a new column
df$to=trimperiod(trimcomma(trimcolon(trimat(str_extract(df$text,"^(@[[:graph:]_]*)")))))

#pull out messages that preceded by a period, this functions as a public reply to
df$fauxto=trimcomma(trimcolon(trimperiod(trimat(str_extract(df$text,"^(.@[[:graph:]_]*)")))))

#pull out retweets and create a new column
#####create trim RT to sub RT with a space and then pull out the retweeted individual
trimRT <- function (x) sub('RT ','',x)
df$retweet=trimslash(trimperiod(trimcomma(trimcolon(trimRT(trimat(str_extract(df$text,"RT (@[[:graph:]_]*)")))))))

####via is another form of retweet that we should examine
trimVIA <- function (x) sub('via ','',x)
df$via=trimperiod(trimcomma(trimcolon(trimVIA(trimat(str_extract(df$text, "via (@[[:graph:]_]*)"))))))

######MT indicates a modified tweet that is retweeted
trimMT <- function (x) sub('MT ','',x)
df$modifiedtweet=trimperiod(trimcomma(trimcolon(trimMT(trimat(str_extract(df$text,"MT (@[[:graph:]_]*)"))))))



##################################################################################
##################################################################################
##################################################################################
##################################################################################
######EXTRACTS DEVICE NAME BY EXTRACTING THE TEXT BETWEET &GT AND &LT AND PRINTS TO NEW COLUMN
####NOTE: SOMETIMES THE ACCESS STRING SHOWS UP AS "web" WITH NO WRAPPER SO THE PRINTING OF "character(0)" IN THE SOURCE FIELD INDICATES WEB
#####TRIM FUNCTIONS AT THE END ADDRESS SOME IRREGULARITIES IN THE CHARACTER STRINGS
trimLT <- function (x) sub('&lt','',x)
trimGT <- function (x) sub('&gt;','',x)
trimBlackberry <- function (x) sub('\U3e65613c','',x)
trimUber <- function (x) sub('?ber','Uber',x)
####NOTE: SOMETIMES THE ACCESS STRING SHOWS UP AS "web" WITH NO WRAPPER SO THE PRINTING OF "character(0)" IN THE SOURCE FIELD INDICATES WEB ###THE BELOW ADDRESSES THAT, BUT CANNOT ELIMINATE (0) FOR NOW THIS IS FINE BECAUSE THAT (0) MAY BE INDICATIVE OF DIFFERENT ACCESS MECHANISM
trimWEB <- function (x) sub("character.0.",'web',x)
####without this trim function at the beginning it gives a multibyte error
df$source=trimLT(df$source)
df$source=trimGT(str_extract_all(df$source,'(&gt).*?(&lt)'))
df$source=trimLT(df$source)
df$source=trimBlackberry(df$source)
df$source=trimUber(df$source)
df$source=trimWEB(df$source)
##################################################################################
######ANALYSIS OF DEVICE COUNTS TAKEN FROM THE ABOVE
devicecounts=table(df$source)
numberofdevices <- length(devicecounts)
#devicecounts=subset(devicecounts, devicecounts>1)
filename=paste("output/devicecounts", inputfile)
write.csv(devicecounts, file = filename, row.names=TRUE)
##################################################################################
##################################################################################
###PRINTS EDGELIST FOR DEVICE AFFILIATION NETWORKS
######NEED TO FIGURE OUT HOW TO GET RID OF NA's in the data
###13 is the column in the data we output
deviceedge <- df[c(3,4)]
#deviceedge = na.omit(deviceedge)
#write.csv(deviceedge, file="deviceedgelist.csv", row.names=FALSE)
colnames(deviceedge)[1]<-"source"
colnames(deviceedge)[2]<-"target"
filename=paste("output/deviceedgelist", inputfile)
write.csv(deviceedge, file = filename, row.names=FALSE)

##################################################################################

#####TEXT ANALYSIS
####returns the length of the df$text column which is the average number of characters
characterlength<-nchar(as.character(df$text))
dfcharacterlength<-as.data.frame(characterlength)
meantweetcharacterlength<-colMeans(dfcharacterlength)

##################################################################################
####identifies individuals who have used more than one device
uniquedeviceedge <- unique(deviceedge)
uniquedevicedgecounts=table(uniquedeviceedge$source)
uniquedeviceedgecountsusers=subset(uniquedevicedgecounts, uniquedevicedgecounts >2)
multipledeviceusers <- length(uniquedeviceedgecountsusers)
#write.csv(uniquedeviceedgecountsusers, file="uniquedeviceedgecountsusers.csv")
filename=paste("output/uniquedeviceedgecountsusers", inputfile)
write.csv(uniquedeviceedgecountsusers, file = filename, row.names=TRUE)
##################################################################################
####calculate percentage of users who use more than 1 device/application
t<-length(uniquedeviceedgecountsusers)
k<-length(uniquedevicedgecounts)
deviceduplicatepercentage=(t/k)
##################################################################################
##################################################################################
##################################################################################
##################################################################################
###DETECTS PRESENCE OF A LINK/HASHTAG/MENTION IN A BODY OF TEXT AND PRINTS TRUE/FALSE
df$linkpresence=str_detect(df$text, '(http................)')
linkpresence=table(df$linkpresence)
linktruecount <- sum(df$linkpresence == 'TRUE')
linkfalsecount <- sum(df$linkpresence == 'FALSE')
linkpresencepercentage <- (linktruecount/(linktruecount+linkfalsecount))
#write.csv(linkpresence, file="linkpresence.csv")

df$fauxtopresence=str_detect(df$text, "^(.@[[:graph:]_]*)")
fauxtopresence=table(df$fauxtopresence)
fauxtotruecount <- sum(df$fauxtopresence == 'TRUE')
fauxtofalsecount <- sum(df$fauxtopresence == 'FALSE')
fauxtopresencepercentage <- (fauxtotruecount/(fauxtotruecount+fauxtofalsecount))

df$hashpresence=str_detect(df$text, "(#[[:graph:]_]*)")
hashpresence=table(df$hashpresence)
hashtruecount <- sum(df$hashpresence == 'TRUE')
hashfalsecount <- sum(df$hashpresence == 'FALSE')
hashpresencepercentage <- (hashtruecount/(hashtruecount+hashfalsecount))
#write.csv(hashpresence, file="hashpresence.csv")

df$mentionpresence = str_detect(df$text, "(@[[:graph:]_]*)")
mentionpresence=table(df$mentionpresence)
mentiontruecount <- sum(df$mentionpresence == 'TRUE')
mentionfalsecount <- sum(df$mentionpresence == 'FALSE')
mentionpresencepercentage <- (mentiontruecount/(mentiontruecount+mentionfalsecount))
#write.csv(mentionpresence, file="mentionpresence.csv")

df$replytopresence = str_detect(df$text, "^(@[[:graph:]_]*)")
replytopresence=table(df$replytopresence)
replytotruecount <- sum(df$replytopresence == 'TRUE')
replytofalsecount <- sum(df$replytopresence == 'FALSE')
replytopresencepercentage <- (replytotruecount/(replytotruecount+replytofalsecount))
#write.csv(replytopresence, file="replytopresence.csv")

df$rtpresence = str_detect(df$text, "RT (@[[:graph:]_]*)")
rtpresence=table(df$rtpresence)
rttruecount <- sum(df$rtpresence == 'TRUE')
rtfalsecount <- sum(df$rtpresence == 'FALSE')
rtpresencepercentage <- (rttruecount/(rttruecount+rtfalsecount))
#write.csv(rtpresence, file="rtpresence.csv")

df$viapresence=trimVIA(trimat(str_detect(df$text, "via (@[[:graph:]_]*)")))
viapresence=table(df$viapresence)
viatruecount <- sum(df$viapresence == 'TRUE')
viafalsecount <- sum(df$viapresence == 'FALSE')
viapresencepercentage <- (viatruecount/(viatruecount+viafalsecount))
#write.csv(viapresence, file="viapresence.csv")

df$mtpresence=trimVIA(trimat(str_detect(df$text, "MT (@[[:graph:]_]*)")))
mtpresence=table(df$mtpresence)
mttruecount <- sum(df$mtpresence == 'TRUE')
mtfalsecount <- sum(df$mtpresence == 'FALSE')
mtpresencepercentage <- (mttruecount/(mttruecount+mtfalsecount))
#write.csv(mtpresence, file="mtpresence.csv")

####DETECTS THE NUMBER OF LINKS/HASHTAG/MENTION IN EACH OF THE COLUMNS AND PRINTS THE NUMBER
df$linknumber=str_count(df$text, '(http................)')
linknumber=table(df$linknumber)
#write.csv(linknumber, file="linknumber.csv")
filename=paste("output/linknumber", inputfile)
write.csv(linknumber, file = filename, row.names=TRUE)

df$hashnumber=str_count(df$text, "(#[[:graph:]_]*)")
hashnumber=table(df$hashnumber)
#write.csv(hashnumber, file="hashnumber.csv")
filename=paste("output/hashnumber", inputfile)
write.csv(hashnumber, file = filename, row.names=TRUE)

df$mentionnumber = str_count(df$text, "(@[[:graph:]_]*)")
mentionnumber=table(df$mentionnumber)
#write.csv(mentionnumber, file="mentionednumber.csv")
filename=paste("output/mentionnumber", inputfile)
write.csv(mentionnumber, file = filename, row.names=TRUE)

##################################################################################
##################################################################################
######IDENTIFY FREQUENT TWEETS, THIS IS LIKELY TO MOSTLY BE RETWEETS, BUT CAN BE ANY TWEET, IT IS ALSO LIKELY TO PULL OUT TWEETS THAT JUST CONTAIN ONE COMMON HASHTAG, ONE DOWNSIDE IS THAT IF ONE CHARACTER IS OFF THEN IT WILL NOT WORK CORRECTLY
tweetcounts=table(df$text)
uniquetweets<-length(tweetcounts)
tweetcounts=subset(tweetcounts, tweetcounts>2)
#write.csv(tweetcounts, file="tweetcounts.csv")
filename=paste("output/tweetcounts", inputfile)
write.csv(tweetcounts, file = filename, row.names=TRUE)
##################################################################################
##################################################################################
#######IDENTIFY THOSE WHO HAVE BEEN RETWEETED THE MOST (more than 5 times in below example)
retweetcounts=table(df$retweet)
numberofpeopleretweeted <- length(retweetcounts)
retweetcounts=subset(retweetcounts, retweetcounts>5)
#write.csv(retweetcounts, file="retweetcounts.csv")
filename=paste("output/retweetcounts", inputfile)
write.csv(retweetcounts, file = filename, row.names=TRUE)
##################################################################################
##################################################################################
#######IDENTIFY THOSE WHO HAVE TWEETED THE MOST  (more than 5 times in below example)
tweetscreenamecounts=df$from_user
tweetscreenamecounts=tolower(tweetscreenamecounts)
tweetscreenamecounts=table(tweetscreenamecounts)
totalusers=tolower(df$from_user)
totalusers=unique(totalusers)
###calculate number of single posters
singleton<-subset(tweetscreenamecounts, tweetscreenamecounts<2)
numberofsingleposters<-length(singleton)
numberofuniquetweeters <- length(totalusers)
####CALCULATE PERCENTAGE OF SINGLETON POSTERS
singletonpercentage<-numberofsingleposters/numberofuniquetweeters
#tweetscreenamecounts=subset(tweetscreenamecounts, tweetscreenamecounts>0)
#write.csv(tweetscreenamecounts, file="tweetscreennamecounts.csv")
filename=paste("output/tweetscreenamecounts", inputfile)
write.csv(tweetscreenamecounts, file = filename, row.names=FALSE)
#################
##################################################################################
##################################################################################
########EXTRACTS HASHTAGS, THEN TRIMS THE # OUT, MAKES THEM ALL LOWERCASE AND THEN OUTPUTS A FREQUENCY COUNT OF THE OCCURRENCES OF THE HASHTAGS
hash = str_extract_all(df$text, "(#[[:graph:]_]*)")
hashunlist <- unlist(hash)
trimhash <- function (x) sub('#','',x)
hashunlist <- trimhash(hashunlist)
lowerhash <- tolower(hashunlist)
hashcounts=table(lowerhash)
numberofuniquehashtags<-length(hashcounts)
#write.csv(hashcounts, file="hashlistcounts.csv", row.names=FALSE)
hashcounts<-sort(table(lowerhash), decreasing=TRUE)
filename=paste("output/hashcounts", inputfile)
write.csv(hashcounts, file = filename, row.names=TRUE)
##################################################################################
##################################################################################
########EXTRACTS MENTIONS, THEN TRIMS THE @ OUT, AND THEN OUTPUTS A FREQUENCY COUNT OF THE OCCURRENCES OF THE HASHTAGS ###NO NEED TO MAKE THEM LOWERCASE BECAUSE THEY ARE USERNAMES
mention = str_extract_all(df$text, "(@[[:graph:]_]*)")
mentionunlist <- unlist(mention)
mentionunlist <- trimat(mentionunlist)
mentionunlist <- trimcolon(mentionunlist)
mentionunlist <- trimperiod(mentionunlist)
mentionunlist <- trimcomma(mentionunlist)
lowermention <- tolower(mentionunlist)
mentioncounts<-as.data.frame(table(lowermention))
colnames(mentioncounts)[1]<-"mention"
colnames(mentioncounts)[2]<-"frequency"
numberofuniquementions<-length(mentioncounts)
#mentioncounts<-sort(mentioncounts, decreasing=TRUE)
filename=paste("output/mentioncounts", inputfile)
write.csv(mentioncounts, file = filename, row.names=FALSE)
##################################################################################
##################################################################################
###PRINTS EDGELIST FOR REPLYTO STRUCTURE, the 3 and 6 are the column placements for the screename and to results
######NEED TO FIGURE OUT HOW TO GET RID OF NA's in the data
####12 is the column in the data we output
replytoedge <- df[c(3,6)]
replytoedge = na.omit(replytoedge)
colnames(replytoedge)[1]<-"source"
colnames(replytoedge)[2]<-"target"
#write.csv(replytoedge, file="replytoedgelist.csv", row.names=FALSE)
filename=paste("output/replytoedge", inputfile)
write.csv(replytoedge, file = filename, row.names=FALSE)

##################################################################################
##################################################################################
###PRINTS EDGELIST FOR RETWEET STRUCTURE, the 3 and 7 are the column placements for the screename and to results
###13 is the column in the data we output
retweetedge <- df[c(3,8)]
retweetedge = na.omit(retweetedge)
colnames(retweetedge)[1]<-"source"
colnames(retweetedge)[2]<-"target"
retweetedgetarget<-tolower(retweetedge$target)
#write.csv(retweetedge, file="retweetedgelist.csv", row.names=FALSE)
filename=paste("output/retweetedge", inputfile)
write.csv(retweetedge, file = filename, row.names=FALSE)
##################################################################################
######RANK THE MOST RETWEETED INDIVIDUALS
mostretweeted<-table(retweetedge$target)
highestretweeters<-table(retweetedge$target)
##################################################################################
#####PULLS OUT LINKS FROM TWEET TEXT
###THE URL REGEX PULLS OUT ANYTHING FOLLOWING AN HTTP UNTIL THE NEXT WHITESPACE SO IT IS POSSIBLE THAT PEOPLE THAT DO NOT PUT A A SPACE AFTER LINK WOULD GET EXTRA CHARACTERS IN, THAT IS WHY THE STR.MATCH IS LEFT AS HTTP........
####EXTRACTS ALL OF THE URLS, UNLISTS THEM, COUNTS THEM AND THEN CREATES A TABLE OF THOSE THAT APPEAR MORE THAN FIVE TIMES
df$link=str_extract_all(df$text, '(http://[[:graph:]\\s]*)')
linkunlist <- unlist(df$link)
linkcounts=table(linkunlist)
numberofuniquelinks<-length(linkcounts)
linkcounts<-as.data.frame(linkcounts)
colnames(linkcounts)[1]<-"link"
colnames(linkcounts)[2]<-"frequency"
filename=paste("output/linkcounts", inputfile)
write.csv(linkcounts, file = "linkcounts.csv", row.names=FALSE)
##################################################################################
##################################################################################
##################################################################################
##################################################################################
########

#####CREATE A SUMMARY TABLE OF THE ABOVE PERCENTAGES AND WRITE TO FILE
syntacticfeatureoverview <- table(inputfile, numberoftweets, linkpresencepercentage, hashpresencepercentage, mentionpresencepercentage, replytopresencepercentage, rtpresencepercentage, viapresencepercentage, mtpresencepercentage, deviceduplicatepercentage, numberofdevices, multipledeviceusers, numberofpeopleretweeted, numberofuniquetweeters, numberofuniquehashtags, numberofuniquementions, numberofuniquelinks, uniquetweets, numberofsingleposters, singletonpercentage, fauxtopresencepercentage, meantweetcharacterlength)

filename=paste("output/syntacticfeatureoverview", inputfile)
write.csv(syntacticfeatureoverview, file = filename, row.names=TRUE)
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################

timeseriestable <- as.data.frame(table(df$created_at))
colnames(timeseriestable)[1]<-"time"
colnames(timeseriestable)[2]<-"tweets"
filename=paste("output/timeseries", inputfile)
write.csv(timeseriestable, file = filename, row.names=FALSE)

######
#window(ts, start=as.Date('2011-11-19'), end=as.Date('2011-11-22'))
###write to pdf file
filename=paste("TimeSeries", inputfile,".pdf")
pdf(file=filename)
# Plot your graph  
plot(timeseriestable)
# Write the file  
dev.off()
############################################
##################################################################################





##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################
##################################################################################

endtime<-Sys.time()
runtime=endtime-startime
runtimemessage<-paste("This took", runtime)
print(runtimemessage)