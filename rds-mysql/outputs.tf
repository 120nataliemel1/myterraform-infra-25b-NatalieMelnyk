output "rds_endpoint" {
  value = aws_db_instance.rds_mysql_versus.endpoint
}

output "rds_identifier" {
  value = aws_db_instance.rds_mysql_versus.id
}
