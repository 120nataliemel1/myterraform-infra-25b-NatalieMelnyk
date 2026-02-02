# DocumentDB Module

# Random password for DocumentDB admin user
resource "random_password" "docdb_password" {
  length  = 16
  special = true
}
