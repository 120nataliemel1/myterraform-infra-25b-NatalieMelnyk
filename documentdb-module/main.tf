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

resource "aws_secretsmanager_secret_version" "docdb" {
  secret_id     = aws_secretsmanager_secret.docdb.id
  secret_string = jsonencode({
    username = "proshop_admin"
    password = random_password.docdb_password.result
  })
}