# org/outputs.tf

output "security_tooling_account_id" {
  description = "Account ID of security-tooling, the delegated admin for org security services."
  value       = aws_organizations_account.security_tooling.id
}

output "workload_account_id" {
  description = "Account ID of the workload member account."
  value       = aws_organizations_account.workload.id
}