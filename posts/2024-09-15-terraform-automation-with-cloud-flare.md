---
title: Automating cloudflare with terraform
---

### Under construction

```terraform
data "cloudflare_zone" "zone" {
  name = "lillthors.dev"
}

resource "cloudflare_record" "personal_website" {
  zone_id = data.cloudflare_zone.zone.id
  type    = "CNAME"
  name    = "blog"
  content = "christopherl91.github.io"
  ttl     = 3600
  comment = "Managed by opentofu"
}
```
