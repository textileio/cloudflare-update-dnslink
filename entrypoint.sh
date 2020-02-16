#!/bin/bash
set -e # abort on any error

# Curl the Cloudlfare endpoint for the zone Ids of the provided domains
response=$(curl -H "X-Auth-Key: $CLOUDFLARE_TOKEN" \
        -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
        -H "Content-Type: application/json" \
        -s "https://api.cloudflare.com/client/v4/zones?name=$RECORD_DOMAIN")

# Parse the json response to create an array if Ids: {df738f0220Xcda8842bdff65be572c24}
zoneIds=$(jq -r  '.result[].id' <<< "${response}" ) 

echo "Pages Update: ZoneId Found"

for zoneId in "${zoneIds[@]}"
do
    # Get the DNS record for the IPFS page
    response=$(curl -H "X-Auth-Key: $CLOUDFLARE_TOKEN" \
            -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
            -H "Content-Type: application/json" \
            -s "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records?name=$RECORD_NAME")

    recordIds=$(jq -r  '.result[].id' <<< "${response}" ) 

    if [ ${#recordIds[@]} -eq 0 ]; then
        echo "Pages Update: No record found. Follow Cloudflare setup instructions to add an initial IPFS record for $RECORD_NAME"
    else
        echo "Pages Update: DNS Record Found"
        for recordId in "${recordIds[@]}"
        do
       
            putResponse=$(curl -H "X-Auth-Key: $CLOUDFLARE_TOKEN" \
                    -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
                    -H "Content-Type: application/json" \
                    -X PUT \
                    --data "{\"type\":\"TXT\",\"name\":\"$RECORD_NAME\",\"content\":\"dnslink=/ipfs/$1\"}" \
                    -s "https://api.cloudflare.com/client/v4/zones/$zoneId/dns_records/$recordId")

            echo "Pages Update: Success"
            echo "  Webpage $RECORD_NAME updated to $1."
            echo "  Update time will vary depending on your Cloudflare settings."
            echo "  View latest page at https://cloudflare-ipfs.com/ipns/$RECORD_NAME."
        done
    fi

done