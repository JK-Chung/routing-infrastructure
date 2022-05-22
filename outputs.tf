output "nameservers_of_env_specific_domains" {
  value = {
    for n in local.route53_zone_names :
    n => aws_route53_zone.projects[n].name_servers
  }
}