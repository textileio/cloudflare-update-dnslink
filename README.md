# cloudflare-update-dnslink

Allows you to quickly update a Cloudflare DNSLink with a new IPFS CID. This action requires that you have already created a DNS Link record in your Cloudflare DNS settings. Additionally, you will need a Cloudflare Token with sufficient permissions to edit the DNS record.

## Example

```yml
- name: Update DNSLink
  env:
    CLOUDFLARE_TOKEN: ${{ secrets.CLOUDFLARE_TOKEN }}
    RECORD_DOMAIN: "textile.io"
    RECORD_NAME: "_dnslink.subdomainname"
    CLOUDFLARE_TOKEN_ZONE_ID: ${{ secrets.CLOUDFLARE_TOKEN_ZONE_ID }}
  id: dnslink
  uses: PabiGamito/cloudflare-update-dnslink@master
  with:
    cid: ${{ steps.push.outputs.cid }}
```
