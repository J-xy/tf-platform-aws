# org/budgets.tf — budgets live in the management account so members can't
# see or delete the alarms that watch them.

data "aws_caller_identity" "current" {}

locals {
  member_accounts = {
    security-tooling = aws_organizations_account.security_tooling.id
    workload         = aws_organizations_account.workload.id
  }
}

resource "aws_sns_topic" "budget_alerts" {
  name = "org-budget-alerts"
}

resource "aws_sns_topic_subscription" "budget_email" {
  topic_arn = aws_sns_topic.budget_alerts.arn
  protocol  = "email"
  endpoint  = var.budget_alert_email
}

resource "aws_budgets_budget" "member" {
  for_each = local.member_accounts

  name         = "member-${each.key}-monthly"
  budget_type  = "COST"
  limit_amount = "5"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filter {
    name   = "LinkedAccount"
    values = [each.value]
  }

  notification { # money already spent
    comparison_operator       = "GREATER_THAN"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.budget_alerts.arn]
  }

  notification { # on track to exceed: warns before the money is gone
    comparison_operator       = "GREATER_THAN"
    threshold                 = 100
    threshold_type            = "PERCENTAGE"
    notification_type         = "FORECASTED"
    subscriber_sns_topic_arns = [aws_sns_topic.budget_alerts.arn]
  }
}

# YOUR PART: let AWS Budgets publish to the topic, and nothing else.
# data "aws_iam_policy_document" "budget_publish" { ... }
# resource "aws_sns_topic_policy" "budget_alerts" { arn = ..., policy = ... }
data "aws_iam_policy_document" "budget_publish" {
  statement {
    sid       = "AllowBudgetsPublishFromThisAccount"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.budget_alerts.arn]

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_sns_topic_policy" "budget_alerts" {
  arn    = aws_sns_topic.budget_alerts.arn
  policy = data.aws_iam_policy_document.budget_publish.json
}