# DO NOT REMOVE DUMMY MODULE references and their code, they should remain as examples
# module "module1" {
#   source = "../../dummy-module-1"
#   # ... any required variables for module1
#   greeting = var.greeting

# }

# module "module2" {
#   source = "../../dummy-module-2"

#   input_from_module1 = module.module1.greeting_message
#   # ... any other required variables for module2
# }

module "vpc-module" {

  source = "../../vpc-module"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

}

# module "eks-module" {
#   source = "../eks-module"

#   }