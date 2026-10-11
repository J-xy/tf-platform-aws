# org/main.tf
resource "aws_organizations_account" "security_tooling" {
  name              = "security-tooling"
  email             = var.security_tooling_email
  role_name         = "OrganizationAccountAccessRole"
  close_on_deletion = false # destroy tries RemoveAccountFromOrganization, not CloseAccount; it fails without standalone billing, so the account survives

  lifecycle {
    prevent_destroy = true # terraform errors on any plan that would destroy or replace this account
  }
}

resource "aws_organizations_account" "workload" {
  name              = "workload"
  email             = var.workload_email
  role_name         = "OrganizationAccountAccessRole"
  close_on_deletion = false # destroy tries RemoveAccountFromOrganization, not CloseAccount; it fails without standalone billing, so the account survives

  lifecycle {
    prevent_destroy = true # terraform errors on any plan that would destroy or replace this account
  }
}