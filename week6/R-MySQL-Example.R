library(RMySQL)
library(lattice)

con<-dbConnect(MySQL(), user="root", password="gallagher4000", 
	dbname="getmathy", host="sociotechnical.ischool.drexel.edu")

mystuff <- dbGetQuery(con, "
					SELECT
					      yearweek(from_unixtime(conv(a.creationDate,10,10)/1000)) as PostDate,
					      b.forumID,
					          count(*) as counter
					FROM
					    jiveMessage a,
					    jiveThread b
					WHERE
					    a.threadID = b.threadID and
					a.userID IN (
					55001     , 556363     ,515830     ,525403     ,370248     ,292562     ,427451     ,127890     ,
					240440     ,197314     ,525644     ,65301     ,147784     ,498972     ,46613     ,160049     ,
					526668     ,291300     ,526368     ,272340     ,54701     ,566894     ,167289     ,160067     ,
					55029     ,370227     ,563785     ,163872     ,165765     ,442871     ,449895     ,516522     ,
					564858     ,557331     ,218737     ,567735     ,225845     ,567391     ,556398     ,474927     ,
					164837     ,559940     ,161894     ,564762     ,379568     ,567531     ,567601     ,169723     ,
					567706     ,568428     ,568788     ,95900     ,401069     ,572975     ,575608     ,573597)
					group by
					     PostDate,a.forumID
					 ORDER BY
					    PostDate"
		 )



bwplot(factor(forumID) ~ PostDate, 
	mystuff, panel=panel.violin, box.ration=3,
	ylab="forum ID", xlab="Year + Week", main="distribution of forum \n participation over time \n by participants in thread 1884113")
