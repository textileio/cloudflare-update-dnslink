#!/bin/bash
set -e # abort on any error

response=$(curl \
        -H "Authorization: Bearer $CLOUDFLARE_TOKEN" \
        -H "Content-Type: application/json" \
        -s "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records?name=$RECORD_NAME.$RECORD_DOMAIN")

success=$(jq -r  '.success' <<< "${response}" )

if [ $success != "true" ]; then
  echo "Pages Update: Failed to update record!"
  errors=$(jq -r  '.errors' <<< "${response}" )
  echo "Errors: $errors"
  exit 1
fi

totalCount=$(jq -r  '.result_info.total_count' <<< "${response}" ) 
if [ $totalCount == "0" ]; then
  echo "Pages Update: No record found. Follow Cloudflare setup instructions to add an initial IPFS record for '$RECORD_NAME'"
  exit 1
fi

echo "Pages Update: DNS Record Found!"

recordIds=$(jq -r  '.result[].id' <<< "${response}" )
for recordId in "${recordIds[@]}"
do
  putResponse=$(curl \
          -H "Authorization: Bearer $CLOUDFLARE_TOKEN" \
          -H "Content-Type: application/json" \
          -X PUT \
          --data "{\"type\":\"TXT\",\"name\":\"$RECORD_NAME.$RECORD_DOMAIN\",\"content\":\"dnslink=/ipfs/$1\"}" \
          -s "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$recordId")
  
  success=$(jq -r  '.success' <<< "${putResponse}" )
  if [ $success != "true" ]; then
    echo "Pages Update: Failed to update record!"
    errors=$(jq -r  '.errors' <<< "${putResponse}" )
    echo "Errors: $errors"
    exit 1
  fi

  echo "Pages Update: Success"
  echo "  Webpage $RECORD_NAME updated to $1."
  echo "  Update time will vary depending on your Cloudflare settings."
done
