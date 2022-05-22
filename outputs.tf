resource "aws_route53_zone" "projects" {
  for_each = local.route53_zone_names
  name     = each.value
}

output "nameservers_of_env_specific_domains" {
  for_each = local.route53_zone_names
  value = {
    for z in aws_route53_zone.projects :
    each.value => aws_route53_zone.projects[each.value].name_servers
  }
}