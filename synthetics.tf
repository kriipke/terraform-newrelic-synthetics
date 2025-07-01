module "cluster_us_east_monitors" {
  source = "../modules/synthetics_monitor"

  account_id            = var.newrelic_account_id
  alert_policy_id       = var.synthetics_alert_policy_id
  runbook_url           = "https://docs.mycompany.com/runbooks/us-east"
  cluster_name          = "us-east-cluster"
  create_private_location = true

  services = [
    {
      name              = "gateway"
      url               = "gateway.us-east.internal"
      locations_public  = ["AWS_US_EAST_1"]
      locations_private = []
    },
    {
      name              = "user-api"
      url               = "user-api.us-east.internal"
      locations_private = ["us-east-cluster"]
    }
  ]
}