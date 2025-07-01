# synthetics_monitor


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

This Terraform module creates New Relic Synthetics monitors and alert conditions to validate `/version` endpoints for services deployed across Kubernetes clusters. Each cluster can be defined as a **private location**, and each service can be configured with specific **public and/or private locations**.

## 📦 Resources

- `newrelic_synthetics_private_location`
- `newrelic_synthetics_monitor`
- `newrelic_synthetics_alert_condition`

---

## ✅ Inputs

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `account_id` | `string` | New Relic account ID | ✅ |
| `alert_policy_id` | `string` | ID of the New Relic alert policy to attach to conditions | ✅ |
| `cluster_name` | `string` | Name of the Kubernetes cluster (used for private location name) | ✅ |
| `create_private_location` | `bool` | Whether to create a new private location for this cluster | ❌ (default: `true`) |
| `runbook_url` | `string` | Optional runbook URL to attach to alert conditions | ❌ |
| `services` | `list(object)` | List of services to monitor (see structure below) | ✅ |

### 👇 `services` object structure

```hcl
services = [
  {
    name              = "auth-service",
    url               = "auth.my-internal.com",
    locations_public  = ["AWS_US_EAST_1"],
    locations_private = ["my-private-location"]
  }
]