locals {
  routable_applications = [for a in [
    {
      prod_domain_name         = "api.small.domains"
      project                  = "smalldomains"
      application              = "domain-manager"
      target_group_target_type = "ip"
    }
    ] :
    {
      domain_name              = format("%s%s", var.environment == "dev" ? "dev." : "", a.prod_domain_name)
      project                  = a.project
      application              = a.application
      target_group_target_type = a.target_group_target_type
    }
  ]
}