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

module "iam_roles" {
  source   = "../child/iam-roles"
  for_each = var.iam_roles

  name     = each.key        
  principal_type = each.value.principal_type
  principal      = each.value.principal
  service  = each.value.service
  action   = each.value.action
  resource = each.value.resource
}
