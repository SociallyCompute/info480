## Always a good practice to release old data from memory
rm(list=ls(all=TRUE))

### stringr is a string processing package for R
if(is.installed("stringr")==FALSE) 
  install.packages("stringr",repos="http://cran.us.r-project.org")
else
  print("library installed.  yay!")
# Load the libraries you need
library(stringr)


####This file assigns the name of your file which is in quotes to inputfile
####I use this syntax in case I want to read in a lot of files at one

#inputfile <- "londonweek2.csv"
inputfile <- "londonsample.csv"

####The following piece of code reads the file which was identified above into a dataframe
####In R, dataframes are one of the foundational data structures that are similar to a ####spreadsheet

df <- read.csv(file=inputfile)


###examine the dataframe that is read in
head(df)

###assign the number of rows in df to the numberoftweets variable. 
numberoftweets<-nrow(df)

########################################################
########################################################
########################################################
########################################################
####create a new field for aggregate analysis by day
###the following line strips away the hour:minutes:second of created_at
df$created_day<-as.Date(df$created_at, format="%m/%d/%Y")
########################################################
########################################################
########################################################
########################################################
########################################################
####create a table of tweets by day for basic longitudinal analysis
timeseries<-table(df$created_day)

#####Basic plot of the frequencies of tweets on a daily basis
#plot(timeseries)

###typing in number of tweets will display the number of tweets
numberoftweets

###make text lowercase
df$text<-tolower(df$text)
###make all usernames lowercase
df$from_user<-tolower(df$from_user)

####Using str_extract function (part of the stringr library), pull out any username that is ####at the beginning of a tweet
df$to= str_extract(df$text,"^(@[[:graph:]_]*)")

#### Using str_extract function (part of the stringr library), pull out any username that is ####at the beginning of a tweet, preceded by a period (more on this in another post)
df$fauxto= str_extract(df$text,"^(.@[[:graph:]_]*)")

#### Using str_extract function (part of the stringr library), pull out any username that is 
####preceded by a rt which would signify a retweet
df$retweet=str_extract(df$text,"rt (@[[:graph:]_]*)")
#### Using str_extract function (part of the stringr library), pull out any username that is 
####preceded by a via which would signify another form of a retweet
df$via= str_extract(df$text, "via (@[[:graph:]_]*)")

#### Using str_extract function (part of the stringr library), pull out any username that is 
####preceded by a mt which would signify a modified tweet
df$modifiedtweet=str_extract(df$text,"mt (@[[:graph:]_]*)")

####This identifies the presence of a link and assigns that value by row to linkpresence
df$linkpresence=str_detect(df$text, '(http://[[:graph:]\\s]*)')

#### This identifies the presence of a fauxto (more later) and assigns that value by row to ####fauxtopresence

df$fauxtopresence=str_detect(df$text, "^(.@[[:graph:]_]*)")

####This identifies the presence of a hashtag and assigns that value by row to ####hashpresence
df$hashpresence=str_detect(df$text, "(#[[:graph:]_]*)")

####This identifies the presence of an @-mention and assigns that value by row to #####mention presence
df$mentionpresence = str_detect(df$text, "(@[[:graph:]_]*)")

#########This identifies the presence of an at-reply and assigns that value by row to #####replytopresence
df$replytopresence = str_detect(df$text, "^(@[[:graph:]_]*)")

####This identifies the presence of a retweet and assigns that value by row to rtpresence

df$rtpresence = str_detect(df$text, "rt (@[[:graph:]_]*)")


####create variable filename
filename=paste(inputfile, "MARKEDUP.csv")
####write file to a csv
write.csv(df, file=filename)


#####make a table of the str_detect from the previous
linkpresence=table(df$linkpresence)
####sum the number of true
linktruecount <- sum(df$linkpresence == 'TRUE')
####sume the number of false
linkfalsecount <- sum(df$linkpresence == 'FALSE')
####identify the percentage of links in the dataset
linkpresencepercentage <- (linktruecount/(linktruecount+linkfalsecount))
#write.csv(linkpresence, file="linkpresence.csv")

####rinse and repeat
fauxtopresence=table(df$fauxtopresence)
fauxtotruecount <- sum(df$fauxtopresence == 'TRUE')
fauxtofalsecount <- sum(df$fauxtopresence == 'FALSE')
fauxtopresencepercentage <- (fauxtotruecount/(fauxtotruecount+fauxtofalsecount))

hashpresence=table(df$hashpresence)
hashtruecount <- sum(df$hashpresence == 'TRUE')
hashfalsecount <- sum(df$hashpresence == 'FALSE')
hashpresencepercentage <- (hashtruecount/(hashtruecount+hashfalsecount))
write.csv(hashpresence, file="hashpresence.csv")

mentionpresence=table(df$mentionpresence)
mentiontruecount <- sum(df$mentionpresence == 'TRUE')
mentionfalsecount <- sum(df$mentionpresence == 'FALSE')
mentionpresencepercentage <- (mentiontruecount/(mentiontruecount+mentionfalsecount))
write.csv(mentionpresence, file="mentionpresence.csv")

replytopresence=table(df$replytopresence)
replytotruecount <- sum(df$replytopresence == 'TRUE')
replytofalsecount <- sum(df$replytopresence == 'FALSE')
replytopresencepercentage <- (replytotruecount/(replytotruecount+replytofalsecount))
write.csv(replytopresence, file="replytopresence.csv")

rtpresence=table(df$rtpresence)
rttruecount <- sum(df$rtpresence == 'TRUE')
rtfalsecount <- sum(df$rtpresence == 'FALSE')
rtpresencepercentage <- (rttruecount/(rttruecount+rtfalsecount))
write.csv(rtpresence, file="rtpresence.csv")

####create a table of the syntactical feature distribution we just examined
syntacticfeatureoverview <- table(inputfile, numberoftweets, linkpresencepercentage, hashpresencepercentage, mentionpresencepercentage, replytopresencepercentage, rtpresencepercentage)

filename=paste("syntacticfeatureoverview", inputfile)
write.csv(syntacticfeatureoverview, file = filename, row.names=TRUE)

###trim the @ sign from the columms where we pulled them out for easy analysis
trimat <- function (x) sub('@','',x)
df$to<-trimat(df$to)
df$retweet<-trimat(df$retweet)
df$fauxto<-trimat(df$fauxto)
df$via<-trimat(df$via)
df$modifiedtweet<-trimat(df$modifiedtweet)

###trim the rt from the retweet column
trimRT <- function (x) sub('rt ','',x)
df$retweet<-trimRT(df$retweet)

###trim the colon from the retweet column 
trimcolon <- function (x) sub(':','',x)
df$retweet<-trimcolon(df$retweet)

###trim the period from the fauxto
trimperiod <- function (x) sub('\\.','',x)
df$fauxto<-trimperiod(df$fauxto)

###trim the via from the via column
trimVIA <- function (x) sub('via ','',x)
df$via<-trimVIA(df$via)

###trim the mt from the modifiedtweet column
trimMT <- function (x) sub('MT ','',x)
df$modifiedtweet<-trimMT(df$modifiedtweet)

###create a table of people that were retweeted
retweettable<-table(df$retweet)
####identify those that have been retweeted more than 500 times
highretweet<-subset(retweettable, retweettable>500)

write.csv(highretweet, file="highretweet.csv")
