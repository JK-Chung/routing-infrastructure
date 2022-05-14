locals {
  applications = [for a in [
    {
      project                  = "smalldomains"
      application              = "domain-manager"
      target_group_target_type = "ip"
    }
    ] :
    {
      fully_qualified_name     = "${a.project}.${a.application}"
      project                  = a.project
      application              = a.application
      target_group_target_type = a.target_group_target_type
    }
  ]
}