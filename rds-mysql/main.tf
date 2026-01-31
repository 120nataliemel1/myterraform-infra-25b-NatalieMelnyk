resource "aws_db_instance" "this" {
  allocated_storage    = var.allocated_storage
  engine              = var.engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  db_name             = var.db_name
  username            = var.username
  password            = var.password
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot = true
  publicly_accessible = var.publicly_accessible
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  multi_az            = var.multi_az
  storage_type        = var.storage_type
  tags                = var.tags
}

output "endpoint" {
  value = aws_db_instance.this.endpoint
}
