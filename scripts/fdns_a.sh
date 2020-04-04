# fetch the fdns_a file
wget --quiet -O fdns_a.gz https://opendata.rapid7.com/sonar.fdns_v2/2020-03-27-1585290172-fdns_a.json.gz

# extract and format our data
gunzip --quiet -c fdns_a.gz | jq -r '.value + ","+ .name' | tr '[:upper:]' '[:lower:]' | rev > fdns_a.rev.lowercase.txt

# split the data into chunks ot sort
split -b100M fdns_a.rev.lowercase.txt fileChunk

# remove the old files
rm fdns_a.gz
rm fdns_a.rev.lowercase.txt

## Sort each of the pieces and delete the unsorted one
for f in fileChunk*; do LC_COLLATE=C sort "$f" > "$f".sorted && rm "$f"; done

## merge the sorted files with local tmp directory
mkdir -p sorttmp
LC_COLLATE=C sort -T sorttmp/ -muo fdns_a.sort.txt fileChunk*.sorted

# clean up
rm fileChunk*
