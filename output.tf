output "project-nameservers" {
  for_each    = local.env_root_domain
  description = "Declares the nameservers for each project's environment root domains"

  value = { for d in each.value : d => aws_route53_zone.projects[d].name_servers }
}