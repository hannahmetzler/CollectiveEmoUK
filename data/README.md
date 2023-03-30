Each data file has one line for every hour of the day, with the date in the first column, and hour indicated as T00 to T23. The volume of tweets containing one of the LIWC words is in the 2nd column. The file labeled "total" has the total tweet volume for the UK. All other dictionary specific volumes have to be normalized by this total volume of tweets. 

Other specifications:

- No LIWC terms were excluded. See more in the file Brandwatch_queries/query_settings.txt

Inclusion terms for tweets: Only tweets 
- from users in the UK
- from users with more than 100 followers (to exclude bots)
- from users with less than 100.000 followers to exclude large media etc
- in English
- no retweets, because we focus on emotion expression, not resharing of somebody else's emotional expressions
