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
      domain_name              = format("%s%s", var.environment == "prod" ? "" : "${var.environment}.", a.prod_domain_name)
      project                  = a.project
      application              = a.application
      target_group_target_type = a.target_group_target_type
    }
  ]

  # there's a bunch of nesting involved for tls validation. so ive created this variable to dynamically flatten this nesting
  # this allows for a terraform resource to be created for each element in this flattened list
  all_dns_records_for_tls_validation = {
    for a in local.routable_applications : a.domain_name => [
      for dvo in aws_acm_certificate.routable_applications[a.domain_name].domain_validation_options : {
        domain_name = a.domain_name
        name        = dvo.resource_record_name
        record      = dvo.resource_record_value
        type        = dvo.resource_record_type
      }
    ]
  }
}