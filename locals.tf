locals {
  env_root_domain = toset(distinct(local.elb_routable_apps[*].env_root_domain))
  apex_domains    = toset(distinct(local.elb_routable_apps[*].apex_domain))

  # The code has been set up to automatically generate the target-groups, ALB listeners, TLS certificates, Route53 records for each element in this list
  # Whenever you want to onboard a new publically-routable project with a domain-name (THAT IS ROUTED THROUGH THE COMMON ALB), you add onto this list  
  elb_routable_apps = [for a in [
    {
      apex_domain = "small.domains"
      subdomain   = "api"

      project                  = "smalldomains"
      application              = "domain-manager"
      target_group_target_type = "ip",
      health_check_path        = "/health"
    },
    {
      apex_domain = "small.domains"
      subdomain   = ""

      project                  = "smalldomains"
      application              = "forwarder"
      target_group_target_type = "lambda",
      health_check_path        = "/actuator/health"
    },
    {
      apex_domain = "john-chung.dev"
      subdomain   = ""

      project                  = "cross-project"
      application              = "forwarder"
      target_group_target_type = "lambda",
      health_check_path        = "/actuator/health"
    }
    ] :
    {
      fqdn                     = format("%s%s%s", a.subdomain == "" ? "" : "${a.subdomain}.", var.environment == "prod" ? "" : "${var.environment}.", a.apex_domain)
      apex_domain              = a.apex_domain
      subdomain                = a.subdomain
      env_root_domain          = format("%s%s", var.environment == "prod" ? "" : "${var.environment}.", a.apex_domain)
      project                  = a.project
      application              = a.application
      target_group_target_type = a.target_group_target_type
      health_check_path        = a.health_check_path
    }
  ]

  # to be used in the AWS Provider blocks - do not use directly
  default_tags = {
    project     = "cross-project"
    managed_by  = "terraform"
    github_repo = "cross-project.routing-infrastructure"
  }
}