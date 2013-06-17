require 'csv'

puts "Depending on your hard disk speed, it may take up to a minute or more to read in the CSV data. Please wait..."

# Defining a class to hold each tweet's information as a Ruby object
Tweet = Struct.new(:id, :created_at, :text, :from_user, :created_day, :to, :fauxto, :retweet, :via, :modifiedtweet, :linkpresence, :fauxtopresence, :hashpresence, :mentionpresence, :replytopresence, :rtpresence) do
  
  # The following methods are conveniences for checking if the given tweet has a certain property
  def has_link?
    linkpresence # contains true or false depending on the presence of this property
  end

  def has_fauxto?
    fauxtopresence
  end

  def has_hash?
    hashpresence
  end

  def has_mention?
    mentionpresence
  end

  def has_replyto?
    replytopresence
  end

  def has_rt?
    rtpresence
  end

  # Creates an edge list for a single tweet.
  # Outputs the edge list as an array.
  def output_edges
    @tweet_edges = Array.new()
    if self.has_fauxto?
      @tweet_edges << ["#{from_user}", "#{fauxto}"]
    end
    if self.has_mention? and self.to
      @tweet_edges << ["#{from_user}", "#{to}"]
    end
    if self.has_rt?
      @tweet_edges << ["#{from_user}", "#{retweet}"]
    end
    if self.via
      @tweet_edges << ["#{from_user}", "#{via}"]
    end
    return @tweet_edges
  end
end

# create an array to hold all of our tweet data
tweets = Array.new

# Read in CSV data file, and then do some stuff (in between "do" and "end")
# The |row| part sets each line in the CSV file to the "row" variable for each iteration of the loop.
# The ":headers => true" portion takes into account the header values in the first row while parsing.
CSV.foreach("londonmarked.csv", :headers => true) do |row|

  # Step 1: Data cleaning phase

  # "to" mentions
  # match twitter handles in the "to" column, filtering out the other unnecessary characters
  # if no value ("NA"), set to ruby equivalent of null
  row[5] == "NA" ? row[5] = nil : row[5] = row[5].match(/@(\w{1,15})\b/).to_a[1]

  # "fauxto" mentions
  # delete ".@" from twitter "fauxto" mentions leaving only twitter handles
  # if no value ("NA"), set to ruby equivalent of null
  row[6] == "NA" ? row[6] = nil : row[6].delete!(".@")

  # Retweets
  # match twitter handles in the "retweet" column, filtering out the other unnecessary characters
  # if no value ("NA"), set to ruby equivalent of null
  row[7] == "NA" ? row[7] = nil : row[7] = row[7].match(/@(\w{1,15})\b/).to_a[1]

  # Via mentions
  # match twitter handles in the "via" column, filtering out the other unnecessary characters
  # if no value ("NA"), set to ruby equivalent of null
  row[8] == "NA" ? row[8] = nil : row[8] = row[8].match(/@(\w{1,15})\b/).to_a[1]

  # Modified Tweet mentions
  # match twitter handles in the "modifiedtweet" column, filtering out the other unnecessary characters
  # if no value ("NA"), set to ruby equivalent of null
  row[9] == "NA" ? row[9] = nil : row[9] = row[9].match(/@(\w{1,15})\b/).to_a[1]

  # for all "TRUE"/"FALSE" values in the last 6 columns, convert them to actual boolean values
  10.upto(15) do |i|
    row[i] = row[i] == "TRUE"
  end

  # Step 2: Create array of tweet objects

  # in the argument for Tweet.new, we add "to_hash.values" to "row" because the previous 
  # ":headers => true" argument in CSV.foreach outputs each row as an array of ["header", "value"];
  # we only want the values.

  # with the splat (*) operator, each row's columns in the CSV file are split up and passed to Tweet.new()
  # this saves us from having to explicitly write out "row.to_hash.values[0]", "row.to_hash.values[1]", etc. as separate arguments.
  # more on splats: http://endofline.wordpress.com/2011/01/21/the-strange-ruby-splat/
  tweets << Tweet.new(*row.to_hash.values)
end

puts "Finished reading in #{tweets.count} tweets! Writing out data to CSV..."
# write out edges from each tweet to a CSV file
CSV.open("edgelist.csv", "wb") do |csv|
  edges_no = 0
  for tweet in tweets
    for edge in tweet.output_edges
      csv << edge
      edges_no += 1
    end
  end
  puts "Finished writing out #{edges_no} edges."
end
