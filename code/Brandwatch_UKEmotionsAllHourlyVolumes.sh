#today=$(date +'%Y-%m-%d')

today=$(date --date "1 days ago" +'%Y-%m-%d')


sh Brandwatch-DownloadVolumeHourly.sh 2001637764
mv volume-2001637764-$today.csv UK_sadness_2019-01-01_$today.csv
sleep 40

<<comment
sh Brandwatch-DownloadVolumeHourly.sh 2001333247 
mv volume-2001333247-$today.csv UK_total_2019-01-01_$today.csv
sleep 40

sh Brandwatch-DownloadVolumeHourly.sh 2001637837
mv volume-2001637837-$today.csv UK_prosocial_2019-01-01_$today.csv
sleep 40

sh Brandwatch-DownloadVolumeHourly.sh 2001637850
mv volume-2001637850-$today.csv UK_posemo_2019-01-01_$today.csv
sleep 40

#change this one for Germany
sh Brandwatch-DownloadVolumeHourly.sh 2001637729
mv volume-2001637729-$today.csv UK_anxiety_2019-01-01_$today.csv
sleep 40

sh Brandwatch-DownloadVolumeHourly.sh 2001616857
mv volume-2001616857-$today.csv UK_anger_2019-01-01_$today.csv
sleep 40

comment


