# org/variables.tf
variable "security_tooling_email" {
  type        = string
  description = "Root email for the security-tooling account (plus-addressed)."
}

variable "workload_email" {
  type        = string
  description = "Root email for the workload account (plus-addressed)."
}

variable "budget_alert_email" {
  type        = string
  description = "Email address to receive budget alerts."
}