locals {
  applications = [for a in [
    {
      project     = "smalldomains"
      application = "domain-manager"
    }
    ] :
    {
      fully_qualified_name = "${a.project}.${a.application}"
      project              = a.project
      application          = a.application
    }
  ]
}