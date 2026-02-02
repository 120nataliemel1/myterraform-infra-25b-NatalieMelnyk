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


module "developer_dev_role" {
  source         = "../../iam_roles"
  environment    = "dev"
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "DeveloperAccessRole"
  policy_json    = "DeveloperDevAccessRole.json"
}

module "devops_dev_role" {
  source         = "../../iam_roles"
  environment    = "dev"
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "DevopsAccessRole"
  policy_json    = "DevopsDevAccessRole.json"
}

module "developer_prod_role" {
  source         = "../../iam_roles"
  env            = "prod"
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "DevopsAccessRole"
  policy_json    = "DeveloperProdAccessRole.json"
}

module "devops_prod_role" {
  source         = "../../iam_roles"
  env            = "prod"
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "DevopsAccessRole"
  policy_json    = "DevopsProdAccessRole.json"
}