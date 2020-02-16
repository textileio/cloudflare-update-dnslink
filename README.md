# cloudflare-update-dnslink

```
- name: Update DNSLink
  env:
    CLOUDFLARE_TOKEN: ${{ secrets.CLOUDFLARE_TOKEN }}
    CLOUDFLARE_EMAIL: ${{ secrets.CLOUDFLARE_EMAIL }}
    RECORD_DOMAIN: 'textile.io'
    RECORD_NAME: '_dnslink.subdomainname'
  id: dnslink
  uses: textileio/cloudflare-update-dnslink@master
```
