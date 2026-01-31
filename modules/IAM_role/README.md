# IAM-role

This repository contains Terraform code to define and manage AWS IAM roles and policies.

## Guidelines

1. In `.tfvars` you define a map of roles and their permissions.
2. The root module uses `for_each` to call the IAM role module for each entry.
3. The child module builds IAM roles, policies, and attaches them.
4. Policies include an Allow block and (optionally) a Deny block for secrets. Default set to deny access to secrets.

## Example `.tfvars` Files

iam_roles = {
  DevopsDevAccessRole = {
    principal_type      = "AWS"
    principal           = "arn:aws:iam::123456789012:root"
    action              = ["*"]
    resource            = ["*"]
    enable_secrets_deny = false
  }
}

## Example `main.tf` Files

module "iam_roles" {
  source   = "../modules/IAM_role"
  for_each = var.iam_roles

  name     = each.key        
  principal_type = each.value.principal_type
  principal      = each.value.principal
  service  = each.value.service
  action   = each.value.action
  resource = each.value.resource
  enable_secrets_deny = each.value.enable_secrets_deny
}