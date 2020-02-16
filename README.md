# cloudflare-update-dnslink

```
- name: Update DNSLink
  env:
    CLOUDFLARE_TOKEN: ${{ secrets.CLOUDFLARE_TOKEN }}
    RECORD_DOMAIN: 'textile.io'
    RECORD_NAME: '_dnslink.subdomainname'
    CLOUDFLARE_TOKEN_ZONE_ID: ${{ secrets.CLOUDFLARE_TOKEN_ZONE_ID }}
  id: dnslink
  uses: textileio/cloudflare-update-dnslink@master
```
