## Sandbox path for week 3 (2026-10-11)

Decision: Option A, a live AWS Organizations sandbox.
Org state found: o-xaljr9y4g9 (feature set ALL, SCPs enabled), management account
964291633585, no members yet, account quota 10, IAM Identity Center org instance
in us-east-2.

Why: A real org proves behavior a mock can only assert: delegated admin moving
GuardDuty, Security Hub and Inspector administration to security-tooling, org
auto-enable enrolling workload with no per-account setup, and workload findings
reaching the Security Hub aggregator. It also shows real log volume and which
signals are worth detecting on.

Cost controls: Services and the Config recorder are applied, evidenced and
destroyed in the same session; the accounts persist. Config records only 5 listed
resource types. Each account has a $5 monthly budget with an SNS alert. Trial windows
are checked in the console before enabling.

What this gives up: Two member accounts that can't be cleanly deleted (closed
accounts count against the quota for a while). The management account also holds
state and CI, and SCPs can't constrain it (T6). Cross-account access starts with
the admin OrganizationAccountAccessRole, to be replaced by a scoped role.

Account IDs: kept in terraform.tfvars, gitignored, never committed.