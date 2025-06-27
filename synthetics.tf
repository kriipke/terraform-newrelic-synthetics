module "cluster1_monitors" {
  source = "modules/synthetics_monitor"

  account_id            = var.account_id
  alert_policy_id       = var.alert_policy_id
  runbook_url           = "https://runbooks.internal/cluster1"
  cluster_name          = "us-east-cluster"
  create_private_location = true
  services = [
    { name = "auth-service", url = "auth.us-east.internal" },
    { name = "api-gateway",  url = "gateway.us-east.internal" },
  ]
}

module "cluster2_monitors" {
  source = "modules/synthetics_monitor"

  account_id            = var.account_id
  alert_policy_id       = var.alert_policy_id
  runbook_url           = "https://runbooks.internal/cluster2"
  cluster_name          = "eu-west-cluster"
  create_private_location = true
  services = [
    { name = "user-service", url = "user.eu-west.internal" },
    { name = "billing-api",  url = "billing.eu-west.internal" },
  ]
}
