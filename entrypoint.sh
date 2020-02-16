#!/bin/bash
set -e # abort on any error

response=$(curl \
        -H "Authorization: Bearer $CLOUDFLARE_TOKEN" \
        -H "Content-Type: application/json" \
        -s "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records?name=$RECORD_NAME.$RECORD_DOMAIN")

recordIds=$(jq -r  '.result[].id' <<< "${response}" ) 

if [ ${#recordIds[@]} -eq 0 ]; then
    echo "Pages Update: No record found. Follow Cloudflare setup instructions to add an initial IPFS record for $RECORD_NAME"
else
  echo "Pages Update: DNS Record Found"
  for recordId in "${recordIds[@]}"
  do
  
      putResponse=$(curl \
              -H "Authorization: Bearer $CLOUDFLARE_TOKEN" \
              -H "Content-Type: application/json" \
              -X PUT \
              --data "{\"type\":\"TXT\",\"name\":\"$RECORD_NAME.$RECORD_DOMAIN\",\"content\":\"dnslink=/ipfs/$1\"}" \
              -s "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$recordId")

      echo "Pages Update: Success"
      echo "  Webpage $RECORD_NAME updated to $1."
      echo "  Update time will vary depending on your Cloudflare settings."
      echo "  View latest page at https://cloudflare-ipfs.com/ipns/$RECORD_NAME."
  done
fi