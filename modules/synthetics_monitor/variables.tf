variable "account_id" {
  type        = string
  description = "New Relic account ID"
}

variable "alert_policy_id" {
  type        = string
  description = "New Relic alert policy ID"
}

variable "runbook_url" {
  type        = string
  default     = "https://example.com/runbook"
}

variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster"
}

variable "create_private_location" {
  type        = bool
  default     = true
  description = "Whether to create a new private location"
}

variable "services" {
  type = list(object({
    name = string
    url  = string
  }))
  description = "List of services in the cluster to monitor"
}
