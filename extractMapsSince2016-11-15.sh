#!/bin/bash
# Read the ids for each row in the Postgresql table ssm.maps with created_at > 
# 2016-11-15 into an array. Then loop through that array to write a .json file
# for each map.

ext=".json"
uscore="_"
ids=($(psql -U ssm -h localhost -d ssm -t -c "select id from ssm.maps where \
    created_at > '2016-11-15';"))
nIds=${#ids[@]}
IFS=$'@'

for ((i=0; i<$nIds; i++)); do
  id="${ids[$i]}"
  created=($(psql -U ssm -h localhost -d ssm -t -c "select created_at from \
    ssm.maps, ssm.users where maps.owner = users.id and maps.id = $id;"))
  em=($(psql -U ssm -h localhost -d ssm -t -c "select email from ssm.maps,     \
    ssm.users where maps.owner = users.id and maps.id = $id;"))
  state=($(psql -U ssm -h localhost -d ssm -t -c "select state from ssm.maps,  \
    ssm.users where maps.owner = users.id and maps.id = $id;"))
  affils=($(psql -U ssm -h localhost -d ssm -t -c "select affil_self_advocate, \
    affil_family_member, affil_health_provider, affil_education_provider,      \
    affil_smcha_staff, affil_local_org_staff from ssm.maps, ssm.users where    \
    maps.owner = users.id and maps.id = $id;"))
  affilsclean="$(echo -e "${affils}" | tr -d '|')"
  fname="$state$uscore$affilsclean$uscore$em$uscore$id$ext"
  fncleaner="${fname//// }" # Replace forward slashes with spaces
  fnclean="$(echo -e "${fncleaner}" | tr -d '[[:space:]]')" # rm all whitespace
  echo "$i: $id; $fnclean; $created"
  psql -U ssm -h localhost -d ssm -t -o "$fnclean" -c "select document from    \
      ssm.maps where id='$id'"
done

unset IFS

