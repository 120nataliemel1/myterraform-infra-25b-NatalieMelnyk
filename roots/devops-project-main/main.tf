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

module "rds_mysql" {
  source = "../../rds-mysql"

  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_name              = var.db_name
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  publicly_accessible  = var.publicly_accessible
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  multi_az             = var.multi_az
  storage_type         = var.storage_type
  tags                 = var.tags
}
