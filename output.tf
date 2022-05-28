output "project-nameservers" {
  description = "Declares the nameservers for each project's environment root domains"
  value = { for d in local.env_root_domain : d => aws_route53_zone.projects[d].name_servers }
}