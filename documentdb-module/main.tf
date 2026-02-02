# DocumentDB Module

# Random password for DocumentDB admin user
resource "random_password" "docdb_password" {
  length  = 16
  special = true
}

# Secrets Manager secret to store DocumentDB credentials
resource "aws_secretsmanager_secret" "docdb" {
  name        = "${var.name_prefix}-${var.environment}-docdb-secret"
  description = "DocumentDB credentials for ${var.environment} environment"
  tags        = var.tags
}
# Add a version of the secret with actual credentials
resource "aws_secretsmanager_secret_version" "docdb" {
  secret_id     = aws_secretsmanager_secret.docdb.id
  secret_string = jsonencode({
    username = "proshop_admin"
    password = random_password.docdb_password.result
  })
}

# DocumentDB Cluster
resource "aws_docdb_cluster" "this" {
  cluster_identifier      = "${var.name_prefix}-${var.environment}-docdb-cluster"
  engine                  = "docdb"
  engine_version          = "5.0.0"
  master_username         = "proshop_admin"
  master_password         = random_password.docdb_password.result
  db_subnet_group_name    = aws_docdb_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.documentdb.id]
  skip_final_snapshot     = true
  apply_immediately       = true
  storage_encrypted       = false
}

# DocumentDB Cluster Instances
resource "aws_docdb_cluster_instance" "this" {
  count              = var.instance_count
  identifier         = "${var.name_prefix}-${var.environment}-docdb-instance-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class
  apply_immediately  = true
}