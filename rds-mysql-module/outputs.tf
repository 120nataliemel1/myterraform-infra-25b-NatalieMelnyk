# Output the RDS resource details for application connectivity and root module reference
output "rds_endpoint" {
  value = aws_db_instance.rds_mysql_versus.endpoint
}

output "rds_identifier" {
  value = aws_db_instance.rds_mysql_versus.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds_mysql_versus_sg.id
}