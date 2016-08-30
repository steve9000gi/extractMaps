#!/bin/bash
# Read the ids for each row in the Postgresql table ssm.maps into an array.
# Then loop through that array to write a .json file for each map.

ext=".json"
idArray=($(psql -U ssm -h localhost -d ssm -t -c "select id from ssm.maps;"))
nIds=${#idArray[@]}
IFS=$'@'

for ((i=0; i<$nIds; i++)); do
  id="${idArray[$i]}"
  em=($(psql -U ssm -h localhost -d ssm -t -c "select email from ssm.maps, \
        ssm.users where maps.owner = users.id and maps.id = $id;"))
  fname="$em-$id$ext"
  echo "id $i: $id; fname: $fname"
  psql -U ssm -h localhost -d ssm -t -o "$fname" -c "select document from \
      ssm.maps where id='$id'"
done

unset IFS
