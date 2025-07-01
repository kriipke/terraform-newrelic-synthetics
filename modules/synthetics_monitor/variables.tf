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
  description = "List of services to monitor"
  type = list(object({
    name              = string
    url               = string
    locations_public  = optional(list(string), [])
    locations_private = optional(list(string), [])
  }))

  validation {
    condition = alltrue([
      for s in var.services :
      (
        length(try(s.locations_public, [])) > 0 ||
        length(try(s.locations_private, [])) > 0
      )
    ])

    error_message = "Each service must specify at least one public or private location."
  }
}