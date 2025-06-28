resource "cloudflare_dns_record" "alias_record" {
  zone_id = var.cloudflare_zone_id
  name = "girus.iowqoeywqoeysoadyoasdyoasdyasodiyasod.uk"
  type = "A"
  comment = "Subdomain of the girus application"
  content = data.kubernetes_service_v1.ingress.status.0.load_balancer.0.ingress.0.ip
  proxied = true
  settings = {
    ipv4_only = false
    ipv6_only = false
  }
  ttl = 1
}