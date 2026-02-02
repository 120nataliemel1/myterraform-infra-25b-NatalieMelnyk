# DO NOT REMOVE DUMMY MODULE references and their code, they should remain as examples
module "module1" {
  source = "../../dummy-module-1"
  # ... any required variables for module1
  greeting = var.greeting

}

module "module2" {
  source = "../../dummy-module-2"

  input_from_module1 = module.module1.greeting_message
  # ... any other required variables for module2
}



module "developer_iam_role" {
  source         = "../../IAM-role-module"
  environment    = var.environment
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "Developer${var.environment}AccessRole-ubuntu25b"
  policy_json    = var.DeveloperAccessRolePolicy
}

module "devops_iam_role" {
  source         = "../../IAM-role-module"
  environment    = var.environment
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "Devops${var.environment}AccessRole-ubuntu25b"
  policy_json    = var.DevopAccessRolePolicy
}

#FOR TEST PURPOSES ONLY NEXT IAM ROLE BLOCKS FOR PRODUCTION NEED TO BE REMOVED WHEN WE HAVE PRODUCTION ACCOUNT

module "developer_prod_role" {
  source         = "../../IAM-role-module"
  environment    = "Prod"
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "DeveloperProdAccessRole-ubuntu25b"
  policy_json    = "DeveloperProdAccessRole.json"
}

module "devops_prod_role" {
  source         = "../../IAM-role-module"
  environment    = "Prod"
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "DevopsProdAccessRole-ubuntu25b"
  policy_json    = "DevopsProdAccessRole.json"
}

#--------------------------------------
