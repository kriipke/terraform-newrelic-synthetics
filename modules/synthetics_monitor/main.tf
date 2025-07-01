resource "newrelic_synthetics_private_location" "this" {
  count        = var.create_private_location ? 1 : 0
  name         = var.cluster_name
  description  = "Private location for ${var.cluster_name}"
  enabled      = true
  account_id   = var.account_id
}
resource "newrelic_synthetics_monitor" "this" {
  for_each = {
    for service in var.services : service.name => service
  }

  name       = "${each.value.name} /version"
  type       = "SIMPLE"
  frequency  = 10
  status     = "ENABLED"
  uri        = "https://${each.value.url}/version"
  sla_threshold = 7.0

  dynamic "locations_public" {
    for_each = length(each.value.locations_public) > 0 ? [each.value.locations_public] : []
    content {
      locations_public = locations_public.value
    }
  }

  dynamic "locations_private" {
    for_each = length(each.value.locations_private) > 0 ? [each.value.locations_private] :
      (var.create_private_location ? [[newrelic_synthetics_private_location.this[0].name]] : [])
    content {
      locations_private = locations_private.value
    }
  }

  script = <<EOT
$http.get("${each.value.url}/version", {
  headers: {
    "User-Agent": "NR-Synthetics-TF"
  }
});
EOT
}



resource "newrelic_nrql_alert_condition" "this" {
  for_each = newrelic_synthetics_monitor.this

  account_id = var.account_id
  policy_id  = var.alert_policy_id
  type       = "static"
  name       = "Synthetics Failure - ${each.value.name}"
  runbook_url = var.runbook_url

  enabled    = true
  violation_time_limit = "ONE_HOUR"

  nrql {
    query = <<EOT
FROM SyntheticCheck 
SELECT count(*) 
WHERE monitorName = '${each.value.name} /version' AND result = 'FAILED'
EOT
  }

  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}