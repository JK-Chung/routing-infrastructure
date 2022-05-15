locals {
  # The code has been set up to automatically generate the target-groups, ALB listeners, TLS certificates, Route53 records for each element in this list
  # Whenever you want to onboard a new publically-routable project with a domain-name, you add onto this list  
  routable_applications = [for a in [
    {
      prod_domain_name         = "api.small.domains"
      project                  = "smalldomains"
      application              = "domain-manager"
      target_group_target_type = "ip"
    }
    ] :
    {
      domain_name              = format("%s%s", var.environment == "prod" ? "" : "${var.environment}.", a.prod_domain_name)
      project                  = a.project
      application              = a.application
      target_group_target_type = a.target_group_target_type
    }
  ]

  # there's a bunch of nesting involved for tls validation. so ive created this variable to dynamically flatten this nesting
  # this allows for a terraform resource to be created for each element in this flattened list
  all_dns_records_for_tls_validation = flatten(
    [ for domain_name, acm in aws_acm_certificate.routable_applications : acm.domain_validation_options ]
  )
}