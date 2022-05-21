locals {
  route53_zone_names = [for z in distinct(local.elb_routable_apps[*].route53_zone_name) : z]

  # The code has been set up to automatically generate the target-groups, ALB listeners, TLS certificates, Route53 records for each element in this list
  # Whenever you want to onboard a new publically-routable project with a domain-name (THAT IS ROUTED THROUGH THE COMMON ALB), you add onto this list  
  elb_routable_apps = [for a in [
    {
      apex_domain = "small.domains"
      subdomain   = "api"

      project                  = "smalldomains"
      application              = "domain-manager"
      target_group_target_type = "ip"
    }
    ] :
    {
      fqdn                     = format("%s%s%s", "${a.subdomain}.", var.environment == "prod" ? "" : "${var.environment}.", a.apex_domain)
      subdomain                = a.subdomain
      route53_zone_name        = format("%s%s", var.environment == "prod" ? "" : "${var.environment}.", a.apex_domain)
      project                  = a.project
      application              = a.application
      target_group_target_type = a.target_group_target_type #TODO remove
    }
  ]

}