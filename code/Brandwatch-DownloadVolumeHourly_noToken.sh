#today=$(date +'%Y-%m-%d')

today=$(date --date "1 days ago" +'%Y-%m-%d')

#get data via Brandwatch API
curl -X GET "https://api.brandwatch.com/projects/1998303905/data/volume/queries/hours?queryId=$1&startDate=2019-01-01&endDate=$today"  -H "Authorization: Bearer InsertBearerTokenHere" > volume.json

#write column names
printf "date\tnumberOfDocuments\n" > volume-$1-$today.csv

#select fiels from json file, and transform to .tsv file with monitor Id and date as name
jq -r '.results[].values[] | [.id,.value] | @tsv' volume.json  >> volume-$1-$today.csv

rm volume.json
