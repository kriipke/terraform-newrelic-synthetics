output "monitor_ids" {
  description = "Map of service name to monitor ID"
  value = {
    for name, monitor in newrelic_synthetics_monitor.this :
    name => monitor.id
  }
}