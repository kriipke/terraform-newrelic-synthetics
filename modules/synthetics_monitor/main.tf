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

  name                 = "${each.value.name} /version"
  type                 = "SIMPLE"
  frequency            = 10
  status               = "ENABLED"
  uri                  = "https://${each.value.url}/version"
  locations_public     = each.value.locations_public
  locations_private    = (
    length(each.value.locations_private) > 0
      ? each.value.locations_private
      : (
          var.create_private_location
            ? [newrelic_synthetics_private_location.this[0].name]
            : []
        )
  )
  sla_threshold        = 7.0

  script = <<EOT
$http.get("${each.value.url}/version", {
  headers: {
    "User-Agent": "NR-Synthetics-TF"
  }
});
EOT
}

resource "newrelic_synthetics_alert_condition" "this" {
  for_each = newrelic_synthetics_monitor.this

  policy_id                   = var.alert_policy_id
  name                        = "Synthetics Failure - ${each.value.name}"
  monitor_id                  = each.value.id
  runbook_url                 = var.runbook_url
  enabled                     = true
  violation_time_limit_seconds = 3600

  terms {
    threshold              = "1"
    threshold_duration     = 300
    threshold_occurrences  = "ALL"
    operator               = "equal"
    priority               = "CRITICAL"
  }
}