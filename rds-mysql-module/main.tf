##############################
# AWS RDS MySQL instance
##############################

resource "aws_db_instance" "rds_mysql_versus" {
  identifier              = var.identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  db_name                 = var.db_name
  username                = var.username
  password                = random_password.db_password.result
  parameter_group_name    = var.parameter_group_name
  publicly_accessible     = var.publicly_accessible
  db_subnet_group_name    = var.db_subnet_group_name
  vpc_security_group_ids  = [aws_security_group.rds_mysql_versus_sg.id]
  multi_az                = var.multi_az
  storage_type            = var.storage_type
  allocated_storage       = var.allocated_storage
  backup_retention_period = var.db_backup_retention_period
  deletion_protection     = var.deletion_protection
  backup_window           = var.db_backup_window
  skip_final_snapshot     = true

  tags = var.tags
}

# Generate a random password for the RDS instance
resource "random_password" "db_password" {
  length  = 12
  special = false
}

# Store the generated password in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_secret" {
  name        = "${var.identifier}-mysql-credentials"
  description = "Access to database for Versus application"

  tags = var.tags
}

# Create a new version of the secret with the database credentials
resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id

  secret_string = jsonencode({
    username = var.username
    password = random_password.db_password.result
    host     = aws_db_instance.rds_mysql_versus.address
    port     = aws_db_instance.rds_mysql_versus.port
    db_name  = var.db_name
  })
}

# Db subnet group and security group for RDS instance
resource "aws_db_subnet_group" "rds_mysql_versus_subnet_group" {
  name        = var.db_subnet_group_name
  description = "RDS subnet group for Versus app"
  subnet_ids  = var.db_subnet_ids

  tags = var.tags
}

resource "aws_security_group" "rds_mysql_versus_sg" {
  name        = var.db_security_group_name
  description = "Security group for Versus MySQL RDS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from application SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# Output the RDS endpoint for application connectivity
output "endpoint" {
  value = aws_db_instance.rds_mysql_versus.endpoint
}

# Output the RDS SG ID for reference in root module
output "rds_security_group_id" {
  value = aws_security_group.rds_mysql_versus_sg.id
}