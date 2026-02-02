#Secutity Group for DocumentDB
resource "aws_security_group" "documentdb" {
name        = "${var.name_prefix}-documentdb-sg"
description = "Security group for DocumentDB cluster"
vpc_id      = var.vpc_id`

`ingress {
description     = "Allow MongoDB traffic from EKS nodes"
from_port       = 27017
to_port         = 27017
protocol        = "tcp"
security_groups = [var.eks_node_sg_id]
}`

`egress {
from_port   = 0
to_port     = 0
protocol    = "-1"
cidr_blocks = ["0.0.0.0/0"]
}`

`tags = merge(var.tags, {
Name = "${var.name_prefix}-documentdb-sg"
})
}`

#DocumentDb Subnet Group
resource "aws_docdb_subnet_group" "this" {
  name       = "${var.name}-docdb-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = var.tags
}

