#!/bin/bash
# Read the ids for each row in the Postgresql table ssm.maps into an array.
# Then loop through that array to write a .json file for each map.

ext=".json"
uscore="_"
idArray=($(psql -U ssm -h localhost -d ssm -t -c "select id from ssm.maps;"))
nIds=${#idArray[@]}
IFS=$'@'

for ((i=0; i<$nIds; i++)); do
  id="${idArray[$i]}"
  em=($(psql -U ssm -h localhost -d ssm -t -c "select email from ssm.maps,     \
    ssm.users where maps.owner = users.id and maps.id = $id;"))
  state=($(psql -U ssm -h localhost -d ssm -t -c "select state from ssm.maps,  \
    ssm.users where maps.owner = users.id and maps.id = $id;"))
  sa=($(psql -U ssm -h localhost -d ssm -t -c "select affil_self_advocate from \
    ssm.maps, ssm.users where maps.owner = users.id and maps.id = $id;"))
  fm=($(psql -U ssm -h localhost -d ssm -t -c "select affil_family_member from \
    ssm.maps, ssm.users where maps.owner = users.id and maps.id = $id;"))
  hp=($(psql -U ssm -h localhost -d ssm -t -c "select affil_health_provider    \
    from ssm.maps, ssm.users where maps.owner = users.id and maps.id = $id;"))
  ep=($(psql -U ssm -h localhost -d ssm -t -c "select affil_education_provider \
    from ssm.maps, ssm.users where maps.owner = users.id and maps.id = $id;"))
  ss=($(psql -U ssm -h localhost -d ssm -t -c "select affil_smcha_staff from   \
    ssm.maps, ssm.users where maps.owner = users.id and maps.id = $id;"))
  los=($(psql -U ssm -h localhost -d ssm -t -c "select affil_local_org_staff   \
    from ssm.maps, ssm.users where maps.owner = users.id and maps.id = $id;"))
  fname="$state$uscore$sa$fm$hp$ep$ss$los$uscore$em$uscore$id$ext"
  fnclean="$(echo -e "${fname}" | tr -d '[[:space:]]')" # Remove all whitespace
  echo "$i: $id; $fnclean"
  psql -U ssm -h localhost -d ssm -t -o "$fnclean" -c "select document from \
      ssm.maps where id='$id'"
done

unset IFS

